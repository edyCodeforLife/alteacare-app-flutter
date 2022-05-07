// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
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

class IOSCallView extends StatefulWidget {
  final String? callId;
  IOSCallView({required this.callId});

  @override
  _IOSCallViewState createState() => _IOSCallViewState();
}

class _IOSCallViewState extends State<IOSCallView> with WidgetsBindingObserver {
  PatientConfirmationController controller = Get.find<PatientConfirmationController>();
  SpesialisKonsultasiController konsultasiController = Get.find<SpesialisKonsultasiController>();
  CallScreenController callController = Get.find<CallScreenController>();
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  RTCVideoRenderer _shareRenderer = RTCVideoRenderer();
  bool connectionEstablished = false;
  String? roomId;
  bool callerA = false;
  bool callerB = false;
  var callId = '';
  bool videoState = true;
  bool audioState = true;
  bool isSharing = false;
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
  final callScreenController = Get.find<CallScreenController>();
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

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  late Timer _timer;

  Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    // print('call id => ${widget.callId}');
    // checkIfDocExists(widget.callId.toString());
    // TODO: implement initState
    super.initState();
    _stopwatch.start();
    _timer = new Timer.periodic(new Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
    _localRenderer.initialize();
    _shareRenderer.initialize();
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

  void checkEndCall() {
    // print("MASUK CEK END CALL $callId");
    if (callId.isNotEmpty) {
      final myStream = _fireStoreDataBase.collection('calls').doc(callId).snapshots();
      myStream.listen((dataa) async {
        // print("call active -> ${dataa.data()!["callActive"]}");
        if (dataa.data()!["callActive"] == false) {
          signaling.hangUp(callId, roomId, _localRenderer);

          if (widget.callId == 'doctor') {
            Get.toNamed('/doctor-success-screen', arguments: formatTime(_stopwatch.elapsedMilliseconds));
          } else {
            var res = await controller.createAppointment({
              "doctor_id": konsultasiController.selectedDoctor.value,
              "patient_id": konsultasiController.selectedUid.value,
              "symptom_note": "",
              "consultation_method": konsultasiController.consultBy.value,
              "schedules": [konsultasiController.selectedDoctorTime.value.toJson2()],
            });

            // print("res => $res");

            if (res['status'] == true) {
              setState(() {
                closeCall();
              });
              Get.toNamed('/choose-payment', arguments: res['data']["appointment_id"]);
            }
          }
        }
      });
    }
  }

  Future<bool> checkIfDocExists(String docId) async {
    // print("cek reference $docId");
    // try {
    // Get reference to Firestore collection
    var collectionRef = FirebaseFirestore.instance.collection('calls');

    var doc = await collectionRef.doc(docId).get();
    return doc.exists;
    // } catch (e) {
    // print(e.toString());
    // throw e;
    // }
  }

  CollectionReference calls = FirebaseFirestore.instance.collection('calls');
  ScrollController scrollController = ScrollController();
  void initRoom() async {
    // print('init room!!');
    await signaling.initiateStream();
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
      await _fireStoreDataBase.collection('calls').doc(callId).set({'callerB': true}, SetOptions(merge: true));
      _fireStoreDataBase.collection('calls').doc(callId).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          // print('Document data: ${documentSnapshot.data()}');
          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          signaling.joinRoom(callId, data['roomId'].toString(), _remoteRenderer);
        } else {
          // print('Document does not exist on the database');
        }
      });
    } else {
      // print('masuk siniiii 23 ${widget.callId}');
      try {
        Map<String, dynamic> body = {
          'name': widget.callId == 'doctor'
              ? 'Call for Doctor from  ${user.data!.firstName} ${user.data!.lastName}'
              : 'Call from ${user.data!.firstName} ${user.data!.lastName}', // John Doe
          'callerA': true, // Stokes and Sons
          'callerB': false,
          'chatACount': 0,
          'isAlteaClick': false,
          'chatBCount': 0,
          "isCallerAShareScreen": false,
          "isCallerBShareScreen": false,
          'callActive': true // 42
        };

        // String docId = DateTime.now().millisecondsSinceEpoch.toString();
        // print("coba lagi");
        // var documentReference = FirebaseFirestore.instance.collection('calls').doc();
        // documentReference.set(body).whenComplete(() {
        //   print("coba lagi udah komplit");

        //   setState(() {
        //     callId = documentReference.id;
        //   });
        //   print("coba lagi callId : $callId");
        // }).catchError((e) => print(e.toString()));

        // print(body);
        DocumentReference docRef = await calls.add(body);
        // print('docRef => $docRef');
        setState(() {
          callId = docRef.id;
        });
        roomId = await signaling.createRoom(callId, _remoteRenderer);
        await calls.doc(callId).set({'roomId': roomId}, SetOptions(merge: true));
      } catch (e) {
        // print('errorr call => $e');
      }
    }
    // print('createCall');
    callScreenController.theCaller.value = true;
    createCall();
    checkEndCall();
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

  void closeCall() async {
    await _fireStoreDataBase.collection('calls').doc(callId).set({'callActive': false}, SetOptions(merge: true));
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
    _shareRenderer.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    _stopwatch.stop();
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // print('state = $state');
    if (state == AppLifecycleState.detached) {
      // print('closing app !!');
      await signaling.hangUp(callId, roomId, _localRenderer);
    }
  }

  TextEditingController txtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // print('view inset => ${MediaQuery.of(context).viewInsets.bottom}');
    // print('height => ${MediaQuery.of(context).size.height}');
    return WillPopScope(
      onWillPop: () async {
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
                    closeCall();
                    Get.toNamed('/doctor-success-screen', arguments: formatTime(_stopwatch.elapsedMilliseconds));
                    // Get.back();
                  } else {
                    var res = await controller.createAppointment({
                      "doctor_id": konsultasiController.selectedDoctor.value,
                      "patient_id": konsultasiController.selectedUid.value,
                      "symptom_note": "",
                      "consultation_method": konsultasiController.consultBy.value,
                      "schedules": [konsultasiController.selectedDoctorTime.value.toJson2()],
                    });

                    // print("res => $res");

                    if (res['status'] == true) {
                      setState(() {
                        closeCall();
                      });
                      Get.toNamed('/choose-payment', arguments: res['data']["appointment_id"]);
                    }
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
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: (callId.isEmpty)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SlidingUpPanel(
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
                                        onPressed: () => _pc.close())
                                  ],
                                )),
                          ),

                          // CHAT SECTION
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
                                                              fontSize: 11,
                                                              color: chats[idx].data()['sender'] == 'callerB' ? kBlackColor : kBackground),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      // if (idx == 0)
                                                      Text(
                                                        f.format((chats[idx].data()['time'] as Timestamp).toDate()),
                                                        style: kPoppinsRegular400.copyWith(fontSize: 12, color: kBlackColor),
                                                      )
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
                                                        crossAxisAlignment: chats[idx].data()['sender'] == 'callerB'
                                                            ? CrossAxisAlignment.start
                                                            : CrossAxisAlignment.end,
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
                                                                    var imageId =
                                                                        await ImageDownloader.downloadImage(chats[idx].data()['message'].toString());
                                                                    // print('imageId => $imageId');
                                                                    if (imageId != null) {
                                                                      showDialog(
                                                                          context: context,
                                                                          builder: (context) => CustomSimpleDialog(
                                                                              icon: ImageIcon(
                                                                                AssetImage('assets/success_icon.png'),
                                                                                size: 100,
                                                                                color: kGreenColor,
                                                                              ),
                                                                              onPressed: () {
                                                                                Get.back();
                                                                              },
                                                                              title: "File Downloaded",
                                                                              buttonTxt: "Konfirmasi",
                                                                              subtitle: "File Berhasil di download, cek storage anda"));
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    'Download',
                                                                    style: kPoppinsRegular400.copyWith(fontSize: 12, color: kDarkBlue),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  f.format((chats[idx].data()['time'] as Timestamp).toDate()),
                                                                  style: kPoppinsRegular400.copyWith(fontSize: 12, color: kBlackColor),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    : Column(
                                                        crossAxisAlignment: chats[idx].data()['sender'] == 'callerB'
                                                            ? CrossAxisAlignment.start
                                                            : CrossAxisAlignment.end,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(context).size.width * 0.5,
                                                            decoration: BoxDecoration(
                                                                color: chats[idx].data()['sender'] == 'callerB' ? kWhiteGray : kButtonColor,
                                                                borderRadius: BorderRadius.only(
                                                                  topLeft: Radius.circular(16),
                                                                  topRight: Radius.circular(16),
                                                                  bottomLeft: chats[idx].data()['sender'] == 'callerB'
                                                                      ? Radius.circular(0)
                                                                      : Radius.circular(16),
                                                                  bottomRight: chats[idx].data()['sender'] == 'callerB'
                                                                      ? Radius.circular(16)
                                                                      : Radius.circular(0),
                                                                )),
                                                            padding: EdgeInsets.all(16),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                if (await canLaunch(chats[idx].data()['message'].toString())) {
                                                                  await launch(chats[idx].data()['message'].toString());
                                                                }
                                                              },
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
                                                                          color:
                                                                              chats[idx].data()['sender'] == 'callerA' ? kBackground : kBlackColor),
                                                                      softWrap: true,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 2,
                                                          ),
                                                          // if (idx == 0)
                                                          Text(
                                                            f.format((chats[idx].data()['time'] as Timestamp).toDate()),
                                                            style: kPoppinsRegular400.copyWith(fontSize: 12, color: kBlackColor),
                                                          )
                                                        ],
                                                      ),
                                          );
                                        },
                                      );
                                    } else if (snapshot.data == null) {
                                      return Container();
                                    } else {
                                      return CupertinoActivityIndicator();
                                    }
                                  }),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(boxShadow: [kBoxShadow], color: kBackground),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          size: 20,
                                          color: kBlackColor,
                                        ),
                                        onPressed: () {
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
                                                              callController.fileUrl.value = '';
                                                              Get.back();
                                                              await callController.pickImage(ImageSource.camera);
                                                              // setState(() {});
                                                              if (callController.fileUrl.value != '') {
                                                                await calls.doc(callId).collection('chat').add({
                                                                  "message": callController.fileUrl.value,
                                                                  "type": "image",
                                                                  "time": DateTime.now(),
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
                                                              callController.fileUrl.value = '';
                                                              Get.back();
                                                              await callController.pickImage(ImageSource.gallery);
                                                              if (callController.fileUrl.value != '') {
                                                                await calls.doc(callId).collection('chat').add({
                                                                  "message": callController.fileUrl.value,
                                                                  "type": "image",
                                                                  "time": DateTime.now(),
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
                                                                  "time": DateTime.now(),
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
                                                .add({"message": message, "type": "text", "time": DateTime.now(), "sender": "callerA"});
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
                                                .add({"message": message, "type": "text", "time": DateTime.now(), "sender": "callerA"});
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
                        ],
                      ),
                    ),
                  ),
                ),
                body: SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: _fireStoreDataBase.collection('calls').doc(callId).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          // if (snapshot.connectionState == ConnectionState.waiting) {
                          //   return Text("Loading");
                          // }

                          if (snapshot.hasData) {
                            callerA = snapshot.data!['callerA'] == null ? false : snapshot.data!['callerA'] as bool;
                            callerB = snapshot.data!['callerB'] == null ? false : snapshot.data!['callerB'] as bool;
                            // if (snapshot.data!['callActive'] == false) {
                            //   // print('call hanged up');
                            //   // // setState(() {
                            //   // signaling.hangUp(callId, roomId ?? '', _localRenderer);
                            //   // Get.toNamed('/choose-payment');
                            //   // // });
                            // }
                            callScreenController.callerA.value = snapshot.data!['isCallerAShareScreen'] as bool;
                            callScreenController.callerB.value = snapshot.data!['isCallerBShareScreen'] as bool;
                          }
                          return callerA && callerB
                              ? isSharing
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
                                                        middleTextStyle:
                                                            kPoppinsRegular400.copyWith(fontSize: 13, color: kBlackColor.withOpacity(0.7)),
                                                        confirm: Transform(
                                                          transform: Matrix4.translationValues(-25.0, 0.0, 0.0),
                                                          child: CustomFlatButton(
                                                              width: MediaQuery.of(context).size.width * 0.29,
                                                              text: 'End Call',
                                                              onPressed: () async {
                                                                if (widget.callId == 'doctor') {
                                                                  closeCall();
                                                                  Get.toNamed('/doctor-success-screen',
                                                                      arguments: formatTime(_stopwatch.elapsedMilliseconds));
                                                                  // Get.back();
                                                                } else {
                                                                  var res = await controller.createAppointment({
                                                                    "doctor_id": konsultasiController.selectedDoctor.value,
                                                                    "patient_id": konsultasiController.selectedUid.value,
                                                                    "symptom_note": "",
                                                                    "consultation_method": konsultasiController.consultBy.value,
                                                                    "schedules": [konsultasiController.selectedDoctorTime.value.toJson2()],
                                                                  });

                                                                  // print("res => $res");

                                                                  if (res['status'] == true) {
                                                                    setState(() {
                                                                      closeCall();
                                                                    });
                                                                    Get.toNamed('/choose-payment', arguments: res['data']["appointment_id"]);
                                                                  }
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
                                                        "",
                                                        // 'Silvia GP Escort',
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
                                                      color: kRedError,
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
                                                  onTap: () {},
                                                  child: CircleAvatar(
                                                    backgroundColor: Color(0XFF5e5e5e),
                                                    radius: MediaQuery.of(context).size.width / 14,
                                                    child: Icon(
                                                      Icons.more_horiz,
                                                      color: kBackground,
                                                      size: MediaQuery.of(context).size.width / 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )
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
                                                                style: kPoppinsRegular400.copyWith(fontSize: 13, color: kBlackColor.withOpacity(0.7)),
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
                                                                  closeCall();
                                                                  Get.toNamed('/doctor-success-screen',
                                                                      arguments: formatTime(_stopwatch.elapsedMilliseconds));
                                                                  // Get.back();
                                                                } else {
                                                                  var res = await controller.createAppointment({
                                                                    "doctor_id": konsultasiController.selectedDoctor.value,
                                                                    "patient_id": konsultasiController.selectedUid.value,
                                                                    "symptom_note": "",
                                                                    "consultation_method": konsultasiController.consultBy.value,
                                                                    "schedules": [konsultasiController.selectedDoctorTime.value.toJson2()],
                                                                  });

                                                                  // print("res => $res");

                                                                  if (res['status'] == true) {
                                                                    setState(() {
                                                                      closeCall();
                                                                    });
                                                                    Get.toNamed('/choose-payment', arguments: res['data']["appointment_id"]);
                                                                  }
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
                                                child: _remoteRenderer.renderVideo
                                                    ? RTCVideoView(
                                                        _remoteRenderer,
                                                        objectFit: snapshot.data!['isCallerBShareScreen'] as bool
                                                            ? RTCVideoViewObjectFit.RTCVideoViewObjectFitContain
                                                            : RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
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
                                                        "",
                                                        // 'Silvia GP Escort',
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
                                                              color: kBackground.withOpacity(0.5),
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
                                                      middleTextStyle: kPoppinsRegular400.copyWith(fontSize: 13, color: kBlackColor.withOpacity(0.7)),
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
                                                      color: kBackground,
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
                                                  onTap: () {},
                                                  child: CircleAvatar(
                                                    backgroundColor: Color(0XFF5e5e5e),
                                                    radius: MediaQuery.of(context).size.width / 14,
                                                    child: Icon(
                                                      Icons.more_horiz,
                                                      color: kBackground,
                                                      size: MediaQuery.of(context).size.width / 14,
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
                                  : Container();
                        }),
                  ),
                ),
              ),
      ),
    );
  }
}
