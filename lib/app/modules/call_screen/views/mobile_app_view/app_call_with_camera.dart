import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart' as setting;
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/data/model/call_model.dart';
import 'package:altea/app/data/model/user.dart';
import 'package:altea/app/modules/call_screen/controllers/call_screen_controller.dart';
import 'package:altea/app/modules/call_screen/controllers/signaling.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/patient_confirmation/controllers/patient_confirmation_controller.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import 'package:altea/app/modules/wait_ma_call/views/mobile_app_view/mobile_app_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:camera/camera.dart';
import '../../../../core/utils/use_shared_pref.dart';

class MobileAppCallScreen extends StatefulWidget {
  final String? callId;
  MobileAppCallScreen({required this.callId});

  @override
  _MobileAppCallScreenState createState() => _MobileAppCallScreenState();
}

class _MobileAppCallScreenState extends State<MobileAppCallScreen> with WidgetsBindingObserver {
  CameraController? camController;
  List<CameraDescription> cameras = [];
  PatientConfirmationController controller = Get.find<PatientConfirmationController>();
  SpesialisKonsultasiController konsultasiController = Get.find<SpesialisKonsultasiController>();
  CallScreenController callController = Get.find<CallScreenController>();
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  // RTCVideoRenderer _shareRenderer = RTCVideoRenderer();
  bool connectionEstablished = false;
  String? roomId;
  bool callerA = false;
  bool callerB = false;
  bool isConnectedAll = false;
  var callId = '';
  bool videoState = true;
  bool audioState = true;
  bool isSharing = false;
  bool isInBackground = false;
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
  final callScreenController = Get.find<CallScreenController>();
  // Timer? _rtcTimer;

  // List<Map<String, dynamic>> chats = [
  //   {
  //     "sender": "me",
  //     "message": "Selamat Siang",
  //     "time": DateTime.now(),
  //   }
  // ];
  late FocusNode myFocusNode;
  Stream<List<CallModel>> getUserList() {
    return _fireStoreDataBase
        .collection('calls')
        .snapshots()
        .map((snapShot) => snapShot.docs.map((document) => CallModel.fromJson(document.data())).toList());
  }

  bool isDisconnected = false;
  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  late Timer _timer;
  bool isLoading = false;

  Stopwatch _stopwatch = Stopwatch();
  late FToast fToast;
  @override
  void initState() {
    initCamera();
    // print('call id => ${widget.callId}');
    fToast = FToast();
    fToast.init(context);
    // TODO: implement initState
    super.initState();
    _stopwatch.start();
    _timer = new Timer.periodic(new Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
    _localRenderer.initialize();
    // _shareRenderer.initialize();
    _remoteRenderer.initialize();
    // print('finish initialize');
    myFocusNode = FocusNode();
    WidgetsBinding.instance!.addObserver(this);
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    initRoom();
  }

  bool init = false;

  void resetTimer() {
    setState(() {
      init = true;
    });
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    camController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
  }

  void checkEndCall(bool onListen) {
    // print("MASUK CEK END CALL $callId");
    if (callId.isNotEmpty) {
      final myStream = _fireStoreDataBase.collection('calls').doc(callId).snapshots();
      myStream.listen((dataa) async {
        // print("call active -> ${dataa.data()!["callActive"]}");
        if (dataa.data()!["callActive"] == false) {
          signaling.hangUp(callId, roomId, _localRenderer);

          // if (widget.callId == 'doctor') {
          //   Get.toNamed('/doctor-success-screen',
          //       arguments: formatTime(_stopwatch.elapsedMilliseconds));
          // } else {
          // var res = await controller.createAppointment({
          //   "doctor_id": konsultasiController.selectedDoctor.value,
          //   "patient_id": konsultasiController.selectedUid.value,
          //   "symptom_note": "",
          //   "consultation_method": konsultasiController.consultBy.value,
          //   "schedules": [
          //     konsultasiController.selectedDoctorTime.value.toJson2()
          //   ],
          // });
          //
          // print("res => $res");

          // if (res['status'] == true) {
          if (!closedByUser) {
            // print('tidak di close user nihh');
            closeCall(false);

            DocumentSnapshot res = await calls.doc(callId).get();

            // print((res.data() as Map)['name']);
            if (!(res.data() as Map)['name'].toString().contains('Doctor')) {
              // print('end call MA');
              Future.delayed(Duration(seconds: 1), () {
                Get.toNamed(
                  '/onboard-end-call',
                  arguments: formatTime(_stopwatch.elapsedMilliseconds),
                );
              });
            } else {
              // print('end call Doctor');

              if (callScreenController.isMeDisconnect.value) {
                // print("Kita dc wifi ketika call doctor");
              } else {
                Get.toNamed('/doctor-success-screen', arguments: formatTime(_stopwatch.elapsedMilliseconds));
              }
            }

            // Get.offNamed('/home');
          }

          // }
          // }
        }
      });
    }
  }

  bool isOtherDisconnected = false;
  bool closedByUser = false;
  String newRoomId = '';

  CollectionReference calls = FirebaseFirestore.instance.collection('calls');
  ScrollController scrollController = ScrollController();

  void createNewRoom() async {
    await signaling.openUserMedia(_localRenderer, _remoteRenderer);
    await signaling.changeVideo(_localRenderer, _remoteRenderer, true, true);

    newRoomId = await signaling.createRoom(widget.callId ?? '', _remoteRenderer);
    // print('ini old room id => $roomId | ini new room id => $newRoomId');
  }

  Future<Map<String, dynamic>> getDataConsultationDetail() async {
    final token = AppSharedPreferences.getAccessToken();
    // print("order id -> $orderId");

    try {
      final response = await http.get(
          Uri.parse(
            // "${setting.alteaURL}/appointment/detail/${konsultasiController.appointmentId.value}",
            "${setting.alteaURL}/appointment/v1/consultation/${konsultasiController.appointmentId.value}",
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

  void initRoom() async {
    await signaling.initiateStream();

    // print('init room!!');
    await signaling.openUserMedia(_localRenderer, _remoteRenderer);
    await signaling.changeVideo(_localRenderer, _remoteRenderer, true, true);

    HomeController controller = Get.find<HomeController>();
    User user = await controller.getUserProfile();
    if (widget.callId != 'new' && widget.callId != 'doctor') {
      setState(() {
        callId = widget.callId!;
      });
      // print('joining.....');

      // roomId = await signaling.createRoom(widget.callId ?? '', _remoteRenderer);

      await _fireStoreDataBase.collection('calls').doc(callId).set({'callerB': false}, SetOptions(merge: true));
      _fireStoreDataBase.collection('calls').doc(callId).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          // print('Document data: ${documentSnapshot.data()}');
          calls.doc(callId).update({"isPatientInside": true});
          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          signaling.joinRoom(callId, data['roomId'].toString(), _remoteRenderer);
        } else {
          // print('Document does not exist on the database');
        }
      });
    } else {
      // print('order id sblm di get => ${konsultasiController.appointmentId.value}');
      QuerySnapshot orders = await _fireStoreDataBase.collection('calls').where('orderId', isEqualTo: konsultasiController.appointmentId.value).get();
      // print('order nya udah pernah call ??? => ${orders.docs}');
      // print('masuk siniiii 23 ${widget.callId} ${konsultasiController.appointmentId.value}');
      if (orders.docs.isEmpty) {
        // print('room belum pernah di buat nih');

        try {
          DocumentReference docRef = await calls.add({
            'name': widget.callId == 'doctor'
                ? 'Call for Doctor from ${konsultasiController.selectedPatientName.value}'
                : 'Call for MA ${konsultasiController.selectedPatientName.value}', // John Doe
            'callerA': true, // Stokes and Sons
            'callerB': false,
            'chatACount': 0,
            'isAlteaClick': false,
            'chatBCount': 0,
            "isCallerAShareScreen": false,
            "isCallerBShareScreen": false,
            'callActive': true, // 42,
            "maName": "",
            "isCallerAOnline": false,
            "isCallerBOnline": false,
            "isMaInside": false,
            "isPatientInside": true,
            "doctorId": konsultasiController.selectedDoctor.value,
            "orderId": konsultasiController.appointmentId.value,
            "isCallOngoing": true,
            "lastDC": "",
          });
          // print('docRef => $docRef');
          setState(() {
            callId = docRef.id;
          });
          roomId = await signaling.createRoom(callId, _remoteRenderer);
          await calls.doc(callId).set({'roomId': roomId}, SetOptions(merge: true));

          // }
        } catch (e) {
          // print('errorr call => $e');
        }
      } else {
        // print('consultation udah pernah dibuat !!');
        bool isLastDC = (orders.docs.first.data()! as Map<String, dynamic>)['lastDC'].toString() == "patient";
        // print("get last dc = ${(orders.docs.first.data()! as Map<String, dynamic>)['lastDC'].toString()}");
        callController.isTryingReconnect.value = false;
        isOtherDisconnected = false;
        setState(() {
          callId = orders.docs[0].id;
          roomId = (orders.docs.first.data() as Map)['roomId'].toString();
        });
        // print("call ID adalah : $callId");
        await calls.doc(callId).set({
          'name': widget.callId == 'doctor'
              ? 'Call for Doctor from ${konsultasiController.selectedPatientName.value}'
              : 'Call for MA ${konsultasiController.selectedPatientName.value}', // John Doe
          'callerA': true,
          // 'callerB': false, //jangan dibuat caller b false
          'isCallOngoing': true,
          "maName": "",
          "orderId": konsultasiController.appointmentId.value,
        }, SetOptions(merge: true));
        // print("is last DC == $isLastDC");
        // print('callID => $callId');
        if (isLastDC) {
          await signaling.joinRoom(callId, roomId.toString(), _remoteRenderer);
          await _fireStoreDataBase.collection('calls').doc(callId).set({
            'callActive': true,
            "isAlteaClick": false,
            // "maName": "",
          }, SetOptions(merge: true));
          // print("join room karena last dc = patient : id di join : $roomId");
        } else {
          final String r = await signaling.createRoom(callId, _remoteRenderer);
          setState(() {
            roomId = r;
          });
          await _fireStoreDataBase.collection('calls').doc(callId).update({"roomId": roomId});
          // print("create room karena last dc = altea : id di join : $roomId");

          await _fireStoreDataBase.collection('calls').doc(callId).set({
            'name': widget.callId == 'doctor'
                ? 'Call for Doctor from ${konsultasiController.selectedPatientName.value}'
                : 'Call for MA ${konsultasiController.selectedPatientName.value}', // Jo
            'callActive': true,
            "isAlteaClick": false,
            "maName": "",
            'callerB': false,
            "roomId": roomId,
            "lastDC": "altea",
            "orderId": konsultasiController.appointmentId.value,

            'isCallOngoing': true,
          }, SetOptions(merge: true));
        }

        // print('ini Id yg lama => $callId');
      }

      signaling.peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
        // print('Connection state change: $state');
        if (!isDisconnected) {
          if (state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
            if (widget.callId.toString().toLowerCase() == "doctor") {
              doctorHasDisconnected();
            } else {
              maHasDisconnected();
            }
          } else if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
            if (widget.callId.toString().toLowerCase() == "doctor") {
              doctorHasDisconnected();
            } else {
              maHasDisconnected();
            }
          }
        }
      };
    }
    // print('createCall');
    callScreenController.theCaller.value = true;
    createCall();
    checkEndCall(true);
  }

  Future<void> doctorHasDisconnected() async {
    // print('si Doctor hilang');
    await _fireStoreDataBase.collection('calls').doc(callId).set({
      'callerB': false,
      "isAlteaClick": false,
      "maName": "",
      "lastDC": "altea",
    }, SetOptions(merge: true));
    Future.delayed(const Duration(seconds: 1), () async {
      final String orderId = Get.parameters.containsKey('orderId') ? Get.parameters['orderId'].toString() : "";
      await Future.delayed(const Duration(milliseconds: 300), () async {
        // print('ke halaman reconnect nih !');
        await Get.offNamed("/reconnect-call-view",
            arguments: konsultasiController.appointmentId.value); //biar ke halaman "landing loading nunggu pasien"
      }); // biar bis
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

  void disconnectCallerB() async {
    //Ketika User Disconnect, update callerA nya false.
    setState(() {
      isOtherDisconnected = true;
    });
    // print('caller B Disconnected nih !');
    // if()
    var rooms = await calls.doc(callId).get();
    if ((rooms.data() as Map)['name'].toString().contains('Doctor')) {
      // print('ini disconnected dari call doctor');
      // await Fluttertoast.showToast(
      //   msg: "Terjadi masalah koneksi dari Dokter, Harap tunggu sebentar",
      //   backgroundColor: kBackground,
      //   textColor: kButtonColor,
      //   webShowClose: true,
      //   timeInSecForIosWeb: 11,
      //   fontSize: 13,
      //   gravity: ToastGravity.TOP_RIGHT,
      //   webPosition: 'center',
      //   toastLength: Toast.LENGTH_LONG,
      //   webBgColor: '#F8FCF5',
      // );

      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => CustomSimpleDialog(
              icon: ImageIcon(
                AssetImage('assets/group-5.png'),
                color: kRedError,
                size: 150,
              ),
              onPressed: () async {
                closeCall(false);
                // callController.isTryingReconnect.value = true;

                await _fireStoreDataBase.collection('calls').doc(callId).set({
                  'callerB': false,
                  'callActive': true,
                  "isAlteaClick": false,
                  "maName": "",
                }, SetOptions(merge: true));

                await Future.delayed(const Duration(seconds: 1), () async {
                  // print('ke halaman reconnect nih !');
                  await Get.offNamed("/reconnect-call-view", arguments: callId); //biar ke halaman "landing loading nunggu pasien"
                });
                // await _fireStoreDataBase.collection('calls').doc(callId).set({
                //   'callerB': false,
                //   'callActive': true,
                //   "isAlteaClick": false,
                //   "maName": "",
                // }, SetOptions(merge: true));
                // Get.offNamed('/home');
              },
              title: 'Mohon Maaf, Terjadi Kesalahan',
              buttonTxt: 'Konfirmasi',
              subtitle: 'Ada masalah dengan koneksi, Dokter meninggalkan ruang call. Harap menunggu atau mengatur jadwal lagi.'));

      // print('widget call id => ${widget.callId} - call Id => $callId');
      // biar bisa reconnect si MA / doctor
      await Future.delayed(const Duration(milliseconds: 300), () async {
        // print('ke halaman reconnect nih !');
        await Get.offNamed("/reconnect-call-view",
            arguments: konsultasiController.appointmentId.value); //biar ke halaman "landing loading nunggu pasien"
      }); // biar bisa reconnect si MA / doctor

    } else {
      // print('ini disconnected dari call MA');
      await showDialog(
          context: context,
          builder: (context) => CustomSimpleDialog(
              icon: ImageIcon(
                AssetImage('assets/group-5.png'),
                color: kRedError,
                size: 150,
              ),
              onPressed: () async {
                closeCall(false);
                Get.offNamed('/home');
              },
              title: 'Mohon Maaf, Terjadi Kesalahan',
              buttonTxt: 'Kembali ke Beranda',
              subtitle: 'Ada masalah dengan koneksi, Harap menghubungi MA lagi'));
    }
  }

  bool isAllSpaces(String input) {
    String output = input.replaceAll(' ', '');
    if (output == '') {
      return true;
    }
    return false;
  }

  Future<void> createCall() {
    // Call the user's CollectionReference to add a new user
    return calls
        .add({
          'name': 'Call Doctor -', // John Doe
          'callerA': false, // Stokes and Sons
          'callerB': false // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> closeCall(bool reconnect) async {
    closedByUser = true;

    await _fireStoreDataBase.collection('calls').doc(callId).set({
      'callActive': false,
      'callerB': false,
      'isCallOngoing': false,
      'lastDC': "",
    }, SetOptions(merge: true));

    await signaling.hangUp(callId, roomId ?? '', _localRenderer);

    try {
      await _localRenderer.dispose();
      _localRenderer.srcObject = null;
      await _remoteRenderer.dispose();
    } catch (e) {
      // print(e.toString());
    }

    // Get.back();
  }

  String message = '';
  final f = new DateFormat('hh:mm');

  final PanelController _pc = PanelController();

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    // _rtcTimer?.cancel();
    // _shareRenderer.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    _stopwatch.stop();
    _timer.cancel();
    super.dispose();
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (camController != null) {
      await camController!.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    camController = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        // print('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait([
        // The exposure mode is currently not supported on the web.
        ...!GetPlatform.isWeb
            ? [cameraController.getMinExposureOffset().then((value) => 1), cameraController.getMaxExposureOffset().then((value) => 1)]
            : [],
        cameraController.getMaxZoomLevel().then((value) => 1),
        cameraController.getMinZoomLevel().then((value) => 1),
      ]);
    } on CameraException catch (e) {
      // print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // print('state = $state');
    if (state == AppLifecycleState.detached) {
      // print('closing app !!');
      await signaling.hangUp(callId, roomId, _localRenderer);
    }
    if (state == AppLifecycleState.resumed) {
      // print("is remote renderer null?? : ${_remoteRenderer == null}");
      // print("is local renderer null?? : ${_localRenderer == null}");
      try {
        signaling.changeVideoState(_localRenderer, _remoteRenderer, true);
      } catch (e) {
        // print("change video on resumed error?? $e");
      }

      // _rtcTimer!.cancel();
      // print('app resumed peer state : ${signaling.peerConnection?.connectionState}');
      if (signaling.peerConnection?.connectionState == RTCPeerConnectionState.RTCPeerConnectionStateFailed
          // signaling.peerConnection?.connectionState == RTCPeerConnectionState.RTCPeerConnectionStateFailed
          ) {
        Get.dialog(
          CustomSimpleDialog(
            icon: const ImageIcon(
              AssetImage('assets/group-5.png'),
              color: kRedError,
              size: 150,
            ),
            onPressed: () async {
              await closeCall(false);
              await Future.delayed(const Duration(seconds: 1), () async {
                Get.offNamed('/home');
              });
            },
            title: 'Mohon Maaf, Terjadi Kesalahan',
            buttonTxt: 'Kembali ke Beranda',
            subtitle: 'Ada masalah dengan koneksi',
          ),
          barrierDismissible: false,
        );
      }
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          isInBackground = false;
        });
        // print("is in background : $isInBackground");
      });
    }
    if (state == AppLifecycleState.inactive) {
      try {
        signaling.changeVideoState(_localRenderer, _remoteRenderer, false);
      } catch (e) {
        // print("change video on inactive error?? $e");
      }

      // print("app-nya ke-paused, di background??");
      // print('applifecycle state change: $state');
      setState(() {
        isInBackground = true;
      });
      // print("is in background? : $isInBackground");
    }
  }

  TextEditingController txtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // print('view inset => ${MediaQuery.of(context).viewInsets.bottom}');
    // print('height => ${MediaQuery.of(context).size.height}');
    return WillPopScope(
      onWillPop: () async {
        if (init) {
          if (_pc.isPanelClosed) {
            Get.defaultDialog(
              // content: Container(
              //     padding: EdgeInsets.all(8),
              //     child: Container()),

              title: '',
              titleStyle: kPoppinsSemibold600.copyWith(
                fontSize: 14,
                color: kBlackColor,
              ),
              content: Container(
                padding: EdgeInsets.only(left: 8),
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Akhiri Panggilan',
                      style: kPoppinsSemibold600.copyWith(
                        fontSize: 16,
                        color: kBlackColor,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Apakah anda ingin mengakhiri panggilan ?',
                      style: kPoppinsRegular400.copyWith(fontSize: 13, color: kBlackColor.withOpacity(0.7)),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              radius: 8,
              middleTextStyle: kPoppinsRegular400.copyWith(fontSize: 13, color: kBlackColor.withOpacity(0.7)),
              confirm: Transform(
                transform: Matrix4.translationValues(-25.0, 0.0, 0.0),
                child: CustomFlatButton(
                    width: MediaQuery.of(context).size.width * 0.29,
                    text: 'End Call',
                    onPressed: () async {
                      if (widget.callId == 'doctor') {
                        // doctorHasDisconnected();
                        // print('doctorssss');
                        await _fireStoreDataBase.collection('calls').doc(callId).set({
                          // 'callerB': false,
                          // "isAlteaClick": false,
                          "maName": "",
                          "isCallOngoing": false,
                          "callActive": false,
                          "lastDC": "",
                        }, SetOptions(merge: true));
                        await closeCall(false);
                        Get.toNamed('/doctor-success-screen', arguments: formatTime(_stopwatch.elapsedMilliseconds));
                        Get.back();
                      } else {
                        // print('maaaaaaaaaa');
                        // maHasDisconnected();
                        // await _fireStoreDataBase.collection('calls').doc(callId).set({
                        //   "lastDC": "altea",
                        //   "isCallOngoing": false,
                        //   "callActive": false,
                        //   "maName": "",
                        // }, SetOptions(merge: true));

                        await _fireStoreDataBase.collection('calls').doc(callId).set({
                          // 'callerB': false,
                          // "isAlteaClick": false,
                          "maName": "",
                          "isCallOngoing": false,
                          "callActive": false,
                          "lastDC": "",
                        }, SetOptions(merge: true));
                        await closeCall(false);
                        Get.offNamed('/home');
                      }
                    },
                    color: kButtonColor),
              ),
              cancel: Transform(
                transform: Matrix4.translationValues(-6.0, 0.0, 0.0),
                child: CustomFlatButton(
                  width: MediaQuery.of(context).size.width * 0.29,
                  text: 'Batal',
                  onPressed: () {
                    Get.back();
                  },
                  color: kBackground,
                  borderColor: kButtonColor,
                ),
              ),
            );
          } else {
            _pc.close();
          }
        }

        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SlidingUpPanel(
          controller: _pc,
          minHeight: 0,
          maxHeight: MediaQuery.of(context).size.height,
          panel: SafeArea(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).viewInsets.bottom == 0
                    ? MediaQuery.of(context).size.height * 0.95
                    : MediaQuery.of(context).size.height - (MediaQuery.of(context).viewInsets.bottom + 50),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(boxShadow: [kBoxShadow], color: kBackground),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Chat',
                                style: kPoppinsSemibold600.copyWith(fontSize: 14, color: kBlackColor),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    size: 20,
                                    color: kBlackColor,
                                  ),
                                  onPressed: () {
                                    _pc.close();
                                    FocusScope.of(context).unfocus();
                                  })
                            ],
                          )),
                    ),

                    // CHAT SECTION
                    if (callId.isEmpty)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      Expanded(
                        flex: 8,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(boxShadow: [kBoxShadow], color: kBackground),
                          padding: EdgeInsets.all(16),
                          child: StreamBuilder<QuerySnapshot>(
                              stream: calls.doc(callId).collection('chat').orderBy('time', descending: true).snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  // print(
                                  //     'snapshot stream => ${(snapshot.data!.docs)} | call id => ${callId}');
                                  List chats = snapshot.data!.docs;
                                  return ListView.builder(
                                    controller: scrollController,
                                    reverse: true,
                                    shrinkWrap: true,
                                    itemCount: chats.length,
                                    itemBuilder: (context, idx) {
                                      if (idx == chats.length) {
                                        scrollController.animateTo(scrollController.position.maxScrollExtent,
                                            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                      }
                                      return Align(
                                        alignment: chats[idx].data()['sender'] == 'callerB' ? Alignment.centerLeft : Alignment.centerRight,
                                        child: chats[idx].data()['type'] == 'text'
                                            ? Column(
                                                crossAxisAlignment:
                                                    chats[idx].data()['sender'] == 'callerB' ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: chats[idx].data()['sender'] == 'callerB' ? kWhiteGray : kButtonColor,
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(16),
                                                          topRight: Radius.circular(16),
                                                          bottomLeft:
                                                              chats[idx].data()['sender'] == 'callerB' ? Radius.circular(0) : Radius.circular(16),
                                                          bottomRight:
                                                              chats[idx].data()['sender'] == 'callerB' ? Radius.circular(16) : Radius.circular(0),
                                                        )),
                                                    padding: EdgeInsets.all(16),
                                                    child: Text(
                                                      chats[idx].data()['message'].toString(),
                                                      softWrap: true,
                                                      style: kPoppinsMedium500.copyWith(
                                                          fontSize: 11, color: chats[idx].data()['sender'] == 'callerB' ? kBlackColor : kBackground),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  // if (idx == 0)
                                                  Text(
                                                    chats[idx].data()['time'] == null
                                                        ? ""
                                                        : f.format((chats[idx].data()['time'] as Timestamp).toDate()),
                                                    style: kPoppinsRegular400.copyWith(fontSize: 12, color: kBlackColor),
                                                  ),
                                                  // else if (f.format(
                                                  //         (chats[idx].data()['time']
                                                  //                 as Timestamp)
                                                  //             .toDate()) ==
                                                  //     f.format(
                                                  //         (chats[idx - 1].data()['time']
                                                  //                 as Timestamp)
                                                  //             .toDate()))
                                                  //   Text(
                                                  //     f.format((chats[idx].data()['time']
                                                  //             as Timestamp)
                                                  //         .toDate()),
                                                  //     style: kPoppinsRegular400.copyWith(
                                                  //         fontSize: 12,
                                                  //         color: kBlackColor),
                                                  //   )
                                                  // else
                                                  //   Container()
                                                ],
                                              )
                                            : chats[idx].data()['type'] == 'image'
                                                ? Column(
                                                    crossAxisAlignment:
                                                        chats[idx].data()['sender'] == 'callerB' ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(context).size.width * 0.5,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(16),
                                                          child: Image.network(
                                                            chats[idx].data()['message'].toString(),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      // if (idx == 0)
                                                      Container(
                                                        width: MediaQuery.of(context).size.width * 0.5,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                if (await canLaunch(chats[idx].data()['message'].toString())) {
                                                                  launch(chats[idx].data()['message'].toString());
                                                                }
                                                                //   showDialog(
                                                                //       context:
                                                                //           context,
                                                                //       builder: (context) => CustomSimpleDialog(
                                                                //           icon: ImageIcon(
                                                                //             AssetImage(
                                                                //                 'assets/loadingPlaceholder.gif'),
                                                                //             size:
                                                                //                 100,
                                                                //             color:
                                                                //                 kGreenColor,
                                                                //           ),
                                                                //           onPressed: () {
                                                                //             Get.back();
                                                                //           },
                                                                //           title: "Processing File",
                                                                //           buttonTxt: "Konfirmasi",
                                                                //           subtitle: "Image sedang di download, harap tunggu"));
                                                                //   var imageId = await ImageDownloader
                                                                //       .downloadImage(chats[
                                                                //               idx]
                                                                //           .data()[
                                                                //               'message']
                                                                //           .toString());
                                                                //   print(
                                                                //       'imageId => $imageId');
                                                                //   if (imageId !=
                                                                //       null) {
                                                                //     showDialog(
                                                                //         context:
                                                                //             context,
                                                                //         builder: (context) => CustomSimpleDialog(
                                                                //             icon: ImageIcon(
                                                                //               AssetImage('assets/success_icon.png'),
                                                                //               size:
                                                                //                   100,
                                                                //               color:
                                                                //                   kGreenColor,
                                                                //             ),
                                                                //             onPressed: () {
                                                                //               Get.back();
                                                                //             },
                                                                //             title: "File Downloaded",
                                                                //             buttonTxt: "Konfirmasi",
                                                                //             subtitle: "File Berhasil di download, cek storage anda"));
                                                                //   }
                                                                //   isLoading =
                                                                //       false;
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Text(
                                                                  'Download',
                                                                  style: kPoppinsRegular400.copyWith(fontSize: 12, color: kDarkBlue),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              chats[idx].data()['time'] == null
                                                                  ? ""
                                                                  : f.format((chats[idx].data()['time'] as Timestamp).toDate()),
                                                              style: kPoppinsRegular400.copyWith(fontSize: 12, color: kBlackColor),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : Column(
                                                    crossAxisAlignment:
                                                        chats[idx].data()['sender'] == 'callerB' ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(context).size.width * 0.5,
                                                        decoration: BoxDecoration(
                                                            color: chats[idx].data()['sender'] == 'callerB' ? kWhiteGray : kButtonColor,
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(16),
                                                              topRight: Radius.circular(16),
                                                              bottomLeft:
                                                                  chats[idx].data()['sender'] == 'callerB' ? Radius.circular(0) : Radius.circular(16),
                                                              bottomRight:
                                                                  chats[idx].data()['sender'] == 'callerB' ? Radius.circular(16) : Radius.circular(0),
                                                            )),
                                                        padding: EdgeInsets.all(16),
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(8),
                                                              child: Image.asset(
                                                                'assets/memo.png',
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(context).size.width * 0.3,
                                                              child: Text(
                                                                chats[idx].data()['name'].toString(),
                                                                style: kPoppinsMedium500.copyWith(
                                                                    fontSize: 14,
                                                                    color: chats[idx].data()['sender'] == 'callerA' ? kBackground : kBlackColor),
                                                                softWrap: true,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      // if (idx == 0)
                                                      Container(
                                                        width: MediaQuery.of(context).size.width * 0.5,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                if (await canLaunch(chats[idx].data()['message'].toString())) {
                                                                  await launch(chats[idx].data()['message'].toString());
                                                                }
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Text(
                                                                  'Download',
                                                                  style: kPoppinsRegular400.copyWith(fontSize: 12, color: kDarkBlue),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              chats[idx].data()['time'] == null
                                                                  ? ""
                                                                  : f.format((chats[idx].data()['time'] as Timestamp).toDate()),
                                                              style: kPoppinsRegular400.copyWith(fontSize: 12, color: kBlackColor),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                      );
                                    },
                                  );
                                } else if (snapshot.data == null) {
                                  return const Center(child: Text("Snapshopt Data == null?"));
                                } else {
                                  return CupertinoActivityIndicator();
                                }
                              }),
                        ),
                      ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        // padding: EdgeInsets.only(bottom: (GetPlatform.isIOS) ? 25 : 0),
                        decoration: BoxDecoration(boxShadow: [kBoxShadow], color: kBackground),
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
                                  onPressed: () {
                                    myFocusNode.unfocus();
                                    showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                              child: Container(
                                                margin: EdgeInsets.all(16),
                                                width: MediaQuery.of(context).size.width * 0.6,
                                                height: MediaQuery.of(context).size.height * 0.15,
                                                decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(16)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                        callController.fileUrl.value = '';
                                                        Get.back();
                                                        await callController.pickImage(ImageSource.camera);
                                                        // setState(() {});
                                                        if (callController.fileUrl.value != '') {
                                                          await calls.doc(callId).collection('chat').add({
                                                            "message": callController.fileUrl.value,
                                                            "type": "image",
                                                            "time": FieldValue.serverTimestamp(),
                                                            "sender": "callerA"
                                                          });

                                                          DocumentSnapshot notif = await calls.doc(callId).get();
                                                          await calls
                                                              .doc(callId)
                                                              .update({"chatBCount": ((notif.data() as Map)['chatBCount'] as int) + 1});
                                                        }
                                                      },
                                                      child: Container(
                                                          margin: EdgeInsets.all(8),
                                                          child: Text(
                                                            'Ambil Gambar',
                                                            style: kPoppinsMedium500.copyWith(fontSize: 14, color: kBlackColor),
                                                          )),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                        callController.fileUrl.value = '';
                                                        Get.back();
                                                        await callController.pickImage(ImageSource.gallery);
                                                        if (callController.fileUrl.value != '') {
                                                          await calls.doc(callId).collection('chat').add({
                                                            "message": callController.fileUrl.value,
                                                            "type": "image",
                                                            "time": FieldValue.serverTimestamp(),
                                                            "sender": "callerA"
                                                          });
                                                          DocumentSnapshot notif = await calls.doc(callId).get();
                                                          await calls
                                                              .doc(callId)
                                                              .update({"chatBCount": ((notif.data() as Map)['chatBCount'] as int) + 1});
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets.all(8),
                                                        child: Text(
                                                          'Pilih dari Album',
                                                          style: kPoppinsMedium500.copyWith(fontSize: 14, color: kBlackColor),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                        callController.fileUrl.value = '';
                                                        Get.back();
                                                        await callController.pickFile();
                                                        // await controller
                                                        //     .pickImage(
                                                        //     ImageSource
                                                        //         .gallery);
                                                        // setState(() {});
                                                        if (callController.fileUrl.value != '') {
                                                          await calls.doc(callId).collection('chat').add({
                                                            "name": callController.fileName.value,
                                                            "message": callController.fileUrl.value,
                                                            "type": "file",
                                                            "time": FieldValue.serverTimestamp(),
                                                            "sender": "callerA"
                                                          });
                                                          DocumentSnapshot notif = await calls.doc(callId).get();
                                                          await calls
                                                              .doc(callId)
                                                              .update({"chatBCount": ((notif.data() as Map)['chatBCount'] as int) + 1});
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets.all(8),
                                                        child: Text(
                                                          'Pilih File',
                                                          style: kPoppinsMedium500.copyWith(fontSize: 14, color: kBlackColor),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ));
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                child: TextField(
                                  focusNode: myFocusNode,
                                  onSubmitted: (val) async {
                                    if (!isAllSpaces(message)) {
                                      await calls
                                          .doc(callId)
                                          .collection('chat')
                                          .add({"message": message, "type": "text", "time": FieldValue.serverTimestamp(), "sender": "callerA"});
                                      DocumentSnapshot notif = await calls.doc(callId).get();
                                      await calls.doc(callId).update({"chatBCount": ((notif.data() as Map)['chatBCount'] as int) + 1});
                                      txtController.clear();
                                      message = '';
                                      myFocusNode.requestFocus();
                                    }
                                  },
                                  controller: txtController,
                                  onChanged: (val) {
                                    message = val;
                                    // print('message => $val');
                                  },
                                  decoration: InputDecoration(
                                      hintText: 'Add text to this message',
                                      hintStyle: kPoppinsRegular400.copyWith(fontSize: 13, color: kBlackColor),
                                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.send,
                                    size: 20,
                                    color: kBlackColor,
                                  ),
                                  onPressed: () async {
                                    if (!isAllSpaces(message)) {
                                      await calls
                                          .doc(callId)
                                          .collection('chat')
                                          .add({"message": message, "type": "text", "time": FieldValue.serverTimestamp(), "sender": "callerA"});
                                      DocumentSnapshot notif = await calls.doc(callId).get();
                                      await calls.doc(callId).update({"chatBCount": ((notif.data() as Map)['chatBCount'] as int) + 1});
                                      txtController.clear();
                                      message = '';
                                      myFocusNode.requestFocus();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (GetPlatform.isIOS) const SizedBox(height: 10)
                  ],
                ),
              ),
            ),
          ),
          body: (callId.isEmpty)
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: ConnectivityBuilder(
                      builder: (context, isConnected, status) {
                        if (isConnected == false) {
                          isDisconnected = true;
                          // if (callScreenController.isMeDisconnect.value == false) {
                          //   // ? ini untuk handle toast kepanggil berkali kali (terjadi di mobile web)
                          //   Fluttertoast.showToast(
                          //     msg: "You are disconnected, will leave the room soon....",
                          //     backgroundColor: Colors.red.withOpacity(0.2),
                          //     textColor: Colors.red,
                          //     webShowClose: true,
                          //     timeInSecForIosWeb: 8,
                          //     fontSize: 13,
                          //     gravity: ToastGravity.TOP,
                          //     webPosition: 'center',
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     webBgColor: '#F8FCF5',
                          //   );
                          // }

                          // callScreenController.isMeDisconnect.value = true;
                          if (isDisconnected) {
                            isDisconnected = false;
                            // print('is Disconnected !!!');
                            Future.delayed(const Duration(seconds: 4), () async {
                              await signaling.localStream?.dispose();
                              signaling.localStream = null;

                              await signaling.peerConnection?.close();
                              signaling.peerConnection = null;

                              // await _fireStoreDataBase.collection('calls').doc(callId).set({
                              //   // 'callerB': false,
                              //   'callActive': false,
                              //   "isAlteaClick": false,
                              //   "maName": "",
                              // }, SetOptions(merge: true));

                              if (callScreenController.isMeDisconnect.value == false) {
                                Get.defaultDialog(
                                  title: "Call Disconnected",
                                  middleText: "Please check your wifi/signal condition...",
                                  backgroundColor: Colors.white,
                                  titleStyle: const TextStyle(color: Colors.green),
                                  middleTextStyle: const TextStyle(color: Colors.black),
                                );
                              }
                              callScreenController.isMeDisconnect.value = true;

                              // TODO : KETIKA USER DC (WIFI DC), tidak langsung ke HOME tapi ke My Consultation dulu, ini karena apa?
                              // TODO : SAMA tuh code yg ini kepanggil terus
                              Future.delayed(Duration(seconds: 1), () => Get.offNamed('/home'));
                            });
                          }

                          return Column(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                  color: Colors.black.withOpacity(0.9),
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width / 4,
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(20),
                                            color: Colors.grey.shade200,
                                            child: Icon(Icons.person),
                                          ),
                                        ),
                                        // child: InkWell(
                                        //   child: Text('Record', sty),
                                        // ) ,
                                      ),
                                      Text(formatTime(_stopwatch.elapsedMilliseconds),
                                          style: kPoppinsSemibold600.copyWith(fontSize: 20, color: kBackground)),
                                      CustomFlatButton(
                                          width: MediaQuery.of(context).size.width / 4,
                                          text: 'End Call',
                                          onPressed: () async {
                                            Get.defaultDialog(
                                              // content: Container(
                                              //     padding: EdgeInsets.all(8),
                                              //     child: Container()),

                                              title: '',
                                              titleStyle: kPoppinsSemibold600.copyWith(
                                                fontSize: 14,
                                                color: kBlackColor,
                                              ),
                                              content: Container(
                                                padding: EdgeInsets.only(left: 8),
                                                width: MediaQuery.of(context).size.width * 0.7,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Akhiri Panggilan',
                                                      style: kPoppinsSemibold600.copyWith(
                                                        fontSize: 16,
                                                        color: kBlackColor,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Text(
                                                      'Apakah anda ingin mengakhiri panggilan ?',
                                                      style: kPoppinsRegular400.copyWith(fontSize: 13, color: kBlackColor.withOpacity(0.7)),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              radius: 8,
                                              middleTextStyle: kPoppinsRegular400.copyWith(fontSize: 13, color: kBlackColor.withOpacity(0.7)),
                                              confirm: Transform(
                                                transform: Matrix4.translationValues(-25.0, 0.0, 0.0),
                                                child: CustomFlatButton(
                                                    width: MediaQuery.of(context).size.width * 0.29,
                                                    text: 'End Call',
                                                    onPressed: () async {
                                                      if (widget.callId == 'doctor') {
                                                        // print('doctorssss');
                                                        await _fireStoreDataBase.collection('calls').doc(callId).set({
                                                          // 'callerB': false,
                                                          // "isAlteaClick": false,
                                                          "maName": "",
                                                          "isCallOngoing": false,
                                                          "callActive": false,
                                                          "lastDC": "",
                                                        }, SetOptions(merge: true));
                                                        await closeCall(false);
                                                        Get.toNamed('/doctor-success-screen', arguments: formatTime(_stopwatch.elapsedMilliseconds));
                                                        // Get.back();
                                                      } else {
                                                        // print('maaaaaaaaaa');
                                                        await _fireStoreDataBase.collection('calls').doc(callId).set({
                                                          // 'callerB': false,
                                                          // "isAlteaClick": false,
                                                          "maName": "",
                                                          "isCallOngoing": false,
                                                          "callActive": false,
                                                          "lastDC": "",
                                                        }, SetOptions(merge: true));
                                                        await closeCall(false);
                                                        Get.offNamed('/home');
                                                      }
                                                    },
                                                    color: kButtonColor),
                                              ),
                                              cancel: Transform(
                                                transform: Matrix4.translationValues(-6.0, 0.0, 0.0),
                                                child: CustomFlatButton(
                                                  width: MediaQuery.of(context).size.width * 0.29,
                                                  text: 'Batal',
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  color: kBackground,
                                                  borderColor: kButtonColor,
                                                ),
                                              ),
                                            );
                                          }
                                          //
                                          ,
                                          color: kRedError)
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: Stack(
                                  children: [
                                    Container(
                                      color: Colors.black87.withOpacity(0.7),
                                      child: _localRenderer.renderVideo
                                          ? RTCVideoView(
                                              _localRenderer,
                                              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                                              mirror: false,
                                            )
                                          : Center(
                                              child: Icon(
                                                Icons.person,
                                                size: MediaQuery.of(context).size.width / 6,
                                                color: kBackground.withOpacity(0.5),
                                              ),
                                            ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        margin: EdgeInsets.all(16),
                                        padding: EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.mic,
                                              color: kBackground,
                                              size: 15,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            // Text(
                                            //   (snapshot.data?.data()! as Map)['maName'].toString(),
                                            //   style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBackground),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  color: Colors.black.withOpacity(0.9),
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            // print('video');
                                            signaling.changeVideoState(_localRenderer, _remoteRenderer, !videoState);
                                            videoState = !videoState;
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Color(0XFF5e5e5e),
                                          radius: MediaQuery.of(context).size.width / 14,
                                          child: Icon(
                                            !videoState ? Icons.videocam_off : Icons.videocam,
                                            color: kBackground,
                                            size: MediaQuery.of(context).size.width / 14,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            // print('audio');
                                            signaling.changeAudioState(_localRenderer, _remoteRenderer, !audioState);
                                            audioState = !audioState;
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Color(0XFF5e5e5e),
                                          radius: MediaQuery.of(context).size.width / 14,
                                          child: Icon(
                                            audioState ? Icons.mic : Icons.mic_off,
                                            color: kBackground,
                                            size: MediaQuery.of(context).size.width / 14,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          signaling.stopShare(_localRenderer, callId);
                                          await calls.doc(callId).update({"isCallerAShareScreen": false});
                                          setState(() {
                                            isSharing = !isSharing;
                                          });
                                          // print('share screen $callId');
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Color(0XFF5e5e5e),
                                          radius: MediaQuery.of(context).size.width / 14,
                                          child: Icon(
                                            Icons.open_in_browser_sharp,
                                            color: isSharing ? kRedError : kBackground,
                                            size: MediaQuery.of(context).size.width / 14,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          _pc.open();
                                          await calls.doc(callId).update({"chatACount": 0});
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Color(0XFF5e5e5e),
                                          radius: MediaQuery.of(context).size.width / 14,
                                          child: StreamBuilder<DocumentSnapshot>(
                                              stream: calls.doc(callId).snapshots(),
                                              builder: (context, snapshot) {
                                                return Stack(
                                                  children: [
                                                    if ((snapshot.data?.data()! as Map)['chatACount'] != 0)
                                                      Align(
                                                        alignment: Alignment.topRight,
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width * 0.05,
                                                          height: MediaQuery.of(context).size.width * 0.05,
                                                          decoration: BoxDecoration(
                                                            color: kRedError,
                                                            borderRadius: BorderRadius.circular(16),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              (snapshot.data?.data()! as Map)['chatACount'].toString(),
                                                              style: kPoppinsSemibold600.copyWith(fontSize: 10, color: kBackground),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Icon(
                                                        Icons.chat,
                                                        color: kBackground,
                                                        size: MediaQuery.of(context).size.width / 14,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          signaling.switchCamera();
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Color(0XFF5e5e5e),
                                          radius: MediaQuery.of(context).size.width / 14,
                                          child: ImageIcon(
                                            AssetImage('assets/call_camera_switch.png'),
                                            color: kBackground,
                                            size: MediaQuery.of(context).size.width / 9,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        } else {
                          return StreamBuilder<DocumentSnapshot>(
                            stream: _fireStoreDataBase.collection('calls').doc(callId).snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }
                              if (callerA && callerB && !init) {
                                init = true;
                                _stopwatch.reset();
                                // print("stopwatch ke-reset ${_stopwatch.elapsedMilliseconds}");
                              }
                              // if (snapshot.connectionState == ConnectionState.waiting) {
                              //   return Text("Loading");
                              // }

                              if (snapshot.hasData) {
                                callerA =
                                    (snapshot.data!.data() as Map)['callerA'] == null ? false : (snapshot.data!.data() as Map)['callerA'] as bool;
                                callerB =
                                    (snapshot.data!.data() as Map)['callerB'] == null ? false : (snapshot.data!.data() as Map)['callerB'] as bool;
                                // if (snapshot.data!['callActive'] == false) {
                                //   // print('call hanged up');
                                //   // // setState(() {
                                //   // signaling.hangUp(callId, roomId ?? '', _localRenderer);
                                //   // Get.toNamed('/choose-payment');
                                //   // // });
                                // }
                                callScreenController.callerA.value = (snapshot.data!.data() as Map)['isCallerAShareScreen'] == null
                                    ? false
                                    : (snapshot.data!.data() as Map)['isCallerAShareScreen'] as bool;
                                callScreenController.callerB.value = (snapshot.data!.data() as Map)['isCallerBShareScreen'] == null
                                    ? false
                                    : (snapshot.data!.data() as Map)['isCallerBShareScreen'] as bool;

                                if (!isConnectedAll && callerA && callerB) {
                                  // fToast.showToast(
                                  //   child: Container(
                                  //     height: MediaQuery.of(context).size.height * 0.05,
                                  //     width: MediaQuery.of(context).size.width * 0.7,
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(25),
                                  //       color: kBackground,
                                  //     ),
                                  //     child: Padding(
                                  //       padding: EdgeInsets.all(8),
                                  //       child: Center(
                                  //         child: Text(
                                  //           'Silahkan Tunggu. Sedang menyambungkan koneksi',
                                  //           style: kPoppinsMedium500.copyWith(
                                  //               color: kBlackColor, fontSize: 13),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  //   toastDuration: Duration(seconds: 11),
                                  //   gravity: ToastGravity.CENTER,
                                  // );
                                  // print("keluarin toast");
                                  // Get.snackbar(
                                  //   "Silakan tunggu, Sedang menyambungkan koneksi.",
                                  //   "",
                                  //   // icon: Icon(Icons.alarm),
                                  //   // shouldIconPulse: tru,
                                  //   // snackPosition: SnackPosition.BOTTOM,
                                  //   // onTap:(){},
                                  //   barBlur: 12,
                                  //   isDismissible: false,
                                  //   duration: Duration(seconds: 11),
                                  // );
                                  Fluttertoast.showToast(
                                    msg: "Silakan tunggu. Sedang menyambungkan koneksi",
                                    backgroundColor: kBackground,
                                    textColor: kButtonColor,
                                    webShowClose: true,
                                    timeInSecForIosWeb: 11,
                                    fontSize: 13,
                                    gravity: ToastGravity.TOP_RIGHT,
                                    webPosition: 'center',
                                    toastLength: Toast.LENGTH_LONG,
                                    webBgColor: '#F8FCF5',
                                  );
                                  isConnectedAll = true;
                                }
                              }
                              return (callerA && callerB) || (callerA && callScreenController.isTryingReconnect.value)
                                  ? !isOtherDisconnected
                                      //KEDUA USER MASIH TERKONEK
                                      ? isSharing
                                          //USER SEDANG SCREEN SHARING
                                          ? Column(
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(
                                                    color: Colors.black.withOpacity(0.9),
                                                    width: double.infinity,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(context).size.width / 4,
                                                          // child: InkWell(
                                                          //   child: Text('Record', sty),
                                                          // ) ,
                                                        ),
                                                        Text(formatTime(_stopwatch.elapsedMilliseconds),
                                                            style: kPoppinsSemibold600.copyWith(fontSize: 20, color: kBackground)),
                                                        CustomFlatButton(
                                                            width: MediaQuery.of(context).size.width / 4,
                                                            text: 'End Call',
                                                            onPressed: () async {
                                                              Get.defaultDialog(
                                                                // content: Container(
                                                                //     padding: EdgeInsets.all(8),
                                                                //     child: Container()),

                                                                title: '',
                                                                titleStyle: kPoppinsSemibold600.copyWith(
                                                                  fontSize: 14,
                                                                  color: kBlackColor,
                                                                ),
                                                                content: Container(
                                                                  padding: EdgeInsets.only(left: 8),
                                                                  width: MediaQuery.of(context).size.width * 0.7,
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        'Akhiri Panggilan ${widget.callId}',
                                                                        style: kPoppinsSemibold600.copyWith(
                                                                          fontSize: 16,
                                                                          color: kBlackColor,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: 8,
                                                                      ),
                                                                      Text(
                                                                        'Apakah anda ingin mengakhiri panggilan ?',
                                                                        style: kPoppinsRegular400.copyWith(
                                                                            fontSize: 13, color: kBlackColor.withOpacity(0.7)),
                                                                        textAlign: TextAlign.left,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                radius: 8,
                                                                middleTextStyle:
                                                                    kPoppinsRegular400.copyWith(fontSize: 13, color: kBlackColor.withOpacity(0.7)),
                                                                confirm: Transform(
                                                                  transform: Matrix4.translationValues(-25.0, 0.0, 0.0),
                                                                  child: CustomFlatButton(
                                                                      width: MediaQuery.of(context).size.width * 0.29,
                                                                      text: 'End Call',
                                                                      onPressed: () async {
                                                                        if (widget.callId == 'doctor') {
                                                                          // print('doctorssss');
                                                                          await _fireStoreDataBase.collection('calls').doc(callId).set({
                                                                            'callerB': false,
                                                                            "isAlteaClick": false,
                                                                            "maName": "",
                                                                            "lastDC": "",
                                                                          }, SetOptions(merge: true));
                                                                          await closeCall(false);
                                                                          // print('doctorssss');
                                                                          Get.toNamed('/doctor-success-screen',
                                                                              arguments: formatTime(_stopwatch.elapsedMilliseconds));
                                                                          // Get.back();
                                                                        } else {
                                                                          // print('maaaaaaaaaa');
                                                                          await closeCall(false);
                                                                          Get.offNamed('/home');
                                                                        }
                                                                      },
                                                                      color: kButtonColor),
                                                                ),
                                                                cancel: Transform(
                                                                  transform: Matrix4.translationValues(-6.0, 0.0, 0.0),
                                                                  child: CustomFlatButton(
                                                                    width: MediaQuery.of(context).size.width * 0.29,
                                                                    text: 'Batal',
                                                                    onPressed: () {
                                                                      Get.back();
                                                                    },
                                                                    color: kBackground,
                                                                    borderColor: kButtonColor,
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            //
                                                            ,
                                                            color: kRedError)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 10,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        color: Colors.black87.withOpacity(0.7),
                                                        child: _localRenderer.renderVideo
                                                            ? RTCVideoView(
                                                                _localRenderer,
                                                                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                                                                mirror: false,
                                                              )
                                                            : Center(
                                                                child: Icon(
                                                                  Icons.person,
                                                                  size: MediaQuery.of(context).size.width / 6,
                                                                  color: kBackground.withOpacity(0.5),
                                                                ),
                                                              ),
                                                      ),
                                                      Positioned(
                                                        bottom: 0,
                                                        left: 0,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.black26,
                                                            borderRadius: BorderRadius.circular(16),
                                                          ),
                                                          margin: EdgeInsets.all(16),
                                                          padding: EdgeInsets.all(16),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.mic,
                                                                color: kBackground,
                                                                size: 15,
                                                              ),
                                                              SizedBox(
                                                                width: 4,
                                                              ),
                                                              Text(
                                                                (snapshot.data?.data()! as Map)['maName'].toString(),
                                                                style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBackground),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 0,
                                                        right: 0,
                                                        child: Container(
                                                          margin: EdgeInsets.all(16),
                                                          width: MediaQuery.of(context).size.width / 3,
                                                          height: MediaQuery.of(context).size.height / 5,
                                                          decoration: BoxDecoration(
                                                            color: Colors.black54,
                                                            border: Border.all(color: kBackground, width: 4),
                                                            borderRadius: BorderRadius.circular(24),
                                                          ),
                                                          child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(16),
                                                              child: _remoteRenderer.renderVideo
                                                                  ? RTCVideoView(
                                                                      _remoteRenderer,
                                                                      mirror: true,
                                                                      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                                                                    )
                                                                  : Center(
                                                                      child: Icon(
                                                                        Icons.person,
                                                                        size: MediaQuery.of(context).size.width / 6,
                                                                        color: kBackground.withOpacity(0.5),
                                                                      ),
                                                                    )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    color: Colors.black.withOpacity(0.9),
                                                    width: double.infinity,
                                                    padding: EdgeInsets.all(16),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              // print('video');
                                                              signaling.changeVideoState(_localRenderer, _remoteRenderer, !videoState);
                                                              videoState = !videoState;
                                                            });
                                                          },
                                                          child: CircleAvatar(
                                                            backgroundColor: Color(0XFF5e5e5e),
                                                            radius: MediaQuery.of(context).size.width / 14,
                                                            child: Icon(
                                                              !videoState ? Icons.videocam_off : Icons.videocam,
                                                              color: kBackground,
                                                              size: MediaQuery.of(context).size.width / 14,
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              // print('audio');
                                                              signaling.changeAudioState(_localRenderer, _remoteRenderer, !audioState);
                                                              audioState = !audioState;
                                                            });
                                                          },
                                                          child: CircleAvatar(
                                                            backgroundColor: Color(0XFF5e5e5e),
                                                            radius: MediaQuery.of(context).size.width / 14,
                                                            child: Icon(
                                                              audioState ? Icons.mic : Icons.mic_off,
                                                              color: kBackground,
                                                              size: MediaQuery.of(context).size.width / 14,
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            signaling.stopShare(_localRenderer, callId);
                                                            await calls.doc(callId).update({"isCallerAShareScreen": false});
                                                            setState(() {
                                                              isSharing = !isSharing;
                                                            });
                                                            // print('share screen $callId');
                                                          },
                                                          child: CircleAvatar(
                                                            backgroundColor: Color(0XFF5e5e5e),
                                                            radius: MediaQuery.of(context).size.width / 14,
                                                            child: Icon(
                                                              Icons.open_in_browser_sharp,
                                                              color: isSharing ? kRedError : kBackground,
                                                              size: MediaQuery.of(context).size.width / 14,
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            _pc.open();
                                                            await calls.doc(callId).update({"chatACount": 0});
                                                          },
                                                          child: CircleAvatar(
                                                            backgroundColor: Color(0XFF5e5e5e),
                                                            radius: MediaQuery.of(context).size.width / 14,
                                                            child: StreamBuilder<DocumentSnapshot>(
                                                                stream: calls.doc(callId).snapshots(),
                                                                builder: (context, snapshot) {
                                                                  return Stack(
                                                                    children: [
                                                                      if ((snapshot.data?.data()! as Map)['chatACount'] != 0)
                                                                        Align(
                                                                          alignment: Alignment.topRight,
                                                                          child: Container(
                                                                            width: MediaQuery.of(context).size.width * 0.05,
                                                                            height: MediaQuery.of(context).size.width * 0.05,
                                                                            decoration: BoxDecoration(
                                                                              color: kRedError,
                                                                              borderRadius: BorderRadius.circular(16),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                (snapshot.data?.data()! as Map)['chatACount'].toString(),
                                                                                style: kPoppinsSemibold600.copyWith(fontSize: 10, color: kBackground),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      Align(
                                                                        alignment: Alignment.center,
                                                                        child: Icon(
                                                                          Icons.chat,
                                                                          color: kBackground,
                                                                          size: MediaQuery.of(context).size.width / 14,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                }),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            signaling.switchCamera();
                                                          },
                                                          child: CircleAvatar(
                                                            backgroundColor: Color(0XFF5e5e5e),
                                                            radius: MediaQuery.of(context).size.width / 14,
                                                            child: ImageIcon(
                                                              AssetImage('assets/call_camera_switch.png'),
                                                              color: kBackground,
                                                              size: MediaQuery.of(context).size.width / 9,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          //USER TIDAK SEDANG SHARE SCREEN
                                          : Column(
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(
                                                    color: Colors.black.withOpacity(0.9),
                                                    width: double.infinity,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(context).size.width / 4,
                                                          // child: InkWell(
                                                          //   child: Text('Record', sty),
                                                          // ) ,
                                                        ),
                                                        Text(formatTime(_stopwatch.elapsedMilliseconds),
                                                            style: kPoppinsSemibold600.copyWith(fontSize: 20, color: kBackground)),
                                                        CustomFlatButton(
                                                            width: MediaQuery.of(context).size.width / 4,
                                                            text: 'End Call',
                                                            onPressed: () async {
                                                              Get.defaultDialog(
                                                                // content: Container(
                                                                //     padding: EdgeInsets.all(8),
                                                                //     child: Container()),

                                                                title: '',
                                                                titleStyle: kPoppinsSemibold600.copyWith(
                                                                  fontSize: 14,
                                                                  color: kBlackColor,
                                                                ),
                                                                content: Container(
                                                                  padding: EdgeInsets.only(left: 8),
                                                                  width: MediaQuery.of(context).size.width * 0.7,
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        'Akhiri Panggilan',
                                                                        style: kPoppinsSemibold600.copyWith(
                                                                          fontSize: 16,
                                                                          color: kBlackColor,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: 8,
                                                                      ),
                                                                      Text(
                                                                        'Apakah anda ingin mengakhiri panggilan ?',
                                                                        style: kPoppinsRegular400.copyWith(
                                                                            fontSize: 13, color: kBlackColor.withOpacity(0.7)),
                                                                        textAlign: TextAlign.left,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                radius: 8,
                                                                middleTextStyle:
                                                                    kPoppinsRegular400.copyWith(fontSize: 13, color: kBlackColor.withOpacity(0.7)),
                                                                confirm: Transform(
                                                                  transform: Matrix4.translationValues(-25.0, 0.0, 0.0),
                                                                  child: CustomFlatButton(
                                                                      width: MediaQuery.of(context).size.width * 0.29,
                                                                      text: 'End Call',
                                                                      onPressed: () async {
                                                                        Get.back();
                                                                        if (widget.callId == 'doctor') {
                                                                          // print('doctorssss');
                                                                          await _fireStoreDataBase.collection('calls').doc(callId).set({
                                                                            'callerB': false,
                                                                            "isAlteaClick": false,
                                                                            "maName": "",
                                                                            "lastDC": "",
                                                                          }, SetOptions(merge: true));
                                                                          await closeCall(false);
                                                                          Get.toNamed('/doctor-success-screen',
                                                                              arguments: formatTime(_stopwatch.elapsedMilliseconds));
                                                                          // Get.back();
                                                                        } else {
                                                                          // print('maaaaaaaaaa');
                                                                          await closeCall(false);
                                                                          Get.offNamed('/home');
                                                                        }
                                                                      },
                                                                      color: kButtonColor),
                                                                ),
                                                                cancel: Transform(
                                                                  transform: Matrix4.translationValues(-6.0, 0.0, 0.0),
                                                                  child: CustomFlatButton(
                                                                    width: MediaQuery.of(context).size.width * 0.29,
                                                                    text: 'Batal',
                                                                    onPressed: () {
                                                                      Get.back();
                                                                    },
                                                                    color: kBackground,
                                                                    borderColor: kButtonColor,
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            //
                                                            ,
                                                            color: kRedError)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                if (snapshot.data != null)
                                                  Expanded(
                                                    flex: 10,
                                                    child: Stack(
                                                      children: [
                                                        InteractiveViewer(
                                                          maxScale: 4,
                                                          minScale: 0.5,
                                                          constrained: true,
                                                          child: Container(
                                                              color: Colors.black87.withOpacity(0.7),
                                                              child: _remoteRenderer.renderVideo
                                                                  ? RTCVideoView(
                                                                      _remoteRenderer,
                                                                      objectFit: (snapshot.data!['isCallerBShareScreen'] == null
                                                                              ? false
                                                                              : snapshot.data!['isCallerBShareScreen'] as bool)
                                                                          ? RTCVideoViewObjectFit.RTCVideoViewObjectFitContain
                                                                          : RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                                                                    )
                                                                  : Center(
                                                                      child: Icon(
                                                                        Icons.person,
                                                                        size: MediaQuery.of(context).size.width / 6,
                                                                        color: kBackground,
                                                                      ),
                                                                    )),
                                                        ),
                                                        Positioned(
                                                          bottom: 0,
                                                          left: 0,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.black26,
                                                              borderRadius: BorderRadius.circular(16),
                                                            ),
                                                            margin: EdgeInsets.all(16),
                                                            padding: EdgeInsets.all(16),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.mic,
                                                                  color: kBackground,
                                                                  size: 15,
                                                                ),
                                                                SizedBox(
                                                                  width: 4,
                                                                ),
                                                                Text(
                                                                  (snapshot.data?.data()! as Map)['maName'].toString(),
                                                                  style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBackground),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          bottom: 0,
                                                          right: 0,
                                                          child: Container(
                                                            margin: EdgeInsets.all(16),
                                                            width: MediaQuery.of(context).size.width / 3,
                                                            height: MediaQuery.of(context).size.height / 5,
                                                            decoration: BoxDecoration(
                                                              color: Colors.black54,
                                                              border: Border.all(color: kBackground, width: 4),
                                                              borderRadius: BorderRadius.circular(16),
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(12),
                                                              child: _localRenderer.renderVideo
                                                                  ? RTCVideoView(
                                                                      _localRenderer,
                                                                      mirror: true,
                                                                      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                                                                    )
                                                                  : Center(
                                                                      child: Icon(
                                                                        Icons.person,
                                                                        size: MediaQuery.of(context).size.width / 6,
                                                                        color: kBackground,
                                                                      ),
                                                                    ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    color: Colors.black.withOpacity(0.9),
                                                    width: double.infinity,
                                                    padding: EdgeInsets.all(16),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              // print('video');
                                                              signaling.changeVideoState(_localRenderer, _remoteRenderer, !videoState);
                                                              videoState = !videoState;
                                                            });
                                                          },
                                                          child: CircleAvatar(
                                                            backgroundColor: Color(0XFF5e5e5e),
                                                            radius: MediaQuery.of(context).size.width / 14,
                                                            child: Icon(
                                                              !videoState ? Icons.videocam_off : Icons.videocam,
                                                              color: kBackground,
                                                              size: MediaQuery.of(context).size.width / 14,
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              // print('audio');
                                                              signaling.changeAudioState(_localRenderer, _remoteRenderer, !audioState);
                                                              audioState = !audioState;
                                                            });
                                                          },
                                                          child: CircleAvatar(
                                                            backgroundColor: Color(0XFF5e5e5e),
                                                            radius: MediaQuery.of(context).size.width / 14,
                                                            child: Icon(
                                                              audioState ? Icons.mic : Icons.mic_off,
                                                              color: kBackground,
                                                              size: MediaQuery.of(context).size.width / 14,
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            // print('share screen $callId');
                                                            Get.defaultDialog(
                                                              // content: Container(
                                                              //     padding: EdgeInsets.all(8),
                                                              //     child: Container()),
                                                              title: 'Screen Sharing',
                                                              titleStyle: kPoppinsSemibold600.copyWith(fontSize: 14, color: kBlackColor),
                                                              middleText: 'Apakah anda ingin meembagikan layar anda ?',
                                                              radius: 8,
                                                              middleTextStyle:
                                                                  kPoppinsRegular400.copyWith(fontSize: 13, color: kBlackColor.withOpacity(0.7)),
                                                              confirm: CustomFlatButton(
                                                                  width: MediaQuery.of(context).size.width * 0.2,
                                                                  text: 'Ya',
                                                                  onPressed: () async {
                                                                    if (!isSharing) {
                                                                      signaling.shareScreen(_localRenderer, callId);
                                                                    }
                                                                    setState(() {
                                                                      isSharing = !isSharing;
                                                                    });
                                                                    Get.back();
                                                                    await calls.doc(callId).update({
                                                                      "isCallerAShareScreen": true,
                                                                    });
                                                                  },
                                                                  color: kButtonColor),
                                                              cancel: CustomFlatButton(
                                                                width: MediaQuery.of(context).size.width * 0.2,
                                                                text: 'Batal',
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                color: kBackground,
                                                                borderColor: kButtonColor,
                                                              ),
                                                            );
                                                          },
                                                          child: CircleAvatar(
                                                            backgroundColor: Color(0XFF5e5e5e),
                                                            radius: MediaQuery.of(context).size.width / 14,
                                                            child: Icon(
                                                              Icons.open_in_browser_sharp,
                                                              color: isSharing ? kRedError : kBackground,
                                                              size: MediaQuery.of(context).size.width / 14,
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            _pc.open();
                                                            await calls.doc(callId).update({"chatACount": 0});
                                                          },
                                                          child: CircleAvatar(
                                                            backgroundColor: Color(0XFF5e5e5e),
                                                            radius: MediaQuery.of(context).size.width / 14,
                                                            child: StreamBuilder<DocumentSnapshot>(
                                                                stream: calls.doc(callId).snapshots(),
                                                                builder: (context, snapshot) {
                                                                  return (snapshot.data?.data() == null)
                                                                      ? const Center(child: Text("SNAPSHOT DATA== null 02"))
                                                                      : Stack(
                                                                          children: [
                                                                            if ((snapshot.data?.data()! as Map)['chatACount'] != 0)
                                                                              Align(
                                                                                alignment: Alignment.topRight,
                                                                                child: Container(
                                                                                  width: MediaQuery.of(context).size.width * 0.05,
                                                                                  height: MediaQuery.of(context).size.width * 0.05,
                                                                                  decoration: BoxDecoration(
                                                                                    color: kRedError,
                                                                                    borderRadius: BorderRadius.circular(16),
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      (snapshot.data?.data()! as Map)['chatACount'].toString(),
                                                                                      style: kPoppinsSemibold600.copyWith(
                                                                                          fontSize: 10, color: kBackground),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            Align(
                                                                              alignment: Alignment.center,
                                                                              child: Icon(
                                                                                Icons.chat,
                                                                                color: kBackground,
                                                                                size: MediaQuery.of(context).size.width / 14,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                }),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            signaling.switchCamera();
                                                          },
                                                          child: CircleAvatar(
                                                            backgroundColor: Color(0XFF5e5e5e),
                                                            radius: MediaQuery.of(context).size.width / 14,
                                                            child: ImageIcon(
                                                              AssetImage('assets/call_camera_switch.png'),
                                                              color: kBackground,
                                                              size: MediaQuery.of(context).size.width / 9,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                      //SALAH SATU USER TERDISCONNECT
                                      : Column(
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                color: Colors.black.withOpacity(0.9),
                                                width: double.infinity,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width / 4,
                                                      // child: InkWell(
                                                      //   child: Text('Record', sty),
                                                      // ) ,
                                                    ),
                                                    Text(formatTime(_stopwatch.elapsedMilliseconds),
                                                        style: kPoppinsSemibold600.copyWith(fontSize: 20, color: kBackground)),
                                                    CustomFlatButton(
                                                        width: MediaQuery.of(context).size.width / 4,
                                                        text: 'End Call',
                                                        onPressed: () async {
                                                          Get.defaultDialog(
                                                            // content: Container(
                                                            //     padding: EdgeInsets.all(8),
                                                            //     child: Container()),

                                                            title: '',
                                                            titleStyle: kPoppinsSemibold600.copyWith(
                                                              fontSize: 14,
                                                              color: kBlackColor,
                                                            ),
                                                            content: Container(
                                                              padding: EdgeInsets.only(left: 8),
                                                              width: MediaQuery.of(context).size.width * 0.7,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'Akhiri Panggilan',
                                                                    style: kPoppinsSemibold600.copyWith(
                                                                      fontSize: 16,
                                                                      color: kBlackColor,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 8,
                                                                  ),
                                                                  Text(
                                                                    'Apakah anda ingin mengakhiri panggilan ?',
                                                                    style: kPoppinsRegular400.copyWith(
                                                                        fontSize: 13, color: kBlackColor.withOpacity(0.7)),
                                                                    textAlign: TextAlign.left,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            radius: 8,
                                                            middleTextStyle:
                                                                kPoppinsRegular400.copyWith(fontSize: 13, color: kBlackColor.withOpacity(0.7)),
                                                            confirm: Transform(
                                                              transform: Matrix4.translationValues(-25.0, 0.0, 0.0),
                                                              child: CustomFlatButton(
                                                                  width: MediaQuery.of(context).size.width * 0.29,
                                                                  text: 'End Call',
                                                                  onPressed: () async {
                                                                    if (widget.callId == 'doctor') {
                                                                      // print('doctorssss');
                                                                      await closeCall(false);
                                                                      Get.toNamed('/doctor-success-screen',
                                                                          arguments: formatTime(_stopwatch.elapsedMilliseconds));
                                                                      // Get.back();
                                                                    } else {
                                                                      // print('maaaaaaaaaa');
                                                                      await closeCall(false);
                                                                      Get.offNamed('/home');
                                                                    }
                                                                  },
                                                                  color: kButtonColor),
                                                            ),
                                                            cancel: Transform(
                                                              transform: Matrix4.translationValues(-6.0, 0.0, 0.0),
                                                              child: CustomFlatButton(
                                                                width: MediaQuery.of(context).size.width * 0.29,
                                                                text: 'Batal',
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                color: kBackground,
                                                                borderColor: kButtonColor,
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        //
                                                        ,
                                                        color: kRedError)
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 10,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    color: Colors.black87.withOpacity(0.7),
                                                    child: _localRenderer.renderVideo
                                                        ? RTCVideoView(
                                                            _localRenderer,
                                                            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                                                            mirror: false,
                                                          )
                                                        : Center(
                                                            child: Icon(
                                                              Icons.person,
                                                              size: MediaQuery.of(context).size.width / 6,
                                                              color: kBackground.withOpacity(0.5),
                                                            ),
                                                          ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    left: 0,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.black26,
                                                        borderRadius: BorderRadius.circular(16),
                                                      ),
                                                      margin: EdgeInsets.all(16),
                                                      padding: EdgeInsets.all(16),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.mic,
                                                            color: kBackground,
                                                            size: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            (snapshot.data?.data()! as Map)['maName'].toString(),
                                                            style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBackground),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  // Positioned(
                                                  //   bottom: 0,
                                                  //   right: 0,
                                                  //   child: Container(
                                                  //     margin: EdgeInsets.all(16),
                                                  //     width: MediaQuery.of(context)
                                                  //             .size
                                                  //             .width /
                                                  //         3,
                                                  //     height: MediaQuery.of(context)
                                                  //             .size
                                                  //             .height /
                                                  //         5,
                                                  //     decoration: BoxDecoration(
                                                  //       color: Colors.black54,
                                                  //       border: Border.all(
                                                  //           color: kBackground, width: 4),
                                                  //       borderRadius:
                                                  //           BorderRadius.circular(24),
                                                  //     ),
                                                  //     child: ClipRRect(
                                                  //         borderRadius:
                                                  //             BorderRadius.circular(16),
                                                  //         child: _remoteRenderer
                                                  //                 .renderVideo
                                                  //             ? RTCVideoView(
                                                  //                 _remoteRenderer,
                                                  //                 mirror: true,
                                                  //                 objectFit:
                                                  //                     RTCVideoViewObjectFit
                                                  //                         .RTCVideoViewObjectFitCover,
                                                  //               )
                                                  //             : Center(
                                                  //                 child: Icon(
                                                  //                   Icons.person,
                                                  //                   size: MediaQuery.of(
                                                  //                               context)
                                                  //                           .size
                                                  //                           .width /
                                                  //                       6,
                                                  //                   color: kBackground
                                                  //                       .withOpacity(0.5),
                                                  //                 ),
                                                  //               )),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                color: Colors.black.withOpacity(0.9),
                                                width: double.infinity,
                                                padding: EdgeInsets.all(16),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          // print('video');
                                                          signaling.changeVideoState(_localRenderer, _remoteRenderer, !videoState);
                                                          videoState = !videoState;
                                                        });
                                                      },
                                                      child: CircleAvatar(
                                                        backgroundColor: Color(0XFF5e5e5e),
                                                        radius: MediaQuery.of(context).size.width / 14,
                                                        child: Icon(
                                                          !videoState ? Icons.videocam_off : Icons.videocam,
                                                          color: kBackground,
                                                          size: MediaQuery.of(context).size.width / 14,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          // print('audio');
                                                          signaling.changeAudioState(_localRenderer, _remoteRenderer, !audioState);
                                                          audioState = !audioState;
                                                        });
                                                      },
                                                      child: CircleAvatar(
                                                        backgroundColor: Color(0XFF5e5e5e),
                                                        radius: MediaQuery.of(context).size.width / 14,
                                                        child: Icon(
                                                          audioState ? Icons.mic : Icons.mic_off,
                                                          color: kBackground,
                                                          size: MediaQuery.of(context).size.width / 14,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        signaling.stopShare(_localRenderer, callId);
                                                        await calls.doc(callId).update({"isCallerAShareScreen": false});
                                                        setState(() {
                                                          isSharing = !isSharing;
                                                        });
                                                        // print('share screen $callId');
                                                      },
                                                      child: CircleAvatar(
                                                        backgroundColor: Color(0XFF5e5e5e),
                                                        radius: MediaQuery.of(context).size.width / 14,
                                                        child: Icon(
                                                          Icons.open_in_browser_sharp,
                                                          color: isSharing ? kRedError : kBackground,
                                                          size: MediaQuery.of(context).size.width / 14,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        _pc.open();
                                                        await calls.doc(callId).update({"chatACount": 0});
                                                      },
                                                      child: CircleAvatar(
                                                        backgroundColor: Color(0XFF5e5e5e),
                                                        radius: MediaQuery.of(context).size.width / 14,
                                                        child: StreamBuilder<DocumentSnapshot>(
                                                            stream: calls.doc(callId).snapshots(),
                                                            builder: (context, snapshot) {
                                                              return Stack(
                                                                children: [
                                                                  if ((snapshot.data?.data()! as Map)['chatACount'] != 0)
                                                                    Align(
                                                                      alignment: Alignment.topRight,
                                                                      child: Container(
                                                                        width: MediaQuery.of(context).size.width * 0.05,
                                                                        height: MediaQuery.of(context).size.width * 0.05,
                                                                        decoration: BoxDecoration(
                                                                          color: kRedError,
                                                                          borderRadius: BorderRadius.circular(16),
                                                                        ),
                                                                        child: Center(
                                                                          child: Text(
                                                                            (snapshot.data?.data()! as Map)['chatACount'].toString(),
                                                                            style: kPoppinsSemibold600.copyWith(fontSize: 10, color: kBackground),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  Align(
                                                                    alignment: Alignment.center,
                                                                    child: Icon(
                                                                      Icons.chat,
                                                                      color: kBackground,
                                                                      size: MediaQuery.of(context).size.width / 14,
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            }),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        signaling.switchCamera();
                                                      },
                                                      child: CircleAvatar(
                                                        backgroundColor: Color(0XFF5e5e5e),
                                                        radius: MediaQuery.of(context).size.width / 14,
                                                        child: ImageIcon(
                                                          AssetImage('assets/call_camera_switch.png'),
                                                          color: kBackground,
                                                          size: MediaQuery.of(context).size.width / 9,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                  : callerA
                                      ? MobileAppView(
                                          isDoctor: ModalRoute.of(context)!.settings.arguments == 'doctor',
                                          stopCall: closeCall,
                                        )
                                      : Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            // width: MediaQuery.of(context).size.width * 0.3,
                                            // height: MediaQuery.of(context).size.height * 0.55,
                                            decoration: BoxDecoration(
                                                color: kBackground, borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.5)),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const ImageIcon(
                                                  AssetImage('assets/group-5.png'),
                                                  color: kRedError,
                                                  size: 150,
                                                ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                Text(
                                                  'Mohon Maaf, Terjadi Kesalahan',
                                                  style: kDialogTitleStyle,
                                                ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width * 0.5,
                                                  child: Text(
                                                    "Jaringan anda terputus saat sedang melakukan panggilan",
                                                    softWrap: true,
                                                    textAlign: TextAlign.center,
                                                    style: kDialogSubTitleStyle.copyWith(fontSize: 24),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                CustomFlatButton(
                                                  width: double.infinity,
                                                  text: "Coba Lagi",
                                                  onPressed: () {
                                                    initRoom();
                                                  },
                                                  color: kButtonColor,
                                                ),
                                                CustomFlatButton(
                                                  width: double.infinity,
                                                  text: "Kembali ke Beranda",
                                                  onPressed: () async {
                                                    await closeCall(false);
                                                    await Future.delayed(const Duration(seconds: 1), () async {
                                                      Get.offNamed('/home');
                                                    });
                                                  },
                                                  color: kButtonColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
