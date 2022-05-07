// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/call_screen/controllers/call_screen_controller.dart';
import 'package:altea/app/modules/call_screen/views/mobile_web_view/models/chat_message_model.dart';
import 'package:altea/app/modules/call_screen/views/mobile_web_view/widgets/mw_chat_card.dart';

class MobileWebChatScreen extends StatefulWidget {
  final String? callId;
  MobileWebChatScreen({required this.callId});

  @override
  _MobileWebChatScreenState createState() => _MobileWebChatScreenState();
}

class _MobileWebChatScreenState extends State<MobileWebChatScreen> {
  CollectionReference calls = FirebaseFirestore.instance.collection('calls');
  TextEditingController chatBoxCtrl = TextEditingController();
  ScrollController scrollCtrl = ScrollController();
  final CallScreenController callController = Get.find<CallScreenController>();
  final dateFormat = DateFormat('hh:mm');

  String message = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom == 0
              ? MediaQuery.of(context).size.height * 0.95
              : MediaQuery.of(context).size.height - (MediaQuery.of(context).viewInsets.bottom + 50),
          child: Column(
            children: [
              // CHAT SECTION
              Expanded(
                // bottom: 60,
                child: StreamBuilder<QuerySnapshot>(
                    stream: calls.doc(widget.callId).collection('chat').orderBy('time').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List chats = snapshot.data!.docs;
                        return ListView.builder(
                          controller: scrollCtrl,
                          // physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: chats.length,
                          itemBuilder: (context, idx) {
                            // print("$idx - ${chats.length}");

                            if ((idx + 1) == chats.length) {
                              // scrollCtrl.jumpTo(scrollCtrl.position.maxScrollExtent);
                              // print("$idx - ${chats.length}");
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
                              time: dateFormat.format((chats[idx].data()['time'] as Timestamp).toDate()).toString(),
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
              Container(
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
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      child: Container(
                                        margin: const EdgeInsets.all(16),
                                        width: MediaQuery.of(context).size.width * 0.6,
                                        decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(16)),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
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
                                                  await calls.doc(widget.callId).collection('chat').add({
                                                    "message": callController.fileUrl.value,
                                                    "type": "image",
                                                    "time": DateTime.now(),
                                                    "sender": "callerA"
                                                  });
                                                  final DocumentSnapshot notif = await calls.doc(widget.callId).get();
                                                  await calls
                                                      .doc(widget.callId)
                                                      .update({"chatBCount": ((notif.data()! as Map)['chatBCount'] as int) + 1});
                                                }
                                              },
                                              child: Container(
                                                  margin: const EdgeInsets.all(8),
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
                                                  await calls.doc(widget.callId).collection('chat').add({
                                                    "message": callController.fileUrl.value,
                                                    "type": "image",
                                                    "time": DateTime.now(),
                                                    "sender": "callerA"
                                                  });
                                                  final DocumentSnapshot notif = await calls.doc(widget.callId).get();
                                                  await calls
                                                      .doc(widget.callId)
                                                      .update({"chatBCount": ((notif.data()! as Map)['chatBCount'] as int) + 1});
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
                                                  await calls.doc(widget.callId).collection('chat').add({
                                                    "name": callController.fileName.value,
                                                    "message": callController.fileUrl.value,
                                                    "type": "file",
                                                    "time": DateTime.now(),
                                                    "sender": "callerA"
                                                  });
                                                  final DocumentSnapshot notif = await calls.doc(widget.callId).get();
                                                  await calls
                                                      .doc(widget.callId)
                                                      .update({"chatBCount": ((notif.data()! as Map)['chatBCount'] as int) + 1});
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
                          // onTap: () {
                          //   Timer(const Duration(milliseconds: 300),
                          //       () => scrollCtrl.jumpTo(scrollCtrl.position.maxScrollExtent));
                          // },
                          controller: chatBoxCtrl,
                          onChanged: (val) {
                            message = val;
                          },
                          onSubmitted: (s) async {
                            message = s;
                            // print("$message di enter ");
                            if (message != '' || message != ' ') {
                              await calls
                                  .doc(widget.callId)
                                  .collection('chat')
                                  .add({"message": message, "type": "text", "time": DateTime.now(), "sender": "callerA"});
                              final DocumentSnapshot notif = await calls.doc(widget.callId).get();
                              await calls.doc(widget.callId).update({"chatBCount": ((notif.data()! as Map)['chatBCount'] as int) + 1});
                              chatBoxCtrl.clear();
                            }
                            scrollCtrl.jumpTo(scrollCtrl.position.maxScrollExtent + 70);
                          },
                          decoration: InputDecoration(
                              hintText: 'Add text to this message',
                              hintStyle: kPoppinsRegular400.copyWith(fontSize: 13, color: kBlackColor),
                              border: const OutlineInputBorder(borderSide: BorderSide.none)),
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
                          if (message != '' || message != ' ') {
                            await calls.doc(widget.callId).collection('chat').add(
                              {"message": message, "type": "text", "time": DateTime.now(), "sender": "callerA"},
                            );
                            final DocumentSnapshot notif = await calls.doc(widget.callId).get();
                            await calls.doc(widget.callId).update({"chatBCount": ((notif.data()! as Map)['chatBCount'] as int) + 1});
                            chatBoxCtrl.clear();
                          }
                          scrollCtrl.jumpTo(scrollCtrl.position.maxScrollExtent + 70);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
