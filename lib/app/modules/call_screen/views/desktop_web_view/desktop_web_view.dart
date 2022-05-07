// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

// Flutter imports:
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
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mime/mime.dart';

// Project imports:
import 'package:altea/app/core/utils/settings.dart' as setting;
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/footer_section_view.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import 'package:altea/app/modules/my_consultation_detail/models/my_consultation_detail_model.dart';
import 'package:altea/app/modules/onboard_end_call/controllers/onboard_end_call_controller.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:altea/app/core/utils/settings.dart' as settings;
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/utils/use_shared_pref.dart';
import '../../../../routes/app_pages.dart';
import '../../controllers/call_screen_controller.dart';
import '../../controllers/signaling.dart';

typedef void PassedFunction();

class DesktopWebCallScreen extends StatefulWidget {
  const DesktopWebCallScreen({Key? key, required this.orderIdFromParam, required this.callType}) : super(key: key);
  final String orderIdFromParam;
  final String callType;

  @override
  _DesktopWebCallScreenState createState() => _DesktopWebCallScreenState();
}

class _DesktopWebCallScreenState extends State<DesktopWebCallScreen> {
  // final patientDataController = Get.find<PatientDataController>();
  final callScreenController = Get.find<CallScreenController>();
  String sType = "";

  final String patientName = Get.arguments["patientName"].toString();
  CollectionReference calls = FirebaseFirestore.instance.collection('calls');
  String callId = '';
  String roomId = "";
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
        'callActive': true,
        'callerA': true,
        'callerB': true,
        "maName": "",
      }, SetOptions(merge: true));
      // print("hasilnya ini bos : callId : $callId, isNew : $isNew, roomId : $roomId");

      callScreenController.theCaller.value = true;
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
      });
      callScreenController.theCaller.value = true;
      // print("docref $docRef");
      setState(() {
        callId = docRef.id;
      });
    }
    callScreenController.patientName.value = patientName.toString();
  }

  @override
  void initState() {
    super.initState();
    initCallid();
    callScreenController.callType.value = Get.arguments["callType"].toString(); // dekstop pake ini untuk handle call type MA/Doctor
  }

  @override
  void dispose() {
    super.dispose();
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
        Get.offAndToNamed("/err_404");
        return {};
      }
    } catch (e) {
      // print("get data consul web 500");
      // print(e.toString());
      Get.offAndToNamed("/err_404");
      // print(e);
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("arguments -> ${Get.arguments["patientName"]}");
    // print("arguments call type-> ${Get.arguments["callType"]}");

    return WillPopScope(
      onWillPop: () async {
        Future.delayed(Duration.zero, () {
          Get.offAndToNamed("/home");
        });
        return false;
      },
      child: callId.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CallScreenWidget(
              callId: callId,
              calls: calls,
              orderId: widget.orderIdFromParam,
              isNew: isNew,
              roomId: isNew ? "" : roomId,
              isReconnect: isLastDC,
              callType: sType.toString(),
              passedFunction: () {
                initCallid();
              }),
    );
  }
}

class CallScreenWidget extends StatefulWidget {
  const CallScreenWidget({
    Key? key,
    required this.callId,
    required this.calls,
    required this.orderId,
    required this.isNew,
    required this.roomId,
    required this.isReconnect,
    required this.callType,
    required this.passedFunction,
  }) : super(key: key);
  final String callId;
  final CollectionReference calls;
  final String orderId;
  final bool isNew;
  final String roomId;
  final bool isReconnect;
  final String callType;
  final PassedFunction passedFunction;
  @override
  _CallScreenWidgetState createState() => _CallScreenWidgetState();
}

class _CallScreenWidgetState extends State<CallScreenWidget> {
  Signaling signaling = Signaling();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool connectionEstablished = false;
  String? roomId;
  bool callerA = false;
  bool callerB = false;
  bool isConnectedAll = false;
  final OnboardEndCallController _onboardEndCallController = Get.find<OnboardEndCallController>();

  final FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
  io.Socket? socket;
  void disposeSocket() {
    socket?.disconnect();
    socket?.close();
    socket?.destroy();
    socket?.dispose();
  }

  Map<String, dynamic>? optionBuilderQuery;

  void connectAndListenToSocket() async {
    await setOptionBuilder();

    socket?.disconnect();
    socket?.close();
    socket?.destroy();
    socket = io.io(
      "${settings.alteaSocketURL}",
      optionBuilderQuery,
    );
    try {
      socket?.io.options['query'] = 'method=CALL_MA&appointmentId=${widget.orderId}';
    } catch (e) {
      print('error change options on SOCKET : $e');
    }
    // final SharedPreferences sp = await SharedPreferences.getInstance();
    // String token = sp.getString("access_token") ?? "";
    // print("Bearer $token");
    // socket = io.io(
    //   "${settings.alteaSocketURL}",
    //   io.OptionBuilder()
    //       .setQuery({
    //         "method": "CALL_MA",
    //         "appointmentId": widget.orderId.toString(),
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
      print('SOCKET : connect');
      print('SOCKET : ${socket?.opts}');
      socket?.emit('msg', 'test');
    });

    //When an event recieved from server, data is added to the stream
    socket?.onDisconnect((_) {
      // print('SOCKET : disconnect');
    });

    socket?.onConnectError((data) {
      // print("SOCKET : error connect : $data");
    });

    socket?.on(settings.SOCKET_EVENT_CALL_CONSULTATION_ANSWERED, (data) {
      // print("SOCKET : ${settings.SOCKET_EVENT_CALL_CONSULTATION_ANSWERED} : $data");
    });

    socket?.on(settings.SOCKET_EVENT_CALL_MA_ANSWERED, (data) {
      // print("SOCKET : ${settings.SOCKET_EVENT_CALL_MA_ANSWERED} : $data");
    });

    socket?.on(settings.SOCKET_EVENT_ERROR, (data) {
      // print("SOCKET : ${settings.SOCKET_EVENT_ERROR} : $data");

      // closeCall();
    });

    socket?.on(settings.SOCKET_EVENT_ME, (data) {
      // print("SOCKET : ${settings.SOCKET_EVENT_ME} : $data");
    });

    socket?.onDisconnect((_) {
      // print('disconnect');
    });
  }

  Future<void> setOptionBuilder() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("access_token") ?? "";
    optionBuilderQuery = {
      "query": {'method': 'CALL_MA', 'appointmentId': widget.orderId},
      'transports': ['websocket'],
      'auth': {'token': 'Bearer $token'},
      'autoConnect': false,
      'reconnectionAttempts': 99,
      'path': '/socket.io',
    };
  }

  // final patientDataController = Get.find<PatientDataController>();

  Future<void> initRoom() async {
    await signaling.initiateStream();

    await signaling.openUserMedia(_localRenderer, _remoteRenderer);
    // await signaling.changeVideo(_localRenderer, _remoteRenderer, true, true);

    if (widget.isNew && widget.roomId.isEmpty) {
      // print("widget.room == empty");

      roomId = await signaling.createRoom(widget.callId, _remoteRenderer);
      await _fireStoreDataBase.collection('calls').doc(widget.callId).set({
        'callActive': true,
        "isAlteaClick": false,
        "maName": "",
      }, SetOptions(merge: true));
    } else if (!widget.isReconnect) {
      setState(() {
        roomId = widget.roomId;
      });
      roomId = await signaling.createRoom(widget.callId, _remoteRenderer);
      await _fireStoreDataBase.collection('calls').doc(widget.callId).set({
        'callActive': true,
        "isAlteaClick": false,
        "maName": "",
      }, SetOptions(merge: true));
      // print("room id di create karena lawan DC : $roomId");
    } else {
      setState(() {
        roomId = widget.roomId;
      });
      await signaling.joinRoom(widget.callId, roomId.toString(), _remoteRenderer);
      await _fireStoreDataBase.collection('calls').doc(widget.callId).set({
        'callActive': true,
        "isAlteaClick": false,
        // "maName": "",
      }, SetOptions(merge: true));
      // print("join room karena last dc = patient : id di join : $roomId");
    }
    setState(() {});
    await widget.calls.doc(widget.callId).set({'roomId': roomId}, SetOptions(merge: true));
    // signaling.peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
    //   print('Connection state change: $state');
    //   if (state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
    //     disconnectCallerB();
    //   } else if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {}
    // };
    // }
  }

  // void reconnectCallerB() async {
  //   print('caller b ada');
  //   await _fireStoreDataBase.collection('calls').doc(widget.callId).set({
  //     'callerB': true,
  //   }, SetOptions(merge: true));
  //   // _fireStoreDataBase.collection('calls').doc(widget.callId).set({
  //   //   "callerB": true,
  //   // });
  // }

  final controller = Get.find<CallScreenController>();
  final homeController = Get.find<HomeController>();

  @override
  void initState() {
    connectAndListenToSocket();

    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = (stream) {
      // print("STREAM DARI REMOTE *****************");
      // print("STREAM DARI REMOTE ${stream.id}");

      _remoteRenderer.srcObject = stream;

      // print("REMOTE RENDERER -> ${_remoteRenderer.srcObject}");
      setState(() {});
    };

    initRoom();
    // if (controller.isMeDisconnect.value) {
    //   Future.delayed(const Duration(seconds: 5), checkEndCall);
    // }
    Future.delayed(const Duration(seconds: 5), checkEndCall);

    // checkEndCall();
    super.initState();
  }

  void checkEndCall() {
    // print("MASUK CEK END CALL");
    // print("IS CALLER END CALL? ${controller.isCallerEndCall.value}");
    // if (controller.isCallerEndCall.value) {
    //   print("MASUK CALLER YANG END");

    // } else {
    //   print("IS CALLER END CALL ELSE ? ${controller.isCallerEndCall.value}");
    // }

    if (widget.callId.isNotEmpty) {
      // print("MASUK CEK END CALL IF");

      final myStream = _fireStoreDataBase.collection('calls').doc(widget.callId).snapshots();
      myStream.listen((dataa) {
        // print("call active -> ${dataa.data()!["callActive"]}");
        if ((dataa.data()!["callActive"] == false) && dataa.data()!["isCallOngoing"] == false) {
          signaling.hangUp(widget.callId, roomId, _localRenderer);
          if (controller.callType.value == "callma") {
            // Get.delete<CallScreenController>();
            _onboardEndCallController.checkMyConsultationStatusForNTimes(
              status: setting.waitingForPayment,
              times: 3,
              orderId: widget.orderId,
            );
            Get.offNamed("${Routes.ONBOARD_END_CALL}?orderId=${widget.orderId}");
          } else {
            // Get.delete<CallScreenController>();

            Get.offNamed(Routes.DOCTOR_SUCCESS_SCREEN,
                arguments: {"elapsedTime": homeController.totalDurationCall.value, "orderId": controller.orderId.value});
          }
        }
      });
    }
  }

  @override
  void deactivate() {
    // print("MASUK DEACTIVATE");
    super.deactivate();
    _localRenderer.srcObject = null;
    _remoteRenderer.srcObject = null;
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  @override
  void dispose() {
    super.dispose();
    disposeSocket();
    signaling.stopForefroundService();
    signaling.disposeStream();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final callScreenController = Get.find<CallScreenController>();
    // print("call from doctor -> ${callScreenController.initCallDoctor.value}");

    final screenWidth = context.width;

    String formatTime(int milliseconds) {
      final secs = milliseconds ~/ 1000;
      final minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
      final seconds = (secs % 60).toString().padLeft(2, '0');

      return "$minutes:$seconds";
    }

    return Scaffold(
      body: (roomId == null)
          ? const Center(child: CircularProgressIndicator())
          : Obx(
              () => LoadingOverlay(
                isLoading: callScreenController.isDownloadLoading.value,
                progressIndicator: Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Downloading file, wait for a while...",
                        style: kPoppinsMedium500,
                      )
                    ],
                  ),
                ),
                child: ConnectivityBuilder(
                  builder: (context, isConnected, status) {
                    if (isConnected == false) {
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

                      Future.delayed(
                        const Duration(seconds: 4),
                        () async {
                          // print("MASUK SINI?");
                          // print("local stream ada? ${signaling.localStream?.active}");

                          controller.isMeDisconnect.value = true;

                          await signaling.localStream?.dispose();
                          signaling.localStream = null;

                          await signaling.peerConnection?.close();
                          signaling.peerConnection = null;

                          // if (isConnected == true) {
                          //   await signaling.hangUp(
                          //       widget.callId, roomId, _localRenderer);
                          // }

                          if (controller.callType.value == "callma") {
                            homeController.totalDurationCall.value = formatTime(controller.stopWatchElapsedTime);

                            Get.offAndToNamed(
                              "${Routes.ONBOARD_END_CALL}?orderId=${controller.orderIdFromParam}",
                              arguments: {
                                "elapsedTime": controller.stopWatchElapsedTime,

                                // "elapsedTime": homeController.totalDurationCall.value,
                                "orderId": controller.orderId.value,
                              },
                            );
                            // controller.refreshThisController();
                          } else {
                            Get.offAndToNamed(
                              Routes.MY_CONSULTATION,
                              arguments: {
                                "elapsedTime": controller.stopWatchElapsedTime,

                                // "elapsedTime": homeController.totalDurationCall.value,
                                "orderId": controller.orderId.value,
                              },
                            );
                            controller.refreshThisController();
                          }

                          Get.defaultDialog(
                            title: "Call Disconnected",
                            middleText: "Please check your wifi/signal condition...",
                            backgroundColor: Colors.white,
                            titleStyle: const TextStyle(color: Colors.green),
                            middleTextStyle: const TextStyle(color: Colors.black),
                          );
                        },
                      );
                      return Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Stack(
                              children: [
                                SizedBox(
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
                                // Align(
                                //   alignment: Alignment.topCenter,
                                //   child: CallScreenEndCallAndTimeSection(
                                //     screenWidth: screenWidth,
                                //     endCall: widget.closeCall,
                                //   ),
                                // ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: CallScreenNavigationSection(
                                    screenWidth: screenWidth,
                                    localRenderer: _localRenderer,
                                    remoteRenderer: _remoteRenderer,
                                    signaling: signaling,
                                    callId: widget.callId,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                                    margin: EdgeInsets.only(bottom: screenWidth * 0.07),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: kBlackColor.withOpacity(
                                                0.5,
                                              ),
                                            ),
                                            child: Text(
                                              "${widget.callType} :  ${callScreenController.maName.value}",
                                              // "Silvia GP Escort",
                                              style: kPoppinsRegular400.copyWith(color: kBackground, fontSize: 18),
                                            )),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return StreamBuilder<DocumentSnapshot>(
                        stream: _fireStoreDataBase.collection('calls').doc(widget.callId).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            callerA = snapshot.data!['callerA'] as bool;
                            callerB = snapshot.data!['callerB'] as bool;
                            if (!isConnectedAll && callerA && callerB) {
                              callScreenController.startStopWatchOnCall();
                              // print("keluarin toast");
                              Fluttertoast.showToast(
                                msg: "Silakan tunggu. Sedang menyambungkan koneksi",
                                backgroundColor: kBackground,
                                textColor: kButtonColor,
                                timeInSecForIosWeb: 11,
                                fontSize: 30,
                                gravity: ToastGravity.TOP,
                                webPosition: 'center',
                                toastLength: Toast.LENGTH_LONG,
                                webBgColor: '#F8FCF5',
                              );
                              isConnectedAll = true;
                            }
                            callScreenController.callerA.value = snapshot.data!['isCallerAShareScreen'] as bool;
                            callScreenController.callerB.value = snapshot.data!['isCallerBShareScreen'] as bool;

                            if (!callScreenController.isOpenChatContainer.value) {
                              callScreenController.chatCount.value = snapshot.data!['chatACount'] as int;
                            }

                            callScreenController.maName.value = snapshot.data!['maName'] as String;

                            // callScreenController.theCaller.value = snapshot.data!['isCallerAShareScreen'] as bool

                            // print("call from doctor -> ${callScreenController.initCallDoctor.value}");

                            return callerA && callerB
                                ? CallScreenPageSection(
                                    callId: widget.callId,
                                    localRenderer: _localRenderer,
                                    remoteRenderer: _remoteRenderer,
                                    roomId: roomId!,
                                    signaling: signaling,
                                    callType: widget.callType,
                                    passedFunction: () {
                                      widget.passedFunction();
                                    },
                                  )
                                : WaitingDoctorCallPage(
                                    isDoctor: callScreenController.initCallDoctor.value,
                                  );
                          } else {
                            return Container();
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ),
    );
  }
}

class CallScreenPageSection extends StatefulWidget {
  const CallScreenPageSection({
    Key? key,
    required this.localRenderer,
    required this.remoteRenderer,
    required this.signaling,
    required this.callId,
    required this.roomId,
    required this.callType,
    required this.passedFunction,
  }) : super(key: key);
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;
  final Signaling signaling;
  final String callId;
  final String roomId;
  final String callType;
  final PassedFunction passedFunction;

  @override
  _CallScreenPageSectionState createState() => _CallScreenPageSectionState();
}

class _CallScreenPageSectionState extends State<CallScreenPageSection> {
  final controller = Get.find<CallScreenController>();
  final FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
  final homeController = Get.find<HomeController>();

  bool isMaInsinde = false;

  Future<void> closeCall() async {
    await _fireStoreDataBase.collection('calls').doc(widget.callId).set({'callActive': false}, SetOptions(merge: true));
    await widget.signaling.hangUp(widget.callId, widget.roomId, widget.localRenderer);

    // final List<MediaStreamTrack> tracks =
    //     widget.localRenderer.srcObject!.getTracks();

    // for (final track in tracks) {
    //   track.stop();
    // }

    // await widget.localRenderer.dispose();
    // widget.localRenderer.srcObject = null;
    // await widget.remoteRenderer.dispose();
    // controller.stopStopWatchOnCall();
    String formatTime(int milliseconds) {
      final secs = milliseconds ~/ 1000;
      final minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
      final seconds = (secs % 60).toString().padLeft(2, '0');

      return "$minutes:$seconds";
    }

    if (controller.callType.value == "callma") {
      homeController.totalDurationCall.value = formatTime(controller.stopWatchElapsedTime);
      Get.offNamed(
        "${Routes.ONBOARD_END_CALL}?orderId=${controller.orderIdFromParam}",
        arguments: {
          "elapsedTime": controller.stopWatchElapsedTime,

          // "elapsedTime": homeController.totalDurationCall.value,
          "orderId": controller.orderId.value,
        },
      );
      // controller.refreshThisController();
    } else {
      Get.offNamed(
        Routes.DOCTOR_SUCCESS_SCREEN,
        arguments: {
          "elapsedTime": controller.stopWatchElapsedTime,

          // "elapsedTime": homeController.totalDurationCall.value,
          "orderId": controller.orderId.value,
        },
      );
      controller.refreshThisController();
    }
  }

  // Widget? callScreenEndCallSection;

  // final Stopwatch _stopwatch = Stopwatch();

  late Timer _timer;

  Future<void> doctorHasDisconnected() async {
    // print('si Doctor hilang');
    await _fireStoreDataBase.collection('calls').doc(widget.callId).set({
      'callerB': false,
      "isAlteaClick": false,
      "maName": "",
      "lastDC": "altea",
    }, SetOptions(merge: true));
    Future.delayed(const Duration(seconds: 1), () {
      final String orderId = Get.parameters.containsKey('orderId') ? Get.parameters['orderId'].toString() : "";
      Get.offNamed(
        "/call-loading?orderId=$orderId&type=${controller.callType.value}&name=${controller.patientName.value}",
      );
    });
  }

  Future<void> maHasDisconnected() async {
    // print('si MA hilang');
    await _fireStoreDataBase.collection('calls').doc(widget.callId).set({
      "lastDC": "altea",
      "isCallOngoing": false,
      "callActive": false,
      "maName": "",
    }, SetOptions(merge: true));
  }

  @override
  void initState() {
    // callScreenEndCallSection = CallScreenEndCallAndTimeSection(
    //   screenWidth: Get.width,
    //   endCall: () async {
    //     await closeCall();
    //   },
    // );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });

    widget.signaling.peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      // print('Connection state change: $state');
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        // print("LAWAN DISCONNECTED");
        setState(() {
          isMaInsinde = false;
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
        if (widget.callType.toLowerCase().contains('doctor')) {
          doctorHasDisconnected();
        } else {
          maHasDisconnected();
        }

        // Future.delayed(Duration(seconds: 8), () {
        //   closeCall();
        // });

      } else if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        // print("LAWAN CONNECTED");

        setState(() {
          isMaInsinde = true;
        });
        // reconnectCallerB();
      }
    };

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // _stopwatch.stop();
    _timer.cancel();
  }

  CollectionReference calls = FirebaseFirestore.instance.collection('calls');
  String message = '';
  Stopwatch stopwatchOnCall = Stopwatch();
  TextEditingController txtController = TextEditingController();
  UploadTask? task;

  FocusNode chatControllerNode = FocusNode();

  Future pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    PlatformFile? objFile;

    if (result != null) {
      // print('result => ${result.files.first.path}');

      final Uint8List fileBytes = result.files.first.bytes!;
      objFile = result.files.single;

      //? Check file type , only accept [PDF, Jpg, Png, Mic office]

      final type = lookupMimeType(objFile.name, headerBytes: fileBytes.cast());

      if (type!.contains("audio") || type.contains("video") || type.contains("gif")) {
        return showDialog(
            context: context,
            builder: (context) => CustomSimpleDialog(
                icon: SizedBox(
                  width: 250,
                  child: Image.asset("assets/failed_icon.png"),
                ),
                onPressed: () {
                  Get.back();
                },
                title: 'Format file tidak didukung',
                buttonTxt: 'Saya Mengerti',
                subtitle: "Harap mengirimkan file dengan format [PDF,JPG,PNG,DOCS,Excel,PPT]"));
      } else {
        final resultResponse = await uploadFile(fileBytes: fileBytes, objFile: objFile);
      }

      // print("resultResponse -> $resultResponse");
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

    task = controller.uploadBytes(destination, fileBytes);
    if (task == null) {
      return;
    }

    final snapshot = await task!.whenComplete(() {});
    final urlFileChat = await snapshot.ref.getDownloadURL();

    // print("url file -> $urlFileChat");

    if (type!.contains("image")) {
      await calls
          .doc(widget.callId)
          .collection('chat')
          .add({"message": urlFileChat, "type": "image", "time": FieldValue.serverTimestamp(), "sender": "callerA", "name": objFile.name});
      final DocumentSnapshot notif = await calls.doc(widget.callId).get();
      await calls.doc(widget.callId).update({"chatBCount": ((notif.data()! as Map)['chatBCount'] as int) + 1});
    } else {
      await calls
          .doc(widget.callId)
          .collection('chat')
          .add({"message": urlFileChat, "type": "file", "time": FieldValue.serverTimestamp(), "sender": "callerA", "name": objFile.name});

      final DocumentSnapshot notif = await calls.doc(widget.callId).get();
      await calls.doc(widget.callId).update({"chatBCount": ((notif.data()! as Map)['chatBCount'] as int) + 1});
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;

    if (Get.width <= 480) {
      controller.isSmallScreen.value = true;
    } else {
      controller.isSmallScreen.value = false;
    }

    if (!isMaInsinde) {
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                RTCVideoView(
                  widget.localRenderer,
                  mirror: true,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: CallScreenEndCallAndTimeSection(
                    screenWidth: screenWidth,
                    endCall: closeCall,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CallScreenNavigationSection(
                    screenWidth: screenWidth,
                    localRenderer: widget.localRenderer,
                    remoteRenderer: widget.remoteRenderer,
                    signaling: widget.signaling,
                    callId: widget.callId,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    margin: EdgeInsets.only(bottom: screenWidth * 0.07),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kBlackColor.withOpacity(
                                0.5,
                              ),
                            ),
                            child: Text(
                              "${widget.callType} :  ${controller.maName.value}",
                              // "Silvia GP Escort",
                              style: kPoppinsRegular400.copyWith(color: kBackground, fontSize: 18),
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Obx(
            () => controller.isOpenChatContainer.value
                ? Container(
                    width: screenWidth * 0.3,
                    color: kBackground,
                    child: Column(
                      children: [
                        Container(
                          height: screenWidth * 0.05,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            color: kLightGray,
                          ))),
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Chat",
                                style: kPoppinsSemibold600.copyWith(fontSize: 16, color: fullBlack),
                              ),
                              IconButton(
                                  onPressed: () {
                                    controller.isOpenChatContainer.value = false;
                                  },
                                  icon: const Icon(Icons.close_rounded))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              child: StreamBuilder<QuerySnapshot>(
                                stream: calls.doc(widget.callId).collection('chat').orderBy('time', descending: true).snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List theChats = snapshot.data!.docs;
                                    return ListView.builder(
                                      itemCount: theChats.length,
                                      reverse: true,
                                      itemBuilder: (context, index) {
                                        return theChats[index].data()['sender'] == "callerB"
                                            ? ChatBubbleReceiverWidget(
                                                message: theChats[index].data()['message'].toString(),
                                                time: theChats[index].data()['time'] == null
                                                    ? ""
                                                    : DateFormat('hh:mm').format((theChats[index].data()['time'] as Timestamp).toDate()),
                                                type: theChats[index].data()['type'].toString(),
                                                fileName: theChats[index].data()['name'] != null ? theChats[index].data()['name'].toString() : null,
                                              )
                                            : ChatBubbleSenderWidget(
                                                message: theChats[index].data()['message'].toString(),
                                                type: theChats[index].data()['type'].toString(),
                                                time: theChats[index].data()['time'] == null
                                                    ? ""
                                                    : DateFormat('hh:mm').format((theChats[index].data()['time'] as Timestamp).toDate()),
                                                fileName: theChats[index].data()['name'] != null ? theChats[index].data()['name'].toString() : null,
                                              );
                                      },
                                    );
                                  } else if (snapshot.data == null) {
                                    return const Center(
                                      child: Text(
                                        "Belum ada pesan... ",
                                      ),
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              )),
                        ),

                        // text message section
                        Container(
                          height: screenWidth * 0.05,
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                            color: kLightGray,
                          ))),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            height: screenWidth * 0.02,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      await pickFile();
                                    },
                                    icon: const Icon(Icons.add)),
                                Expanded(
                                  child: TextField(
                                    autofocus: true,
                                    controller: txtController,
                                    focusNode: chatControllerNode,
                                    decoration: const InputDecoration(
                                      hintText: 'Add text to this message',
                                    ),
                                    onChanged: (val) {
                                      message = val;
                                    },
                                    onSubmitted: (val) async {
                                      message = val;

                                      if (controller.isAllSpaces(message)) {
                                        txtController.clear();
                                        chatControllerNode.requestFocus();
                                      } else {
                                        if (message.isNotEmpty) {
                                          // print("masuk message isNotEmpty");
                                          await calls
                                              .doc(widget.callId)
                                              .collection('chat')
                                              .add({"message": message, "type": "text", "time": FieldValue.serverTimestamp(), "sender": "callerA"});

                                          final DocumentSnapshot notif = await calls.doc(widget.callId).get();
                                          await calls.doc(widget.callId).update({"chatACount": ((notif.data() as Map)['chatACount'] as int) + 1});

                                          txtController.clear();
                                          chatControllerNode.requestFocus();
                                        }
                                        txtController.clear();
                                        chatControllerNode.requestFocus();
                                      }
                                    },
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      if (message != '' || message != ' ') {
                                        await calls
                                            .doc(widget.callId)
                                            .collection('chat')
                                            .add({"message": message, "type": "text", "time": FieldValue.serverTimestamp(), "sender": "callerA"});
                                        final DocumentSnapshot notif = await calls.doc(widget.callId).get();
                                        await calls.doc(widget.callId).update({"chatBCount": ((notif.data()! as Map)['chatBCount'] as int) + 1});
                                        txtController.clear();
                                        chatControllerNode.requestFocus();
                                      }
                                    },
                                    icon: const Icon(Icons.send_rounded)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: Obx(
              () => (controller.callerA.value)
                  ? Stack(
                      children: [
                        RTCVideoView(
                          widget.localRenderer,
                          // objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                        ),
                        Center(
                          child: Container(
                            height: Get.height,
                            width: Get.width,
                            decoration: const BoxDecoration(color: Colors.black38),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 4.0,
                                sigmaY: 4.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera,
                                    size: 30,
                                    color: kTextHintColor,
                                  ),
                                  Text(
                                    "Anda sedang membagi tampilan anda",
                                    style: kTextHintStyle.copyWith(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: CallScreenNavigationSection(
                            screenWidth: screenWidth,
                            localRenderer: widget.localRenderer,
                            remoteRenderer: widget.remoteRenderer,
                            signaling: widget.signaling,
                            callId: widget.callId,
                          ),
                        ),
                        if (Get.width < 800)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                              margin: EdgeInsets.only(bottom: screenWidth * 0.07),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: kBlackColor.withOpacity(
                                          0.5,
                                        ),
                                      ),
                                      child: Text(
                                        "${widget.callType} :  ${controller.maName.value}",
                                        // "Silvia GP Escort",
                                        style: kPoppinsRegular400.copyWith(color: kBackground, fontSize: 18),
                                      )

                                      // TextButton.icon(
                                      //   onPressed: () {
                                      //     // controller.isMicOn.value =
                                      //     //     !controller.isMicOn.value;

                                      //     widget.signaling.changeAudioState(
                                      //         widget.localRenderer,
                                      //         widget.remoteRenderer,
                                      //         !controller.audioState.value);
                                      //     controller.audioState.value =
                                      //         !controller.audioState.value;
                                      //   },
                                      //   icon: Obx(() => controller.audioState.value
                                      //       ? SizedBox(
                                      //           width: 14,
                                      //           child:
                                      //               Image.asset("assets/on_mic_icon.png"))
                                      //       : SizedBox(
                                      //           width: 14,
                                      //           child: Image.asset(
                                      //               "assets/mute_mic_icon.png"))),
                                      //   label: Text(
                                      //     "",
                                      //     // "Silvia GP Escort",
                                      //     style: kPoppinsRegular400.copyWith(
                                      //         color: kBackground, fontSize: 18),
                                      //   ),
                                      // ),
                                      ),
                                  const Spacer(),
                                  Container(
                                    width: 247,
                                    height: 245,
                                    padding: const EdgeInsets.all(0.1),
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 3, color: kBackground), borderRadius: BorderRadius.circular(20), color: fullBlack),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: RTCVideoView(
                                              widget.remoteRenderer,
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
                        else
                          Positioned(
                            top: 0,
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 310,
                              height: Get.height,
                              // height: 245,
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: kTextHintColor, width: 3),
                                ),
                                // border: Border.all(width: 3, color: Colors.black12),
                                // borderRadius: BorderRadius.circular(20),
                                color: Colors.black87,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 3, color: kBackground),
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black12,
                                      ),
                                      width: 250,
                                      height: 250,
                                      child: RTCVideoView(
                                        widget.remoteRenderer,
                                        mirror: true,
                                        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: CallScreenEndCallAndTimeSection(screenWidth: screenWidth, endCall: closeCall),
                        ),
                      ],
                    )
                  : (controller.callerB.value)
                      ? Stack(
                          children: [
                            RTCVideoView(
                              widget.remoteRenderer,
                              // mirror: true,
                              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: CallScreenEndCallAndTimeSection(
                                screenWidth: screenWidth,
                                endCall: closeCall,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: CallScreenNavigationSection(
                                screenWidth: screenWidth,
                                localRenderer: widget.localRenderer,
                                remoteRenderer: widget.remoteRenderer,
                                signaling: widget.signaling,
                                callId: widget.callId,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                                margin: EdgeInsets.only(bottom: screenWidth * 0.07),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: kBlackColor.withOpacity(
                                            0.5,
                                          ),
                                        ),
                                        child: Text(
                                          "${widget.callType} :  ${controller.maName.value}",
                                          // "Silvia GP Escort",
                                          style: kPoppinsRegular400.copyWith(color: kBackground, fontSize: 18),
                                        )
                                        //  TextButton.icon(
                                        //   onPressed: () {
                                        //     // controller.isMicOn.value =
                                        //     //     !controller.isMicOn.value;

                                        //     widget.signaling.changeAudioState(
                                        //         widget.localRenderer,
                                        //         widget.remoteRenderer,
                                        //         !controller.audioState.value);
                                        //     controller.audioState.value =
                                        //         !controller.audioState.value;
                                        //   },
                                        //   icon: Obx(() => controller.audioState.value
                                        //       ? SizedBox(
                                        //           width: 14,
                                        //           child: Image.asset(
                                        //               "assets/on_mic_icon.png"))
                                        //       : SizedBox(
                                        //           width: 14,
                                        //           child: Image.asset(
                                        //               "assets/mute_mic_icon.png"))),
                                        //   label: Text(
                                        //     "",
                                        //     // "Silvia GP Escort",
                                        //     style: kPoppinsRegular400.copyWith(
                                        //         color: kBackground, fontSize: 18),
                                        //   ),
                                        // ),
                                        ),
                                    const Spacer(),
                                    Container(
                                      width: 247,
                                      height: 245,
                                      padding: const EdgeInsets.all(0.1),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 3, color: kBackground),
                                          borderRadius: BorderRadius.circular(20),
                                          color: fullBlack),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: RTCVideoView(
                                                widget.localRenderer,
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
                      : Stack(
                          children: [
                            RTCVideoView(
                              widget.remoteRenderer,
                              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: CallScreenEndCallAndTimeSection(
                                screenWidth: screenWidth,
                                endCall: closeCall,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: CallScreenNavigationSection(
                                screenWidth: screenWidth,
                                localRenderer: widget.localRenderer,
                                remoteRenderer: widget.remoteRenderer,
                                signaling: widget.signaling,
                                callId: widget.callId,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                                margin: EdgeInsets.only(bottom: screenWidth * 0.07),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: kBlackColor.withOpacity(
                                            0.5,
                                          ),
                                        ),
                                        child: Text(
                                          "${widget.callType} :  ${controller.maName.value}",
                                          // "Silvia GP Escort",
                                          style: kPoppinsRegular400.copyWith(color: kBackground, fontSize: 18),
                                        )

                                        // TextButton.icon(
                                        //     onPressed: () {
                                        //       // controller.isMicOn.value =
                                        //       //     !controller.isMicOn.value;

                                        //       widget.signaling.changeAudioState(
                                        //           widget.localRenderer,
                                        //           widget.remoteRenderer,
                                        //           !controller.audioState.value);
                                        //       controller.audioState.value =
                                        //           !controller.audioState.value;
                                        //     },
                                        //     icon: Obx(() => controller.audioState.value
                                        //         ? SizedBox(
                                        //             width: 14,
                                        //             child: Image.asset(
                                        //                 "assets/on_mic_icon.png"))
                                        //         : SizedBox(
                                        //             width: 14,
                                        //             child: Image.asset(
                                        //                 "assets/mute_mic_icon.png"))),
                                        //     label: Text(
                                        //       "",
                                        //       // "Silvia GP Escort",
                                        //       style: kPoppinsRegular400.copyWith(
                                        //           color: kBackground, fontSize: 18),
                                        //     )),
                                        ),
                                    const Spacer(),
                                    Container(
                                      width: 247,
                                      height: 245,
                                      padding: const EdgeInsets.all(0.1),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 3, color: kBackground),
                                          borderRadius: BorderRadius.circular(20),
                                          color: fullBlack),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: RTCVideoView(
                                                widget.localRenderer,
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
                        ),
            ),
          ),
          Obx(
            () => (controller.isOpenChatContainer.value)
                ? Container(
                    width: screenWidth * 0.3,
                    color: kBackground,
                    child: Column(
                      children: [
                        Container(
                          height: screenWidth * 0.05,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            color: kLightGray,
                          ))),
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Chat",
                                style: kPoppinsSemibold600.copyWith(fontSize: 16, color: fullBlack),
                              ),
                              IconButton(
                                  onPressed: () {
                                    controller.isOpenChatContainer.value = false;

                                    // if (callScreenController.callerA.value) {
                                    // } else {
                                    // }
                                  },
                                  icon: const Icon(Icons.close_rounded))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: calls.doc(widget.callId).collection('chat').orderBy('time', descending: true).snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List theChats = snapshot.data!.docs;
                                  return ListView.builder(
                                    itemCount: theChats.length,
                                    reverse: true,
                                    itemBuilder: (context, index) {
                                      return theChats[index].data()['sender'] == "callerB"
                                          ? ChatBubbleReceiverWidget(
                                              message: theChats[index].data()['message'].toString(),
                                              time: theChats[index].data()['time'] == null
                                                  ? ""
                                                  : DateFormat('hh:mm').format((theChats[index].data()['time'] as Timestamp).toDate()),
                                              type: theChats[index].data()['type'].toString(),
                                              fileName: theChats[index].data()['name'] != null ? theChats[index].data()['name'].toString() : null,
                                            )
                                          : ChatBubbleSenderWidget(
                                              message: theChats[index].data()['message'].toString(),
                                              type: theChats[index].data()['type'].toString(),
                                              time: theChats[index].data()['time'] == null
                                                  ? ""
                                                  : DateFormat('hh:mm').format((theChats[index].data()['time'] as Timestamp).toDate()),
                                              fileName: theChats[index].data()['name'] != null ? theChats[index].data()['name'].toString() : null,
                                            );
                                    },
                                  );
                                } else if (snapshot.data == null) {
                                  return const Center(
                                    child: Text(
                                      "Belum ada pesan... ",
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ),
                        ),

                        // text message section
                        Container(
                          height: screenWidth * 0.05,
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                            color: kLightGray,
                          ))),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            height: screenWidth * 0.02,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      await pickFile();
                                    },
                                    icon: const Icon(Icons.add)),
                                Expanded(
                                    child: TextField(
                                  focusNode: chatControllerNode,
                                  controller: txtController,
                                  decoration: const InputDecoration(
                                    hintText: 'Add text to this message',
                                  ),
                                  onChanged: (val) {
                                    message = val;
                                  },
                                  onSubmitted: (val) async {
                                    message = val;
                                    if (controller.isAllSpaces(message)) {
                                      txtController.clear();
                                      chatControllerNode.requestFocus();
                                    } else {
                                      if (message.isNotEmpty) {
                                        // print("masuk message isNotEmpty");
                                        await calls
                                            .doc(widget.callId)
                                            .collection('chat')
                                            .add({"message": message, "type": "text", "time": FieldValue.serverTimestamp(), "sender": "callerA"});

                                        final DocumentSnapshot notif = await calls.doc(widget.callId).get();
                                        await calls.doc(widget.callId).update({"chatACount": ((notif.data() as Map)['chatACount'] as int) + 1});

                                        txtController.clear();
                                        chatControllerNode.requestFocus();
                                      }
                                      txtController.clear();
                                      chatControllerNode.requestFocus();
                                    }
                                  },
                                )),
                                IconButton(
                                    onPressed: () async {
                                      if (controller.isAllSpaces(message)) {
                                        txtController.clear();
                                        chatControllerNode.requestFocus();
                                      } else {
                                        if (message.isNotEmpty) {
                                          // print("masuk message isNotEmpty");
                                          await calls
                                              .doc(widget.callId)
                                              .collection('chat')
                                              .add({"message": message, "type": "text", "time": FieldValue.serverTimestamp(), "sender": "callerA"});

                                          final DocumentSnapshot notif = await calls.doc(widget.callId).get();
                                          await calls.doc(widget.callId).update({"chatACount": ((notif.data() as Map)['chatACount'] as int) + 1});

                                          txtController.clear();
                                          chatControllerNode.requestFocus();
                                        }
                                        txtController.clear();
                                        chatControllerNode.requestFocus();
                                      }
                                    },
                                    icon: const Icon(Icons.send_rounded)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      );
    }
  }
}

class ChatBubbleReceiverWidget extends StatelessWidget {
  ChatBubbleReceiverWidget({
    Key? key,
    required this.message,
    required this.time,
    required this.type,
    this.fileName,
  }) : super(key: key);
  final String message;
  final String time;
  final String type;
  final String? fileName;

  final callScreenController = Get.find<CallScreenController>();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: kLightGray,
                      borderRadius: const BorderRadiusDirectional.only(
                          bottomEnd: Radius.circular(12), topEnd: Radius.circular(12), topStart: Radius.circular(12))),
                  child: type == "image"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(message, fit: BoxFit.cover, loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }),
                            const SizedBox(
                              height: 4,
                            ),
                            InkWell(
                                onTap: () {
                                  callScreenController.downloadFile(fileName!, message);
                                  // launch(message);
                                },
                                child: const Text(
                                  "Download file...",
                                  style: TextStyle(color: Colors.blue),
                                ))
                          ],
                        )
                      : Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadiusDirectional.only(
                                  bottomEnd: Radius.circular(12), topEnd: Radius.circular(12), topStart: Radius.circular(12))),
                          child: type == "file"
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.blueAccent),
                                          width: 35,
                                          height: 35,
                                          child: Center(
                                            child: Image.asset(
                                              "assets/no_file_upload_icon.png",
                                              color: Colors.black,
                                              width: 20,
                                              height: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(child: Text(fileName!))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          callScreenController.downloadFile(fileName!, message);
                                          // launch(message);
                                        },
                                        child: const Text(
                                          "Download file...",
                                          style: TextStyle(color: Colors.blue),
                                        ))
                                  ],
                                )
                              : Text(
                                  message,
                                  style: TextStyle(color: fullBlack),
                                ),
                        ),
                ),
              ),
              Text(time, style: const TextStyle(color: Colors.grey))
            ],
          ),
        ),
        const Spacer()
      ],
    );
  }
}

class ChatBubbleSenderWidget extends StatelessWidget {
  ChatBubbleSenderWidget({
    Key? key,
    required this.type,
    required this.message,
    required this.time,
    this.fileName,
  }) : super(key: key);
  final String type;
  final String message;
  final String time;
  final String? fileName;
  final callScreenController = Get.find<CallScreenController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: type == "image"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            message,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          InkWell(
                              onTap: () {
                                callScreenController.downloadFile(fileName!, message);
                                // launch(message);
                              },
                              child: const Text(
                                "Download file...",
                                style: TextStyle(color: Colors.blue),
                              ))
                        ],
                      )
                    : Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: kButtonColor,
                            borderRadius: const BorderRadiusDirectional.only(
                                bottomStart: Radius.circular(12), topEnd: Radius.circular(12), topStart: Radius.circular(12))),
                        child: type == "file"
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: kDarkBlue.withOpacity(0.1)),
                                        width: 35,
                                        height: 35,
                                        child: Center(
                                          child: Image.asset(
                                            "assets/no_file_upload_icon.png",
                                            color: kDarkBlue,
                                            width: 20,
                                            height: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(child: Text(fileName!))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        callScreenController.downloadFile(fileName!, message);

                                        // launch(message);
                                      },
                                      child: const Text(
                                        "Download file...",
                                        style: TextStyle(color: Colors.blue),
                                      ))
                                ],
                              )
                            : Text(
                                message,
                                style: const TextStyle(color: Colors.white),
                              ),
                      ),
              ),
              Text(time, style: const TextStyle(color: Colors.grey))
            ],
          ),
        ),
      ],
    );
  }
}

class WaitingDoctorCallPage extends StatefulWidget {
  const WaitingDoctorCallPage({
    Key? key,
    required this.isDoctor,
  }) : super(key: key);
  final bool isDoctor;

  @override
  _WaitingDoctorCallPageState createState() => _WaitingDoctorCallPageState();
}

class _WaitingDoctorCallPageState extends State<WaitingDoctorCallPage> {
  String formatTime(int milliseconds) {
    final secs = milliseconds ~/ 1000;
    final minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (secs % 60).toString().padLeft(2, '0');

    return "$minutes:$seconds";
  }

  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stopwatch.stop();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return Scaffold(
      backgroundColor: kBackground,
      body: Column(
        children: [
          TopNavigationBarSection(screenWidth: screenWidth),
          const Spacer(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.03,
                  backgroundColor: kButtonColor,
                  child: CircleAvatar(
                    radius: screenWidth * 0.025,
                    backgroundColor: kBackground,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  widget.isDoctor ? 'Waiting for Doctor' : 'Waiting for Medical Advisor',
                  style: kPoppinsRegular400.copyWith(fontSize: 14, color: kBlackColor.withOpacity(0.7)),
                ),
                Text(formatTime(_stopwatch.elapsedMilliseconds), style: kPoppinsSemibold600.copyWith(fontSize: 20, color: kDarkBlue)),
                const SizedBox(
                  height: 60,
                ),
                // CustomFlatButton(
                //   width: screenWidth * 0.05,
                //   text: 'Cancel',
                //   onPressed: () {
                //     // widget.stopCall();
                //     Get.offNamed('/home');
                //   },
                //   color: kBackground,
                //   borderColor: kButtonColor,
                // )
              ],
            ),
          ),
          const Spacer(),
          FooterSectionWidget(screenWidth: screenWidth)
        ],
      ),
    );
  }
}

class CallScreenEndCallAndTimeSection extends StatefulWidget {
  CallScreenEndCallAndTimeSection({
    Key? key,
    required this.screenWidth,
    required this.endCall,
  }) : super(key: key);

  final double screenWidth;

  final VoidCallback endCall;

  @override
  _CallScreenEndCallAndTimeSectionState createState() => _CallScreenEndCallAndTimeSectionState();
}

class _CallScreenEndCallAndTimeSectionState extends State<CallScreenEndCallAndTimeSection> {
  final homeController = Get.find<HomeController>();
  final CallScreenController _callScreenController = Get.find<CallScreenController>();

  String formatTime(int milliseconds) {
    final secs = milliseconds ~/ 1000;
    final minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (secs % 60).toString().padLeft(2, '0');

    homeController.totalDurationCall.value = "$minutes:$seconds";

    return "$minutes:$seconds";
  }

  // final Stopwatch _stopwatch = Stopwatch();

  // late Timer _timer;

  @override
  void initState() {
    super.initState();
    // _stopwatch.start();
    // timer untuk setState every 30s
  }

  @override
  void dispose() {
    super.dispose();
    // _stopwatch.stop();
    // _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBlackColor.withOpacity(0.5),
      height: 80,
      // width: widget.screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 96),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //   width: widget.screenWidth * 0.425,
          // ),
          const Spacer(),
          Center(
            child: Obx(
              () => Text(
                formatTime(_callScreenController.stopWatchElapsedTime),
                // formatTime(widget.milliseconds),
                style: kPoppinsSemibold600.copyWith(color: kBackground, fontSize: 18),
              ),
            ),
          ),
          const Spacer(),
          Container(
            width: 131,
            height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(primary: kRedError, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                // setState(() {
                // widget.endCall();
                Get.dialog(
                  PopUpEndCall(
                    endCall: widget.endCall,
                  ),
                );
                // });
              },
              child: Text(
                "End Call",
                style: kPoppinsMedium500.copyWith(color: kBackground, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PopUpEndCall extends StatelessWidget {
  const PopUpEndCall({Key? key, required this.endCall}) : super(key: key);
  final VoidCallback endCall;

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final callScreenController = Get.find<CallScreenController>();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(18),
          height: screenWidth * 0.15,
          width: screenWidth * 0.2,
          child: Column(
            children: [
              Text(
                "Keluar dari Call",
                style: kPoppinsSemibold600.copyWith(fontSize: 24),
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                "Apakah anda yakin mau keluar dari call ini?",
                style: kPoppinsMedium500.copyWith(fontSize: 14),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomFlatButton(
                        width: screenWidth * 0.1,
                        text: 'Keluar',
                        onPressed: () async {
                          endCall();
                          // print("IS CALLER END CALL BEFORE? ${callScreenController.isCallerEndCall.value}");

                          callScreenController.isCallerEndCall.value = true;
                          callScreenController.update();

                          // print("IS CALLER END CALL AFTER? ${callScreenController.isCallerEndCall.value}");
                          Get.back();
                        },
                        color: kButtonColor),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomFlatButton(
                      width: screenWidth * 0.1,
                      text: 'Batal',
                      onPressed: () {
                        Get.back();
                      },
                      color: kBackground,
                      borderColor: kButtonColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CallScreenNavigationSection extends StatelessWidget {
  const CallScreenNavigationSection({
    Key? key,
    required this.screenWidth,
    required this.signaling,
    required this.localRenderer,
    required this.remoteRenderer,
    required this.callId,
  }) : super(key: key);

  final double screenWidth;
  final Signaling signaling;
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;
  final String callId;

  @override
  Widget build(BuildContext context) {
    final callScreenController = Get.find<CallScreenController>();
    return Container(
      color: kBlackColor.withOpacity(0.5),
      height: screenWidth * 0.05,
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
          CallShareScreenButton(
            signaling: signaling,
            localRenderer: localRenderer,
            callId: callId,
          ),
          const SizedBox(
            width: 18,
          ),
          Obx(() => Stack(
                children: [
                  CallChatButton(
                    callId: callId,
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
              )),
          const SizedBox(
            width: 18,
          ),
          const CallMoreOptionsButton(),
        ],
      ),
    );
  }
}

class CallMoreOptionsButton extends StatelessWidget {
  const CallMoreOptionsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 60,
        height: 60,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kBlackColor.withOpacity(0.5),
        ),
        child: Image.asset("assets/more_options_icon.png"),
      ),
    );
  }
}

class CallChatButton extends StatelessWidget {
  const CallChatButton({
    Key? key,
    required this.callId,
  }) : super(key: key);
  final String callId;

  @override
  Widget build(BuildContext context) {
    final CollectionReference calls = FirebaseFirestore.instance.collection('calls');

    final controller = Get.find<CallScreenController>();
    return InkWell(
      onTap: () async {
        controller.isOpenChatContainer.value = !controller.isOpenChatContainer.value;
        await calls.doc(callId).update({'chatACount': 0});
        controller.chatCount.value = 0;
      },
      child: Obx(() => Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: controller.isOpenChatContainer.value ? kButtonColor : kBlackColor.withOpacity(0.5),
            ),
            child: Image.asset("assets/chat_icon.png"),
          )),
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
        width: 60,
        height: 60,
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
        width: 60,
        height: 60,
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
    return Obx(() => InkWell(
          onTap: controller.isShareScreen.value
              ? null
              : () {
                  // controller.isCameraOn.value = !controller.isCameraOn.value;
                  // print('video');
                  signaling.changeVideoState(localRenderer, remoteRenderer, !controller.videoState.value);
                  controller.videoState.value = !controller.videoState.value;
                },
          child: Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kBlackColor.withOpacity(0.5),
            ),
            child: Obx(() => controller.videoState.value ? Image.asset("assets/on_cam_icon.png") : Image.asset("assets/off_cam_icon.png")),
          ),
        ));
  }
}
