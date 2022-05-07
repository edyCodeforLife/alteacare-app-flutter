// Dart imports:
import 'dart:async';
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/call_screen/controllers/call_screen_controller.dart';
import 'package:altea/app/modules/call_screen/views/mobile_web_view/models/chat_message_model.dart';
import 'package:altea/app/modules/call_screen/views/mobile_web_view/widgets/mw_chat_card.dart';

class MWChatScreen02 extends StatefulWidget {
  final String? callId;
  MWChatScreen02({required this.callId});

  @override
  _MWChatScreen02State createState() => _MWChatScreen02State();
}

class _MWChatScreen02State extends State<MWChatScreen02> {
  CollectionReference calls = FirebaseFirestore.instance.collection('calls');
  TextEditingController chatBoxCtrl = TextEditingController();
  ScrollController scrollCtrl = ScrollController();
  final CallScreenController callController = Get.find<CallScreenController>();
  final dateFormat = DateFormat('hh:mm');
  UploadTask? task;

  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        color: Colors.yellow,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text("WEKJWEIJAIWEJIAJWEIAJWIEJAIWJE"),
      ),
      appBar: AppBar(
        backgroundColor: kBackground,
        iconTheme: const IconThemeData(color: kBlackColor),
        title: const Text(
          "Chat",
          style: TextStyle(color: kBlackColor),
        ),
      ),
      body: SizedBox(
        height: Get.height,
        child: Column(
          children: [
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
                      stream: calls.doc(widget.callId).collection('chat').orderBy('time').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List chats = snapshot.data!.docs;
                          return ListView.builder(
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
              ),
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
                        onPressed: () async {
                          await pickFile();
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
                            message = "";
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
                          message = "";
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
      ),
    );
  }

  Future pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    PlatformFile? objFile;

    if (result != null) {
      // print('result => ${result.files.first.path}');

      final Uint8List fileBytes = result.files.first.bytes!;
      objFile = result.files.single;

      final resultResponse = await uploadFile(fileBytes: fileBytes, objFile: objFile);
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

    task = callController.uploadBytes(destination, fileBytes);
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
          .add({"message": urlFileChat, "type": "image", "time": DateTime.now(), "sender": "callerA", "name": objFile.name});
      final DocumentSnapshot notif = await calls.doc(widget.callId).get();
      await calls.doc(widget.callId).update({"chatBCount": ((notif.data()! as Map)['chatBCount'] as int) + 1});
    } else {
      await calls
          .doc(widget.callId)
          .collection('chat')
          .add({"message": urlFileChat, "type": "file", "time": DateTime.now(), "sender": "callerA", "name": objFile.name});

      final DocumentSnapshot notif = await calls.doc(widget.callId).get();
      await calls.doc(widget.callId).update({"chatBCount": ((notif.data()! as Map)['chatBCount'] as int) + 1});
    }
  }
}
