// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart' as setting;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:altea/app/core/utils/settings.dart' as settings;

import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/call_screen/controllers/call_screen_controller.dart';
import 'package:altea/app/modules/call_screen/controllers/signaling.dart';
import 'package:altea/app/modules/call_screen/views/mobile_web_view/models/chat_message_model.dart';
import 'package:altea/app/modules/call_screen/views/mobile_web_view/widgets/mw_chat_card.dart';
import 'package:altea/app/modules/my_consultation_detail/models/my_consultation_detail_model.dart';
import 'package:altea/app/modules/onboard_end_call/controllers/onboard_end_call_controller.dart';
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:altea/app/routes/app_pages.dart';
import '../../../../core/utils/use_shared_pref.dart';

class MobileWebCallScreen extends StatefulWidget {
  const MobileWebCallScreen({
    Key? key,
    required this.callIdFromArgs,
    required this.callIdForRoom,
    required this.orderIdFromParam,
    required this.callType,
  }) : super(key: key);
  final String callIdFromArgs;
  final String callIdForRoom;
  final String orderIdFromParam;
  final String callType;

  @override
  _MobileWebCallScreenState createState() => _MobileWebCallScreenState();
}

class _MobileWebCallScreenState extends State<MobileWebCallScreen> {
  final PanelController _pc = PanelController();
  final OnboardEndCallController onboardEndCallController = Get.find<OnboardEndCallController>();
  Signaling signaling = Signaling();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool connectionEstablished = false;
  String roomId = "";
  bool callerA = false;
  bool callerB = false;
  bool isConnectedAll = false;

  String callId = '';
  final Stopwatch stopWatchWaitMA = Stopwatch()..start();
  Stopwatch stopWatchOnCall = Stopwatch();
  Timer? timer;

  final FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
  final patientName = Get.arguments["patientName"];

  CollectionReference calls = FirebaseFirestore.instance.collection('calls');

  final controller = Get.find<CallScreenController>();
  final PatientDataController patientDataController = Get.find<PatientDataController>();
  String sType = "";

  bool isNew = true;
  bool isLastDC = false;
  Future<void> initCallid() async {
    final Map<String, dynamic> res = await getDataConsultationDetail();
    MyConsultationDetail? myConsultationDetail;
    if (res != {}) {
      myConsultationDetail = MyConsultationDetail.fromJson(res);
    }
    //check rejoin
    final checkRoom = await calls.where("orderId", isEqualTo: widget.orderIdFromParam).get();
    sType = widget.callType.toLowerCase().contains('doc') ? "doctor" : "MA";
    if (checkRoom.docs.isNotEmpty) {
      // print("ROOM-nya ada, nda perlu collection baru");
      setState(() {
        callId = checkRoom.docs.first.id;
        isNew = false;
        isLastDC = (checkRoom.docs.first.data()! as Map<String, dynamic>)['lastDC'].toString() == "patient";
        roomId = (checkRoom.docs.first.data()! as Map<String, dynamic>)['roomId'].toString();
      });

      // print("$isLastDC ${(checkRoom.docs.first.data()! as Map<String, dynamic>)['lastDC'].toString()}");

      await calls.doc(callId).set({
        'name': 'Call for $sType from $patientName',
        'callerA': true,
        'callerB': false,
      }, SetOptions(merge: true));
      // print("hasilnya ini bos : callId : $callId, isNew : $isNew, roomId : $roomId");
    } else {
      final DocumentReference docRef = await calls.add({
        'name': 'Call for $sType from $patientName', // John Doe
        'callerA': true, // Stokes and Sons
        'callerB': false,
        'callActive': true, // 42
        "isCallerAShareScreen": false,
        "isCallerBShareScreen": false,
        'isAlteaClick': false,
        "chatACount": 0,
        "chatBCount": 0,
        "maName": "",
        "orderId": widget.orderIdFromParam,
        "isCallerAOnline": false,
        "isCallerBOnline": false,
        "isMAFinished": false,
        "doctorId": myConsultationDetail?.doctor?.id ?? "",
        "doctorSchedule": myConsultationDetail?.schedule?.date.toString() ?? "",
        "callerId": myConsultationDetail?.patientId, //patient id terus
        "calleeId": myConsultationDetail?.doctor?.id ?? "", //doctor id terus
        "isCallOngoing": true,
        "lastDC": "",
        "roomId": "",
      });
      callScreenController.theCaller.value = true;
      // print("docref $docRef");
      setState(() {
        callId = docRef.id;
      });
    }
    callScreenController.patientName.value = patientName.toString();
  }

  Future<Map<String, dynamic>> getDataConsultationDetail() async {
    final token = AppSharedPreferences.getAccessToken();
    // print("order id -> $orderId");

    try {
      final response = await http.get(
          Uri.parse(
            // "${setting.alteaURL}/appointment/detail/${widget.orderIdFromParam}",
            "${setting.alteaURL}/appointment/v1/consultation/${widget.orderIdFromParam}",
          ),
          headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"});
      if (response.statusCode == 200) {
        // print("get consultation");
        return jsonDecode(response.body)['data'] as Map<String, dynamic>;

        // return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        // print("get data consul web 02 not found?");
        Get.toNamed("/err_404");
        return {};
      }
    } catch (e) {
      // print("get data consul web 500");
      // print(e.toString());
      Get.toNamed("/err_404");
      // print(e);
      return {};
    }
  }

  Future<void> doctorHasDisconnected() async {
    // print('si Doctor hilang');
    await _fireStoreDataBase.collection('calls').doc(callId).set({
      'callerB': false,
      "isAlteaClick": false,
      "maName": "",
      "lastDC": "altea",
    }, SetOptions(merge: true));
    Future.delayed(const Duration(seconds: 1), () {
      final String orderId = Get.parameters.containsKey('orderId') ? Get.parameters['orderId'].toString() : "";
      Get.offNamed(
        "/call-loading?orderId=$orderId&type=$sType&name=${controller.patientName.value}",
      );
    });
  }

  Future<void> maHasDisconnected() async {
    // print('si MA hilang');
    await _fireStoreDataBase.collection('calls').doc(callId).set({
      "lastDC": "altea",
      "isCallOngoing": false,
      "callActive": false,
      "maName": "",
    }, SetOptions(merge: true));
  }

  Future<void> initRoom() async {
    await signaling.initiateStream();

    await signaling.openUserMedia(_localRenderer, _remoteRenderer);
    MyConsultationDetail? myConsultationDetail; //? CEK INI UDAH BENAR DITAROH DISINI? AKU BARU TAMBAHIN WKWKWK
    String theCallerName = "";
    String prefixNameForRoom = "";
    if (widget.callIdFromArgs.toLowerCase() == "doctor") {
      prefixNameForRoom = "Call for doctor from";
    } else {
      prefixNameForRoom = "Call from";
    }
    if (patientDataController.selectedPatientData.value.firstName != null && patientDataController.selectedPatientData.value.lastName != null) {
      theCallerName = " ${patientDataController.selectedPatientData.value.firstName} ${patientDataController.selectedPatientData.value.lastName}";
    } else {}
    await initCallid();
    if (!isLastDC) {
      String ss = '';
      try {
        ss = await signaling.createRoom(callId, _remoteRenderer);
      } catch (e) {
        Get.dialog(Dialog(
          child: Center(
              child: Column(children: [
            const Text("create room gagal"),
            Text(
              e.toString(),
            ),
          ])),
        ));
      }

      setState(() {
        roomId = ss;
      });
      await _fireStoreDataBase.collection('calls').doc(callId).set({
        'callActive': true,
        "isAlteaClick": false,
        "maName": "",
      }, SetOptions(merge: true));
      // print("room id di create karena lawan DC : $roomId");
    } else {
      setState(() {
        roomId = roomId;
      });
      try {
        await signaling.joinRoom(callId, roomId.toString(), _remoteRenderer);
      } catch (e) {
        Get.dialog(Dialog(child: Center(child: Column(children: [const Text("join room gagal"), Text(e.toString())]))));
      }
      await _fireStoreDataBase.collection('calls').doc(callId).set({
        'callActive': true,
        "isAlteaClick": false,
        // "maName": "",
      }, SetOptions(merge: true));
      // print("join room karena last dc = patient : id di join : $roomId");
    }
    await calls.doc(callId).set({'roomId': roomId}, SetOptions(merge: true));

    signaling.peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        setState(() {
          isMaInside = false;
        });

        // final String patientName = data['name']
        //     .toString()
        //     .substring(10, data['name'].toString().length);

        Fluttertoast.showToast(
          msg: "Medical Advisor ${controller.maName.value} disconnected. You can end the call to make a new consultation with new Medical Advisor",
          backgroundColor: Colors.grey,
          textColor: Colors.red.shade50,
          webShowClose: true,
          timeInSecForIosWeb: 8,
          fontSize: 13,
          gravity: ToastGravity.BOTTOM_RIGHT,
          toastLength: Toast.LENGTH_LONG,
          webBgColor: '#808080',
        );
        if (sType.toLowerCase() == "doctor") {
          doctorHasDisconnected();
        } else {
          maHasDisconnected();
        }

        // Future.delayed(Duration(seconds: 8), () {
        //   closeCall();
        // });

      } else if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        setState(() {
          isMaInside = true;
        });
        // print("MA ADA CONNECT? $isMaInside");

        // reconnectCallerB();
      }
    };
  }

  Future<void> closeCall() async {
    await _fireStoreDataBase.collection('calls').doc(callId).set({
      'callActive': false,
      'isCallOngoing': false,
    }, SetOptions(merge: true));
    try {
      await signaling.hangUp(callId, roomId, _localRenderer);
    } catch (e) {
      // print("signaling hangup error");
      // print(e.toString());
    }

    try {
      final List<MediaStreamTrack> tracks = _localRenderer.srcObject!.getTracks();
      for (final track in tracks) {
        track.stop();
      }
    } catch (e) {
      // print('media stream track error');
      // print(e.toString());
    }
    stopWatchWaitMA.stop();
    stopWatchOnCall.stop();
    try {
      await _localRenderer.dispose();
      _localRenderer.srcObject = null;
      await _remoteRenderer.dispose();
    } catch (e) {
      // print("dispose renderer failed");
      // print(e.toString());
    }
    await afterCloseCall();

    // Get.offNamed(Routes.ONBOARD_END_CALL);

    // Get.back();
  }

  Future<void> afterCloseCall() async {
    if (callId == 'doctor' || widget.callIdFromArgs.toLowerCase() == "doctor") {
      // Get.toNamed('/doctor-success-screen', arguments: formatTime(stopWatchOnCall.elapsedMilliseconds));
      Get.offNamed("${Routes.DOCTOR_SUCCESS_SCREEN}?orderId=${widget.orderIdFromParam}",
          arguments: {"elapsedTime": formatTime(stopWatchOnCall.elapsedMilliseconds), "orderId": widget.orderIdFromParam});
    } else {
      onboardEndCallController.checkMyConsultationStatusForNTimes(
        status: setting.waitingForPayment,
        times: 3,
        orderId: widget.orderIdFromParam,
      );
      Get.offNamed("${Routes.ONBOARD_END_CALL}?orderId=${widget.orderIdFromParam}", arguments: formatTime(stopWatchOnCall.elapsedMilliseconds));
    }
  }

  // CollectionReference calls = FirebaseFirestore.instance.collection('calls');
  TextEditingController chatBoxCtrl = TextEditingController();
  FocusNode chatBoxFocus = FocusNode();
  ScrollController scrollCtrl = ScrollController();
  final CallScreenController callController = Get.find<CallScreenController>();
  final dateFormat = DateFormat('hh:mm');
  UploadTask? task;

  String message = '';

  bool isMaInside = false;

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    signaling.onAddRemoteStream = (stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    };

    connectAndListenToSocket();

    initRoom();

    if (controller.isMeDisconnect.value) {
      Future.delayed(const Duration(seconds: 5), checkEndCall);
    }
    // checkEndCall();
    super.initState();
  }

  Map<String, dynamic>? optionBuilderQuery;

  io.Socket? socket;
  void disposeSocket() {
    socket?.disconnect();
    socket?.close();
    socket?.destroy();
    socket?.dispose();
  }

  Future<void> setOptionBuilder() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("access_token") ?? "";
    optionBuilderQuery = {
      "query": {'method': 'CALL_MA', 'appointmentId': widget.orderIdFromParam.toString()},
      'transports': ['websocket'],
      'auth': {'token': 'Bearer $token'},
      'autoConnect': false,
      'reconnectionAttempts': 99,
      'path': '/socket.io',
    };
  }

  void connectAndListenToSocket() async {
    await setOptionBuilder();

    // final SharedPreferences sp = await SharedPreferences.getInstance();
    // String token = sp.getString("access_token") ?? "";
    // // print("Bearer $token");
    // socket = io.io(
    //   "${settings.alteaSocketURL}",
    //   io.OptionBuilder()
    //       .setQuery({
    //         "method": "CALL_MA",
    //         "appointmentId": widget.orderIdFromParam.toString(),
    //       })
    //       // .setExtraHeaders({'foo': 'bar'})
    //       .setTransports(
    //         ['websocket'],
    //       )
    //       .setAuth({
    //         "token": "Bearer $token",
    //       })
    //       .disableAutoConnect()
    //       // .setReconnectionDelay(2000)
    //       .setReconnectionAttempts(99)
    //       .enableReconnection()
    //       .build(),
    // );

    try {
      socket?.connect();
    } catch (e) {
      // print("SOCKET : err catch $e");
    }

    socket?.onConnect((_) {
      // print('SOCKET : connect');
      socket?.emit('msg', 'test');
    });

    //When an event recieved from server, data is added to the stream
    socket?.onDisconnect((_) {
      // print('SOCKET : disconnect');
      socket?.dispose();
    });

    socket?.onConnectError((data) {
      // print("SOCKET : error connect : $data");
      closeCall();
    });

    socket?.on(settings.SOCKET_EVENT_CALL_CONSULTATION_ANSWERED, (data) {
      // print("SOCKET : ${settings.SOCKET_EVENT_CALL_CONSULTATION_ANSWERED} : $data");
    });

    socket?.on(settings.SOCKET_EVENT_CALL_MA_ANSWERED, (data) {
      // print("SOCKET : ${settings.SOCKET_EVENT_CALL_MA_ANSWERED} : $data");
    });

    socket?.on(settings.SOCKET_EVENT_ERROR, (data) {
      // print("SOCKET : ${settings.SOCKET_EVENT_ERROR} : $data");
      closeCall();
    });

    socket?.on(settings.SOCKET_EVENT_ME, (data) {
      // print("SOCKET : ${settings.SOCKET_EVENT_ME} : $data");
    });

    socket?.onDisconnect((_) {
      // print('disconnect');
    });
  }

  void checkEndCall() {
    // print("MASUK CEK END CALL");
    if (callId.isNotEmpty) {
      final myStream = _fireStoreDataBase.collection('calls').doc(callId).snapshots();
      myStream.listen((dataa) {
        // print("call active -> ${dataa.data()!["callActive"]}");
        if (dataa.data()!["callActive"] == false && dataa.data()!["isCallOngoing"] == false) {
          signaling.hangUp(callId, roomId, _localRenderer);
          closeCall();
          // Get.offNamed(Routes.ONBOARD_END_CALL);
        }
      });
    }
  }

  @override
  void dispose() {
    disposeSocket();
    stopWatchWaitMA.stop();
    stopWatchOnCall.stop();
    _localRenderer.dispose();
    _remoteRenderer.dispose();

    timer?.cancel();
    super.dispose();
  }

  String formatTime(int milliseconds) {
    final int secs = milliseconds ~/ 1000;
    final String minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    final String seconds = (secs % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  bool isPanelOpen = false;
  final screenWidth = Get.width;
  final callScreenController = Get.find<CallScreenController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;

    return WillPopScope(
      onWillPop: () async {
        if (_pc.isPanelOpen) {
          _localRenderer.renderVideo;
          // print("Panelnya open");
          await _pc.close();
          setState(() {
            isPanelOpen = false;
          });
          return false;
        } else {
          // print("panelnya close");

          Get.dialog(
            AlertDialog(
              title: Text("Keluar dari Call"),
              content: Container(
                padding: EdgeInsets.all(16),
                child: Text('Apakah anda yakin mau keluar dari call ini? '),
              ),
              actions: [
                CustomFlatButton(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 80,
                  text: 'Keluar',
                  onPressed: () async {
                    closeCall();
                    Get.back();
                    Get.back();
                  },
                  color: kButtonColor,
                ),
                CustomFlatButton(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 80,
                  text: 'Batal',
                  onPressed: () {
                    Get.back();
                  },
                  color: kBackground,
                  borderColor: kButtonColor,
                ),
              ],
            ),
          );
          return false;
        }
      },
      child: Scaffold(
        floatingActionButton: isPanelOpen
            ? Container(
                height: 70,
                decoration: BoxDecoration(
                  boxShadow: [kBoxShadow],
                  color: kBackground,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: IconButton(
                          icon: const Icon(
                            Icons.add,
                            size: 20,
                            color: kBlackColor,
                          ),
                          onPressed: () async {
                            await pickFile();
                          },
                        ),
                      ),
                    ),
                    if (callId.isEmpty)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      Expanded(
                        flex: 6,
                        child: Container(
                          child: TextField(
                            // onTap: () {
                            //   Timer(const Duration(milliseconds: 300),
                            //       () => scrollCtrl.jumpTo(scrollCtrl.position.maxScrollExtent));
                            // },
                            controller: chatBoxCtrl,
                            focusNode: chatBoxFocus,
                            onChanged: (val) {
                              message = val;
                            },
                            onSubmitted: (s) async {
                              message = s;
                              // print("$message di enter ");
                              if (message != '' && message != ' ') {
                                await calls.doc(callId).collection('chat').add(
                                  {
                                    "message": message,
                                    "type": "text",
                                    "time": FieldValue.serverTimestamp(),
                                    "sender": "callerA",
                                  },
                                );
                                final DocumentSnapshot notif = await calls.doc(callId).get();
                                await calls.doc(callId).update(
                                  {"chatBCount": ((notif.data()! as Map)['chatBCount'] as int) + 1},
                                );
                                chatBoxCtrl.clear();
                                message = "";
                              }
                              scrollCtrl.jumpTo(scrollCtrl.position.maxScrollExtent + 70);
                            },
                            decoration: InputDecoration(
                              hintText: 'Add text to this message',
                              hintStyle: kPoppinsRegular400.copyWith(
                                fontSize: 13,
                                color: kBlackColor,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          size: 20,
                          color: kBlackColor,
                        ),
                        onPressed: () async {
                          if (message != '' && message != ' ') {
                            await calls.doc(callId).collection('chat').add(
                              {
                                "message": message,
                                "type": "text",
                                "time": FieldValue.serverTimestamp(),
                                "sender": "callerA",
                              },
                            );
                            final DocumentSnapshot notif = await calls.doc(callId).get();
                            await calls.doc(callId).update({"chatBCount": ((notif.data()! as Map)['chatBCount'] as int) + 1});
                            chatBoxCtrl.clear();
                            message = "";
                          }
                          scrollCtrl.jumpTo(scrollCtrl.position.maxScrollExtent + 70);
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: true,
        body: (callId != '')
            ? ConnectivityBuilder(
                builder: (context, isConnected, status) {
                  // print("ISCONNECTED NYA APA NIH? $isConnected");
                  if (isConnected == false) {
                    if (controller.isMeDisconnect.value == false) {
                      Fluttertoast.showToast(
                        msg: "You are disconnected, will leave the room soon....",
                        backgroundColor: Colors.red.withOpacity(0.2),
                        textColor: Colors.red,
                        webShowClose: true,
                        timeInSecForIosWeb: 8,
                        fontSize: 13,
                        gravity: ToastGravity.TOP,
                        webPosition: 'center',
                        toastLength: Toast.LENGTH_SHORT,
                        webBgColor: '#F8FCF5',
                      );
                    }

                    controller.isMeDisconnect.value = true;
                    Future.delayed(
                      const Duration(seconds: 4),
                      () async {
                        controller.isMeDisconnect.value = true;

                        await signaling.localStream?.dispose();
                        signaling.localStream = null;

                        await signaling.peerConnection?.close();
                        signaling.peerConnection = null;

                        // if (isConnected == true) {
                        //   await signaling.hangUp(
                        //       widget.callId, roomId, _localRenderer);
                        // }

                        await afterCloseCall();
                        Get.defaultDialog(
                          title: "Call Disconnected",
                          middleText: "Please check your wifi/signal condition...",
                          backgroundColor: Colors.white,
                          titleStyle: const TextStyle(color: Colors.green),
                          middleTextStyle: const TextStyle(color: Colors.black),
                        );
                      },
                    );

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: InteractiveViewer(
                                maxScale: 4,
                                minScale: 0.5,
                                child: SizedBox(
                                  width: Get.width,
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: CallScreenEndCallAndTimeSectionMobileWeb(
                            screenWidth: screenWidth,
                            endCall: closeCall,
                            passedFunction: () {
                              Get.dialog(
                                AlertDialog(
                                  title: const Text("Keluar dari Call"),
                                  content: Container(
                                    padding: const EdgeInsets.all(16),
                                    child: const Text('Apakah anda yakin mau keluar dari call ini? '),
                                  ),
                                  actions: [
                                    CustomFlatButton(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        text: 'Keluar',
                                        onPressed: () async {
                                          closeCall();
                                        },
                                        color: kButtonColor),
                                    CustomFlatButton(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      text: 'Batal',
                                      onPressed: () {
                                        Get.back();
                                      },
                                      color: kBackground,
                                      borderColor: kButtonColor,
                                    ),
                                  ],
                                ),
                              );
                            },
                            time: formatTime(stopWatchOnCall.elapsedMilliseconds),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: CallScreenNavigationSectionMobileWeb(
                            screenWidth: screenWidth,
                            localRenderer: _localRenderer,
                            remoteRenderer: _remoteRenderer,
                            signaling: signaling,
                            callId: callId,
                            passedFunction: () async {
                              setState(() {
                                isPanelOpen = true;
                              });
                              await _pc.open();
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            margin: const EdgeInsets.only(bottom: 100),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return SlidingUpPanel(
                      minHeight: 0,
                      maxHeight: MediaQuery.of(context).size.height,
                      controller: _pc,
                      panel: SafeArea(
                        child: SizedBox(
                          height: Get.height,
                          child: callId.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : Column(
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      const Text("Chat"),
                                      IconButton(
                                        onPressed: () {
                                          _pc.close();
                                        },
                                        icon: const Icon(Icons.close),
                                      ),
                                    ]),
                                    // CHAT SECTION
                                    Expanded(
                                      // bottom: 60,
                                      child: SingleChildScrollView(
                                        controller: scrollCtrl,
                                        child: Container(
                                          height: MediaQuery.of(context).size.height - 130,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            boxShadow: [kBoxShadow],
                                            color: kBackground,
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          child: StreamBuilder<QuerySnapshot>(
                                              stream: calls.doc(callId).collection('chat').orderBy('time').snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  List chats = snapshot.data!.docs;
                                                  return ListView.builder(
                                                    // physics: const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: chats.length,
                                                    itemBuilder: (context, idx) {
                                                      if ((idx + 1) == chats.length) {
                                                        scrollCtrl.animateTo(
                                                          scrollCtrl.position.maxScrollExtent,
                                                          duration: const Duration(
                                                            seconds: 1,
                                                          ),
                                                          curve: Curves.easeIn,
                                                        );
                                                      }
                                                      return MWChatCard(ChatMessage(
                                                        message: chats[idx].data()['message'].toString(),
                                                        type: chats[idx].data()['type'].toString(),
                                                        sender: chats[idx].data()['sender'].toString(),
                                                        time: chats[idx].data()['time'] == null
                                                            ? ""
                                                            : dateFormat.format((chats[idx].data()['time'] as Timestamp).toDate()).toString(),
                                                        name: chats[idx].data()['name'].toString(),
                                                      ));
                                                    },
                                                  );
                                                } else if (snapshot.data == null) {
                                                  return Container();
                                                } else {
                                                  return const CircularProgressIndicator();
                                                }
                                              }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      body: (callId.isEmpty)
                          ? Container()
                          : StreamBuilder<DocumentSnapshot>(
                              stream: _fireStoreDataBase.collection('calls').doc(callId).snapshots(),
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  callerA = snapshot.data!['callerA'] as bool;
                                  callerB = snapshot.data!['callerB'] as bool;
                                  callScreenController.callerA.value = snapshot.data!['isCallerAShareScreen'] as bool;
                                  callScreenController.callerB.value = snapshot.data!['isCallerBShareScreen'] as bool;
                                  callScreenController.theCaller.value = snapshot.data!['isCallerAShareScreen'] as bool;

                                  if (!isConnectedAll && callerA && callerB) {
                                    stopWatchOnCall.start();
                                    Fluttertoast.showToast(
                                      msg: "Silakan tunggu. Sedang menyambungkan koneksi",
                                      backgroundColor: kBackground,
                                      textColor: kButtonColor,
                                      timeInSecForIosWeb: 12,
                                      fontSize: 14,
                                      gravity: ToastGravity.CENTER,
                                      webPosition: 'center',
                                      toastLength: Toast.LENGTH_LONG,
                                      webBgColor: '#F8FCF5',
                                    );
                                    isConnectedAll = true;
                                  }
                                  if (!callScreenController.isOpenChatContainer.value) {
                                    callScreenController.chatCount.value = snapshot.data!['chatACount'] as int;
                                  }
                                  return callerA && callerB
                                      ? (!isMaInside)
                                          ? Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                Column(
                                                  children: [
                                                    Expanded(
                                                      child: InteractiveViewer(
                                                        maxScale: 4,
                                                        minScale: 0.5,
                                                        child: RTCVideoView(
                                                          _localRenderer,
                                                          mirror: true,
                                                          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Align(
                                                    alignment: Alignment.topCenter,
                                                    child: CallScreenEndCallAndTimeSectionMobileWeb(
                                                      screenWidth: screenWidth,
                                                      endCall: closeCall,
                                                      passedFunction: () {
                                                        Get.dialog(
                                                          AlertDialog(
                                                            title: const Text("Keluar dari Call"),
                                                            content: Container(
                                                              padding: const EdgeInsets.all(16),
                                                              child: const Text('Apakah anda yakin mau keluar dari call ini? '),
                                                            ),
                                                            actions: [
                                                              CustomFlatButton(
                                                                  width: MediaQuery.of(context).size.width * 0.3,
                                                                  text: 'Keluar',
                                                                  onPressed: () async {
                                                                    closeCall();
                                                                  },
                                                                  color: kButtonColor),
                                                              CustomFlatButton(
                                                                width: MediaQuery.of(context).size.width * 0.3,
                                                                text: 'Batal',
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                color: kBackground,
                                                                borderColor: kButtonColor,
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      time: formatTime(stopWatchOnCall.elapsedMilliseconds),
                                                    )),
                                                Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: CallScreenNavigationSectionMobileWeb(
                                                    screenWidth: screenWidth,
                                                    localRenderer: _localRenderer,
                                                    remoteRenderer: _remoteRenderer,
                                                    signaling: signaling,
                                                    callId: callId,
                                                    passedFunction: () async {
                                                      setState(() {
                                                        isPanelOpen = true;
                                                      });
                                                      await _pc.open();
                                                    },
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 25),
                                                    margin: const EdgeInsets.only(bottom: 100),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                            // padding: const EdgeInsets.all(5),
                                                            // decoration: BoxDecoration(
                                                            //   borderRadius: BorderRadius.circular(10),
                                                            //   color: kBlackColor.withOpacity(
                                                            //     0.5,
                                                            //   ),
                                                            // ),
                                                            // child: TextButton.icon(
                                                            //   onPressed: () {
                                                            //     signaling.changeAudioState(_localRenderer, _remoteRenderer, !controller.audioState.value);
                                                            //     controller.audioState.value = !controller.audioState.value;
                                                            //   },
                                                            //   icon: Obx(() => controller.audioState.value
                                                            //       ? SizedBox(width: 14, child: Image.asset("assets/on_mic_icon.png"))
                                                            //       : SizedBox(width: 14, child: Image.asset("assets/mute_mic_icon.png"))),
                                                            //   label: Text(
                                                            //     "",
                                                            // "Silvia GP Escort",
                                                            //     style: kPoppinsRegular400.copyWith(color: kBackground, fontSize: 11),
                                                            //   ),
                                                            // ),
                                                            ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          : Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                Column(
                                                  children: [
                                                    Expanded(
                                                      child: InteractiveViewer(
                                                        maxScale: 4,
                                                        minScale: 0.5,
                                                        constrained: true,
                                                        child: RTCVideoView(
                                                          _remoteRenderer,
                                                          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Align(
                                                    alignment: Alignment.topCenter,
                                                    child: CallScreenEndCallAndTimeSectionMobileWeb(
                                                      screenWidth: screenWidth,
                                                      endCall: closeCall,
                                                      passedFunction: () {
                                                        Get.dialog(
                                                          AlertDialog(
                                                            title: Text("Keluar dari Call"),
                                                            content: Container(
                                                              padding: EdgeInsets.all(16),
                                                              child: Text('Apakah anda yakin mau keluar dari call ini? '),
                                                            ),
                                                            actions: [
                                                              CustomFlatButton(
                                                                  width: MediaQuery.of(context).size.width * 0.3,
                                                                  text: 'Keluar',
                                                                  onPressed: () async {
                                                                    closeCall();
                                                                  },
                                                                  color: kButtonColor),
                                                              CustomFlatButton(
                                                                width: MediaQuery.of(context).size.width * 0.3,
                                                                text: 'Batal',
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                color: kBackground,
                                                                borderColor: kButtonColor,
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      time: formatTime(stopWatchOnCall.elapsedMilliseconds),
                                                    )),
                                                Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: CallScreenNavigationSectionMobileWeb(
                                                    screenWidth: screenWidth,
                                                    localRenderer: _localRenderer,
                                                    remoteRenderer: _remoteRenderer,
                                                    signaling: signaling,
                                                    callId: callId,
                                                    passedFunction: () async {
                                                      setState(() {
                                                        isPanelOpen = true;
                                                      });
                                                      await _pc.open();
                                                    },
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 25),
                                                    margin: const EdgeInsets.only(bottom: 100),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                            // padding: const EdgeInsets.all(5),
                                                            // decoration: BoxDecoration(
                                                            //   borderRadius: BorderRadius.circular(10),
                                                            //   color: kBlackColor.withOpacity(
                                                            //     0.5,
                                                            //   ),
                                                            // ),
                                                            // child: TextButton.icon(
                                                            //   onPressed: () {
                                                            //     signaling.changeAudioState(_localRenderer, _remoteRenderer, !controller.audioState.value);
                                                            //     controller.audioState.value = !controller.audioState.value;
                                                            //   },
                                                            //   icon: Obx(() => controller.audioState.value
                                                            //       ? SizedBox(width: 14, child: Image.asset("assets/on_mic_icon.png"))
                                                            //       : SizedBox(width: 14, child: Image.asset("assets/mute_mic_icon.png"))),
                                                            //   label: Text(
                                                            //     "",
                                                            // "Silvia GP Escort",
                                                            //     style: kPoppinsRegular400.copyWith(color: kBackground, fontSize: 11),
                                                            //   ),
                                                            // ),
                                                            ),
                                                        const Spacer(),
                                                        Container(
                                                          // width:  Get.width / 3,
                                                          // height: Get.height / 5,
                                                          width: 140,
                                                          height: 150,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(width: 3, color: kBackground),
                                                            borderRadius: BorderRadius.circular(15),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(10),
                                                            child: Column(
                                                              children: [
                                                                Expanded(
                                                                  child: RTCVideoView(
                                                                    _localRenderer,
                                                                    mirror: true,
                                                                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                      : Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: MediaQuery.of(context).size.width / 6,
                                                backgroundColor: kButtonColor,
                                                child: CircleAvatar(
                                                  radius: MediaQuery.of(context).size.width / 6.3,
                                                  backgroundColor: kBackground,
                                                  child: const Icon(Icons.question_answer),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text((widget.callIdFromArgs.toLowerCase() == "doctor")
                                                  ? 'Waiting for Doctor'
                                                  : 'Waiting for Medical Advisor'),
                                              Text(
                                                formatTime(stopWatchWaitMA.elapsedMilliseconds),
                                                style: kPoppinsSemibold600.copyWith(
                                                  fontSize: 20,
                                                  color: kDarkBlue,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              CustomFlatButton(
                                                borderColor: kButtonColor,
                                                width: screenWidth * 0.67,
                                                text: "Cancel",
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                color: kBackground,
                                              )
                                            ],
                                          ),
                                        );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                    );
                  }
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Future pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    PlatformFile? objFile;

    if (result != null) {
      final Uint8List fileBytes = result.files.first.bytes!;
      objFile = result.files.single;

//? Check file type , only accept [PDF, Jpg, Png, Mic office]
      final type = lookupMimeType(objFile.name, headerBytes: fileBytes.cast());

      if (type!.contains("audio") || type.contains("video") || type.contains("gif")) {
        Get.dialog(
          CustomSimpleDialog(
            icon: SizedBox(
              width: 250,
              child: Image.asset("assets/failed_icon.png"),
            ),
            onPressed: () {
              Get.back();
            },
            title: 'Format file tidak didukung',
            buttonTxt: 'Saya Mengerti',
            subtitle: "Harap mengirimkan file dengan format [PDF,JPG,PNG,DOCS,Excel,PPT]",
          ),
        );
      } else {
        final resultResponse = await uploadFile(fileBytes: fileBytes, objFile: objFile);
      }
    } else {
      return null;
    }
  }

  /// this function is to upload/change profile photo in profile altea
  Future uploadFile({required Uint8List fileBytes, PlatformFile? objFile}) async {
    // isLoading.value = true;

    final List<int> dataImage = fileBytes.cast();

    final destination = "chatFiles/${objFile!.name}";
    final type = lookupMimeType(objFile.name, headerBytes: dataImage);

    // print("FILE TYPE -> $type");

    task = callController.uploadBytes(destination, fileBytes);
    if (task == null) {
      return;
    }

    final snapshot = await task!.whenComplete(() {});
    final urlFileChat = await snapshot.ref.getDownloadURL();

    // print("url file -> $urlFileChat");

    if (type!.contains("image")) {
      await calls.doc(callId).collection('chat').add(
        {"message": urlFileChat, "type": "image", "time": FieldValue.serverTimestamp(), "sender": "callerA", "name": objFile.name},
      );
      final DocumentSnapshot notif = await calls.doc(callId).get();
      await calls.doc(callId).update(
        {"chatBCount": ((notif.data()! as Map)['chatBCount'] as int) + 1},
      );
    } else {
      await calls.doc(callId).collection('chat').add({
        "message": urlFileChat,
        "type": "file",
        "time": FieldValue.serverTimestamp(),
        "sender": "callerA",
        "name": objFile.name,
      });

      final DocumentSnapshot notif = await calls.doc(callId).get();
      await calls.doc(callId).update({"chatBCount": ((notif.data()! as Map)['chatBCount'] as int) + 1});
    }
  }
}

// class CallScreenEndCallAndTimeSectionMobileWeb extends StatefulWidget {
//   const CallScreenEndCallAndTimeSectionMobileWeb({
//     Key? key,
//     required this.screenWidth,
//     required this.endCall,
//   }) : super(key: key);

//   final double screenWidth;
//   final VoidCallback endCall;

//   @override
//   _CallScreenEndCallAndTimeSectionMobileWebState createState() => _CallScreenEndCallAndTimeSectionMobileWebState();
// }

typedef void PassedFunction();

class CallScreenEndCallAndTimeSectionMobileWeb extends StatelessWidget {
  const CallScreenEndCallAndTimeSectionMobileWeb({
    Key? key,
    required this.screenWidth,
    required this.endCall,
    required this.time,
    required this.passedFunction,
  }) : super(key: key);

  final double screenWidth;
  final VoidCallback endCall;
  final String time;
  final PassedFunction passedFunction;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBlackColor.withOpacity(0.5),
      height: 60,
      width: screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.43,
          ),
          Text(time, style: kPoppinsSemibold600.copyWith(color: kBackground, fontSize: 16)),
          const Spacer(),
          Container(
            width: 82,
            height: 30,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(primary: kRedError, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                onPressed: () {
                  passedFunction();
                },
                child: Text(
                  "End Call",
                  style: kPoppinsMedium500.copyWith(color: kBackground, fontSize: 11),
                )),
          )
        ],
      ),
    );
  }
}

class CallScreenNavigationSectionMobileWeb extends StatelessWidget {
  CallScreenNavigationSectionMobileWeb({
    Key? key,
    required this.screenWidth,
    required this.signaling,
    required this.localRenderer,
    required this.remoteRenderer,
    required this.callId,
    required this.passedFunction,
  }) : super(key: key);

  final double screenWidth;
  final Signaling signaling;
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;
  final String callId;
  final PassedFunction passedFunction;

  final callScreenController = Get.find<CallScreenController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBlackColor.withOpacity(0.5),
      height: 80,
      width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          CallCameraButton(
            localRenderer: localRenderer,
            remoteRenderer: remoteRenderer,
            signaling: signaling,
          ),
          const SizedBox(
            width: 18,
          ),
          CallMicButton(
            localRenderer: localRenderer,
            remoteRenderer: remoteRenderer,
            signaling: signaling,
          ),
          const SizedBox(
            width: 18,
          ),
          // CallShareScreenButton(
          //   signaling: signaling,
          //   localRenderer: localRenderer,
          //   callId: callId,
          // ),
          // const SizedBox(
          //   width: 18,
          // ),
          Obx(
            () => Stack(
              children: [
                CallChatButton(
                  callId: callId,
                  passedFunction: () => passedFunction(),
                ),
                if (callScreenController.chatCount.value > 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: kRedError,
                      ),
                      child: Center(
                        child: Text(callScreenController.chatCount.value.toString(),
                            style: kPoppinsRegular400.copyWith(
                              color: kBackground,
                            )),
                      ),
                    ),
                  )
                else
                  const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CallMoreOptionsButton extends StatelessWidget {
  const CallMoreOptionsButton({Key? key, required this.passedFunction}) : super(key: key);

  final PassedFunction passedFunction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        passedFunction();
      },
      child: Container(
        width: 53,
        height: 53,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kBlackColor.withOpacity(0.5),
        ),
        child: Image.asset("assets/call_camera_switch.png"),
      ),
    );
  }
}

class CallChatButton extends StatelessWidget {
  final String callId;
  final PassedFunction passedFunction;
  const CallChatButton({
    Key? key,
    required this.callId,
    required this.passedFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CollectionReference calls = FirebaseFirestore.instance.collection('calls');

    final controller = Get.find<CallScreenController>();
    return InkWell(
      onTap: () async {
        controller.isOpenChatContainer.value = !controller.isOpenChatContainer.value;
        await calls.doc(callId).update({'chatACount': 0});
        controller.chatCount.value = 0;
        passedFunction();
      },
      child: Container(
        width: 53,
        height: 53,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kBlackColor.withOpacity(0.5),
        ),
        child: Image.asset("assets/chat_icon.png"),
      ),
    );
  }
}

class CallShareScreenButton extends StatelessWidget {
  const CallShareScreenButton({
    Key? key,
    required this.signaling,
    required this.localRenderer,
    required this.callId,
  }) : super(key: key);

  final Signaling signaling;
  final RTCVideoRenderer localRenderer;
  final String callId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        signaling.shareScreen(localRenderer, callId);
      },
      child: Container(
        width: 53,
        height: 53,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kBlackColor.withOpacity(0.5),
        ),
        child: Image.asset("assets/share_screen_icon.png"),
      ),
    );
  }
}

class CallMicButton extends GetView<CallScreenController> {
  const CallMicButton({
    Key? key,
    required this.signaling,
    required this.localRenderer,
    required this.remoteRenderer,
  }) : super(key: key);

  final Signaling signaling;
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // controller.isMicOn.value = !controller.isMicOn.value;
        signaling.changeAudioState(localRenderer, remoteRenderer, !controller.audioState.value);
        controller.audioState.value = !controller.audioState.value;
      },
      child: Container(
        width: 53,
        height: 53,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kBlackColor.withOpacity(0.5),
        ),
        child: Obx(() => controller.audioState.value ? Image.asset("assets/on_mic_icon.png") : Image.asset("assets/mute_mic_icon.png")),
      ),
    );
  }
}

class CallCameraButton extends GetView<CallScreenController> {
  const CallCameraButton({
    Key? key,
    required this.signaling,
    required this.localRenderer,
    required this.remoteRenderer,
  }) : super(key: key);

  final Signaling signaling;
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        signaling.changeVideoState(localRenderer, remoteRenderer, !controller.videoState.value);
        controller.videoState.value = !controller.videoState.value;
        // controller.isCameraOn.value = !controller.isCameraOn.value;
      },
      child: Container(
        width: 53,
        height: 53,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kBlackColor.withOpacity(0.5),
        ),
        child: Obx(() => controller.videoState.value ? Image.asset("assets/on_cam_icon.png") : Image.asset("assets/off_cam_icon.png")),
      ),
    );
  }
}
