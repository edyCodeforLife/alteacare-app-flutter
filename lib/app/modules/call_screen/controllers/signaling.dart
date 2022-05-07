// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart' as getx;
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

// Project imports:
import 'package:altea/app/modules/call_screen/controllers/call_screen_controller.dart';

typedef StreamStateCallback = void Function(MediaStream stream);

class Signaling {
  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': ["stun:stun.sprout.codes:5349"],
        'username': "sprout",
        'credential': "344EEF2351BADF49DD4EC6AEDCE21"
      },
      {
        'urls': ["turn:turn.sprout.codes:5349"],
        'username': "sprout",
        'credential': "344EEF2351BADF49DD4EC6AEDCE21"
      }
    ]
  };
  final callScreenController = getx.Get.find<CallScreenController>(); // web

  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  String? roomId;
  String? currentRoomText;
  StreamStateCallback? onAddRemoteStream;
  // getx.RxBool mirror = true.obs;

  MediaStream? stream; // ini untuk get userMedia

  Future<void> initiateStream() async {
    // assign stream for once
    print('get user media~');
    stream = await navigator.mediaDevices.getUserMedia({
      // 'video': {"facingMode": "user"},
      'video': true,
      'audio': true,
      'echoCancellation': true,
      'noiseSuppression': true,
    });
    if (getx.GetPlatform.isAndroid) {
      try {
        await startForegroundService();
      } catch (e) {
        print("err foreground from init state stream $e");
      }
    }

    // print("FIRST INIT STREAM -> ${stream?.id}");
  }

  Future<void> startForegroundService() async {
    await FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription: 'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
        buttons: [
          const NotificationButton(id: 'sendButton', text: 'Send'),
          const NotificationButton(id: 'testButton', text: 'Test'),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        autoRunOnBoot: true,
        allowWifiLock: true,
      ),
      printDevLog: true,
    );
  }

  Future<String> createRoom(String callId, RTCVideoRenderer remoteRenderer) async {
    print('create room with call id : $callId');
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DocumentReference roomRef = db.collection('calls').doc(callId).collection('rooms').doc();

    //? menyiapkan collection rooms yg ada di doc callId
    // print('Create PeerConnection with configuration: $configuration');

    //? create peer connection <-- dari webrtc
    peerConnection = await createPeerConnection(configuration);

    //? menyiapkan listener untuk state-state yg ada, ICE gathering, connection, stream
    registerPeerConnectionListeners();

    //? untuk di device kita, cek ada berapa track
    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });
    try {
      localStream?.getAudioTracks()[0].enableSpeakerphone(true);
      // print("localstream enable speakerphone true success");
    } catch (e) {
      // print("localstream enable speakerphone true failed : $e");
    }

    //? kode di bawah untuk mengambil ICE Candidates yang ada
    //? apa itu ICE Candidate dan kenapa itu perlu??
    //? kurang lebih, ICE teractive Connectivity Establishment candidate(s) itu
    //? kontrak / standard protokol yg harus disetujui biar koneksi RTC bisa nyambung
    //? https://developer.mozilla.org/en-US/docs/Web/API/RTCIceCandidate <-- cek di sini

    final callerCandidatesCollection = roomRef.collection('callerCandidates');

    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      // print('Got candidate: ${candidate.toMap()}');
      callerCandidatesCollection.add(candidate.toMap() as Map<String, dynamic>);
    };
    //? end collecting ICE Candidates

    //? setelah ICE candidates terbuat, baru buat room
    //? si Room buat offer yang akan dikirim ke DB, nanti si yang mau join melihat offer terus ngasih answer-nya
    final RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    // print('Created offer: $offer');

    final Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};
    await roomRef.set(roomWithOffer);
    final roomId = roomRef.id; //? room id ini sebenarnya document id-nya

    // print('New room created with SDK offer. Room ID: $roomId');
    currentRoomText = 'Current room is $roomId - You are the caller!';
    print(currentRoomText);
    //? sampai sini, room udah terbuat dan offer udah ditaruh di DB

    //? peer connection dipakai untuk ngecek dan menyiapkan sambungan dari _remoteRenderer
    //? kalo si room dapet handshake, bakal diminta stream dari si remote ini
    //? handshake-nya di sini mungkin ya?
    peerConnection?.onTrack = (RTCTrackEvent event) {
      print('Got remote track: ${event.streams[0]}');
      event.streams[0].getTracks().forEach((track) {
        print('Add a track to the remoteStream $track');
        remoteStream?.addTrack(track);
      });
    };

    // Listening for remote session description below
    //? di sini nge-listen apakah room-nya udah ada perubahan belum, apakah di collection ada perubahan di answer-nya
    roomRef.snapshots().listen((snapshot) async {
      // print('Got updated room: ${snapshot.data()}');

      if (snapshot.data() != null) {
        final Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;

        if (peerConnection?.getRemoteDescription() != null && data['answer'] != null) {
          final answer = RTCSessionDescription(
            data['answer']['sdp'] as String,
            data['answer']['type'] as String,
          );

          // print("Someone tried to connect");
          // print("answer sdp? ${answer.sdp}");
          // print("answer type? ${answer.type}");
          await peerConnection?.setRemoteDescription(answer);
          //? di sini si caller / pembuat room nerima answer-nya apa nda
          //? kalo nda diterima ya bakal ada error di sininya
        }
      } else {
        // print('Got updated room null: ${snapshot.data()}');
      }
    });
    // Listening for remote session description above

    // Listen for remote Ice candidates below
    //? di sini pada diambilin jawaban2 yg diberikan sama para callee / yang join
    //? di sini harus bisa ngasih tahu apakah document-nya berubah apa nda
    roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((DocumentChange<Map<String, dynamic>>? change) {
        if (change!.type == DocumentChangeType.added) {
          if (change.doc.data() != null && peerConnection != null) {
            final Map<String, dynamic> data = change.doc.data()!;
            print('Got new remote ICE candidate: ${jsonEncode(data)}');
            peerConnection!.addCandidate(
              RTCIceCandidate(
                data['candidate'] as String,
                data['sdpMid'] as String,
                data['sdpMLineIndex'] as int,
              ),
            );
          }
        }
      });
    });
    // Listen for remote ICE candidates above

    return roomId;
  }

  Future<void> joinRoom(String callId, String roomId, RTCVideoRenderer remoteVideo) async {
    //? tetep cek di db, collection room di call ID yg udah ada
    print('join room with callid : $callId');
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DocumentReference roomRef = db.collection('calls').doc(callId).collection('rooms').doc(roomId);
    final roomSnapshot = await roomRef.get();
    // print('Got room ${roomSnapshot.exists}');

    if (roomSnapshot.exists) {
      //? sama nih, coba siapkan peer connection dulu, cek semua stream di local yg bisa di-register/handshake
      // print('Create PeerConnection with configuration: $configuration');
      peerConnection = await createPeerConnection(configuration);
      registerPeerConnectionListeners();

      localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream!);
      });

      try {
        localStream?.getAudioTracks()[0].enableSpeakerphone(true);
        // print("localstream enable speakerphone true success");
      } catch (e) {
        // print("localstream enable speakerphone true failed : $e");
      }

      //? si yg join, ngambil ICE candidate yang udah dikasih si pembuat room / host-nya
      final calleeCandidatesCollection = roomRef.collection('calleeCandidates');
      peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) {
        if (candidate == null) {
          // print('onIceCandidate: complete!');
          return;
        }
        //? disetujuin sama si rtc
        // print('onIceCandidate: ${candidate.toMap()}');
        calleeCandidatesCollection.add(candidate.toMap() as Map<String, dynamic>);
      };
      // Code for collecting ICE candidate above

      //? ini untuk membuat / register remote stream ke punya kita
      peerConnection?.onTrack = (RTCTrackEvent event) {
        // print('Got remote track: ${event.streams[0]}');
        event.streams[0].getTracks().forEach((track) {
          // print('Add a track to the remoteStream: $track');
          remoteStream?.addTrack(track);
        });
      };

      // Code for creating SDP answer below
      //? di sini dari candidate2 yg ada, dan offer yg udah diterima, akan dibuat answer2 yg nantinya dikirim lagi
      final data = roomSnapshot.data()! as Map<String, dynamic>;
      // print('Got offer $data');
      final offer = data['offer'];
      //? ngambil remote description dari offer yg ada
      await peerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'] as String, offer['type'] as String),
      );
      final answer = await peerConnection!.createAnswer();
      // print('Created Answer $answer');

      await peerConnection!.setLocalDescription(answer);
      // print(answer.toMap().toString());

      final Map<String, dynamic> roomWithAnswer = {
        'answer': {'type': answer.type, 'sdp': answer.sdp}
      };
      //? update room dengan answer yg dibuat
      await roomRef.update(roomWithAnswer);
      // Finished creating SDP answer

      // Listening for remote ICE candidates below
      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((DocumentChange<Map<String, dynamic>>? document) {
          if (document != null) {
            final data = document.doc.data()!;
            // print(data);
            // print('Got new remote ICE candidate: $data');
            peerConnection!.addCandidate(
              RTCIceCandidate(
                data['candidate'] as String,
                data['sdpMid'] as String,
                data['sdpMLineIndex'] as int,
              ),
            );
          }
        });
      });
    }
  }

  // Future<void> startForegroundService() async {
  //   try {
  //     await FlutterForegroundPlugin.setServiceMethodInterval(seconds: 5);
  //     await FlutterForegroundPlugin.setServiceMethod(globalForegroundService);
  //     await FlutterForegroundPlugin.startForegroundService(
  //       holdWakeLock: false,
  //       onStarted: () {
  //         // print("Foreground on Started");
  //       },
  //       onStopped: () {
  //         // print("Foreground on Stopped");
  //       },
  //       title: "Tcamera",
  //       content: "Tcamera sharing your screen.",
  //       iconName: "ic_stat_mobile_screen_share",
  //     );
  //   } catch (e) {
  //     // print("START FOREGROUND ERR : $e");
  //   }
  //   // return true;
  // }

  static void globalForegroundService() {
    // print("current datetime is ${DateTime.now()}");
  }

  Future<void> stopForefroundService() async {
    try {
      // await FlutterForegroundPlugin.stopForegroundService();

    } catch (e) {
      // print(e.toString());
    }
  }

  Future stopShare(
    // RTCVideoRenderer renderer,
    RTCVideoRenderer localRenderer,
    String callId,
  ) async {
    // print('By adding a listener on onEnded you can: 1) catch stop video sharing on Web');
    await stopForefroundService();
    // onShareScreen.value = false;

    final mediaConstraintsCamera = <String, dynamic>{'video': true, 'audio': true, 'echoCancellation': true, 'noiseSuppression': true};

    final streamLocal = await navigator.mediaDevices.getUserMedia(mediaConstraintsCamera);
    // final streamLocal =
    //     await navigator.mediaDevices.getUserMedia(mediaConstraints);
    callScreenController.isShareScreen.value = false;

    callScreenController.videoState.value = true;
    localStream = streamLocal;
    localRenderer.srcObject = localStream;

    // set the local stream to take from camera video
    await peerConnection?.getSenders().then((senders) {
      senders.forEach((element) {
        if (element.track!.kind == 'video') {
          element.replaceTrack(localStream!.getVideoTracks()[0]);
          // element.replaceTrack();
        }
      });
      // mirror.value = false;
    });
    final dbCall = FirebaseFirestore.instance.collection("calls");

    // print("THE CALLER -> ${callScreenController.theCaller.value}");
    if (callScreenController.theCaller.value) {
      await dbCall.doc(callId).update({"isCallerAShareScreen": false});
      await dbCall.doc(callId).update({"isCallerBShareScreen": false});
    } else {
      await dbCall.doc(callId).update({"isCallerBShareScreen": false});
      await dbCall.doc(callId).update({"isCallerAShareScreen": false});
    }

    // final streamLocal = stream;
    // localStream = streamLocal;
    // renderer.srcObject = localStream;

    // await peerConnection?.getSenders().then((senders) {
    //   senders.forEach((element) {
    //     if (element.track!.kind == 'video') {
    //       element.replaceTrack(localStream!.getVideoTracks()[0]);
    //       // element.replaceTrack();
    //     }
    //   });
    //   // mirror.value = false;
    // });
  }

  /// this function is for handle the screen sharing function when call
  Future<void> shareScreen(
    RTCVideoRenderer localRenderer,
    String callId,
  ) async {
    // mirror.value = false;
    // onShareScreen.value = true;

    // print("mirror status -> ${mirror.value}");
    // print('masuk sharescreen');
    final mediaConstraints = <String, dynamic>{
      'audio': true,
      'video': {'maxFrameRate': '25'}
      // 'video': true,
    };
    final dbCall = FirebaseFirestore.instance.collection("calls");

    if (getx.GetPlatform.isWeb) {
      try {
        await startForegroundService();
      } catch (e) {
        print("err foreground from sharescreen $e");
      }
    }

    // DocumentSnapshot notif = await dbCall.doc(widget.callId).get();

    try {
      // print('media constraints => $mediaConstraints');

      final stream = await navigator.mediaDevices.getDisplayMedia(mediaConstraints);

      // final stream =
      //     await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
      // print('get stream ');
      // localStream!.dispose();
      localStream = null;

      callScreenController.videoState.value = false;
      callScreenController.isShareScreen.value = true;

      // for handle stop screen sharing

      localStream = stream;
      localRenderer.srcObject = localStream;

      await peerConnection?.getSenders().then((senders) {
        senders.forEach((element) {
          if (element.track!.kind == 'video') {
            element.replaceTrack(localStream!.getVideoTracks()[0]);
            // element.replaceTrack();
          }
        });
        // mirror.value = true;

        // print("mirror status -> ${mirror.value}");
      });
      if (callScreenController.theCaller.value) {
        // print("PASIEN SHARE SCREEN");
        await dbCall.doc(callId).update({"isCallerAShareScreen": true});
        await dbCall.doc(callId).update({"isCallerBShareScreen": false});
      } else {
        // print("ALTEA SHARE SCREEN");
        await dbCall.doc(callId).update({"isCallerBShareScreen": true});
        await dbCall.doc(callId).update({"isCallerAShareScreen": false});
      }
      stream.getVideoTracks()[0].onEnded = () async {
        // print('By adding a listener on onEnded you can: 1) catch stop video sharing on Web');

        // onShareScreen.value = false;

        final mediaConstraintsCamera = <String, dynamic>{'video': true, 'audio': true, 'echoCancellation': true, 'noiseSuppression': true};

        final streamLocal = await navigator.mediaDevices.getUserMedia(mediaConstraintsCamera);
        // final streamLocal =
        //     await navigator.mediaDevices.getUserMedia(mediaConstraints);
        callScreenController.isShareScreen.value = false;

        callScreenController.videoState.value = true;
        localStream = streamLocal;
        localRenderer.srcObject = localStream;

        // set the local stream to take from camera video
        await peerConnection?.getSenders().then((senders) {
          senders.forEach((element) {
            if (element.track!.kind == 'video') {
              element.replaceTrack(localStream!.getVideoTracks()[0]);
              // element.replaceTrack();
            }
          });
          // mirror.value = false;
        });

        // print("THE CALLER -> ${callScreenController.theCaller.value}");
        if (callScreenController.theCaller.value) {
          await dbCall.doc(callId).update({"isCallerAShareScreen": false});
          await dbCall.doc(callId).update({"isCallerBShareScreen": false});
        } else {
          await dbCall.doc(callId).update({"isCallerBShareScreen": false});
          await dbCall.doc(callId).update({"isCallerAShareScreen": false});
        }
      };
    } catch (e, sss) {
      // print(sss.toString());
      // print('err screenshare => ' + e.toString());
    }
  }

  Future<void> changeVideoState(RTCVideoRenderer localVideo, RTCVideoRenderer remoteVideo, bool video) async {
    if (video) {
      // await openUserMedia(localVideo, remoteVideo);
      // var stream = await navigator.mediaDevices.getUserMedia({
      //   'video': true,
      //   'audio': true,
      //   'echoCancellation': true,
      //   'noiseSuppression': true
      // });

      // localStream = stream;
      // localVideo.srcObject = stream;
      try {
        localStream!.getVideoTracks()[0].enabled = true;
      } catch (e) {
        print("err change videostate $e");
      }
    } else {
      // localStream!.getVideoTracks()[0].stop();
      try {
        localStream!.getVideoTracks()[0].enabled = false;
      } catch (e) {
        print('failed to change value in videostate :$e');
      }
      // await localStream?.dispose();
    }
    // if (video == true) {
    //   localStream!.getVideoTracks()[0].enabled = true;
    // } else {
    //   localStream!.getVideoTracks()[0].enabled = false;
    // }
  }

  Future<void> changeAudioState(RTCVideoRenderer localVideo, RTCVideoRenderer remoteVideo, audio) async {
    final bool enabled = localStream!.getAudioTracks()[0].enabled;
    localStream!.getAudioTracks()[0].enabled = !enabled;
  }

  Future<void> openUserMedia(
    RTCVideoRenderer localVideo,
    RTCVideoRenderer remoteVideo,
  ) async {
    // ) async {
    //   final stream = await navigator.mediaDevices
    //       .getUserMedia({'video': true, 'audio': true, 'echoCancellation': true, 'noiseSuppression': true});

    localVideo.srcObject = stream;
    localStream = stream;

    remoteVideo.srcObject = await createLocalMediaStream('key');
  }

  Future<void> changeVideo(RTCVideoRenderer localVideo, RTCVideoRenderer remoteVideo, video, audio) async {
    if (video == false && audio == false) {
      localVideo.srcObject = null;
      localStream = null;
    } else {
      // final stream = await navigator.mediaDevices.getUserMedia({'video': video, 'audio': audio});

      localVideo.srcObject = stream;
      localStream = stream;
    }
  }

  Future<void> disposeStream() async {
    try {
      await localStream?.dispose();
      localStream = null;
      await peerConnection?.close();
      peerConnection = null;
    } catch (e) {}
  }

  Future<void> hangUp(String callId, String? theRoom, RTCVideoRenderer localVideo) async {
    // print("MASUK HANG U NIHH");
    // final List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
    // tracks.forEach((track) {
    //   track.stop();
    // });

    // for (final track in tracks) {
    //   track.stop();
    // }

    // if (remoteStream != null) {
    //   remoteStream!.getTracks().forEach((track) {
    //     track.stop();
    //   });
    // }
    // localVideo.srcObject = null;

    // if (peerConnection != null) peerConnection!.close();

    try {
      await localStream?.dispose();
      localStream = null;

      await peerConnection?.close();
      peerConnection = null;

      // print("THE ROOM ->$theRoom");

      if (theRoom != null) {
        final db = FirebaseFirestore.instance;
        final roomRef = db.collection('calls').doc(callId).collection('rooms').doc(theRoom);
        final calleeCandidates = await roomRef.collection('calleeCandidates').get();
        calleeCandidates.docs.forEach((document) => document.reference.delete());

        final callerCandidates = await roomRef.collection('callerCandidates').get();
        callerCandidates.docs.forEach((document) => document.reference.delete());

        await roomRef.delete();
      }
    } catch (e) {
      // print("error catch -> $e");
    }

    // localStream!.getVideoTracks()[0].stop();
    // localStream!.getAudioTracks()[0].stop();

    // await localStream!.dispose();

    // await remoteStream?.dispose();

    // try {
    //   await localVideo.dispose();
    //   localVideo.srcObject = null;
    //   await remoteStream!.dispose();
    // } catch (e) {
    //   print(e.toString());
    // }
    // localStream!.dispose();
    // remoteStream?.dispose();
    // if (gets.GetPlatform.isWeb) {
    //   gets.Get.toNamed(Routes.ONBOARD_END_CALL);
    // }
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      // print('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      // print('Connection state change: $state');
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      // print('Signaling state change: $state');
    };

    // peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
    //   print('ICE connection state change: $state');
    // };

    peerConnection?.onAddStream = (MediaStream stream) {
      // print("Add remote stream helper");
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };

    peerConnection?.getRemoteStreams.call();
  }

  void switchCamera() async {
    if (localStream != null) {
      //helper dari package flutter_webrtc
      Helper.switchCamera(localStream!.getVideoTracks()[0]);
    }
  }

  void switchCameraFront() async {
    if (localStream != null) {
      localStream!.getVideoTracks()[0].label;
      //helper dari package flutter_webrtc
      Helper.switchCamera(localStream!.getVideoTracks()[0]);
    }
  }
}
