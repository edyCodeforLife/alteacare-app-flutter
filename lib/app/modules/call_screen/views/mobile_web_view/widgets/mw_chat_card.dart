// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/call_screen/views/mobile_web_view/models/chat_message_model.dart';

class MWChatCard extends StatelessWidget {
  final ChatMessage message;
  const MWChatCard(this.message);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.sender == 'callerB' ? Alignment.centerLeft : Alignment.centerRight,
      child: message.type == 'text'
          ? Column(
              crossAxisAlignment: message.sender == 'callerB' ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: message.sender == 'callerB' ? kWhiteGray : kButtonColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: message.sender == 'callerB' ? const Radius.circular(0) : const Radius.circular(16),
                        bottomRight: message.sender == 'callerB' ? const Radius.circular(16) : const Radius.circular(0),
                      )),
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    message.message.toString(),
                    softWrap: true,
                    style: kPoppinsMedium500.copyWith(fontSize: 11, color: message.sender == 'callerB' ? kBlackColor : kBackground),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                // if (idx == 0)
                Text(
                  message.time,
                  style: kPoppinsRegular400.copyWith(fontSize: 12, color: kBlackColor),
                )
              ],
            )
          : message.type == 'image'
              ? Column(
                  crossAxisAlignment: message.sender == 'callerB' ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          message.message.toString(),
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
                              try {
                                final String fileName = message.message.split("/").last;
                                http.Response response = await http.get(Uri.parse(message.message));

                                if (response.statusCode == 200) {
                                  // ? below function is for download file in browser
                                  final rawData = base64Encode(response.bodyBytes);
                                  html.AnchorElement(href: "data:application/octet-stream;charset=utf-16le;base64,$rawData")
                                    ..setAttribute("download", fileName)
                                    ..click();
                                } else {
                                  // print("response error ->${response.statusCode}");
                                  // print("response error ->${response.reasonPhrase}");
                                }
                              } catch (e) {
                                // print("cathc error -> $e");
                              }

                              // if (await canLaunch(message.message)) {
                              //   launch(message.message);
                              // } else {}
                            },
                            child: Text(
                              'Download',
                              style: kPoppinsRegular400.copyWith(fontSize: 12, color: kDarkBlue),
                            ),
                          ),
                          Text(
                            message.time,
                            style: kPoppinsRegular400.copyWith(fontSize: 12, color: kBlackColor),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : Column(
                  crossAxisAlignment: message.sender == 'callerB' ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                          color: message.sender == 'callerB' ? kWhiteGray : kButtonColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: message.sender == 'callerB' ? Radius.circular(0) : Radius.circular(16),
                            bottomRight: message.sender == 'callerB' ? Radius.circular(16) : Radius.circular(0),
                          )),
                      padding: EdgeInsets.all(16),
                      child: InkWell(
                        onTap: () async {
                          // if (await canLaunch(message.message.toString())) {
                          // await launch(message.message.toString());

                          try {
                            final String fileName = message.message.split("/").last;
                            http.Response response = await http.get(Uri.parse(message.message));

                            if (response.statusCode == 200) {
                              // ? below function is for download file in browser
                              final rawData = base64Encode(response.bodyBytes);
                              html.AnchorElement(href: "data:application/octet-stream;charset=utf-16le;base64,$rawData")
                                ..setAttribute("download", fileName)
                                ..click();
                            } else {
                              // print("response error ->${response.statusCode}");
                              // print("response error ->${response.reasonPhrase}");
                            }
                          } catch (e) {
                            // print("cathc error -> $e");
                          }

                          // if (await canLaunch(message.message)) {
                          //   launch(message.message);
                          // } else {}
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
                                message.name,
                                style: kPoppinsMedium500.copyWith(fontSize: 14, color: message.sender == 'callerA' ? kBackground : kBlackColor),
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
                      message.time,
                      style: kPoppinsRegular400.copyWith(fontSize: 12, color: kBlackColor),
                    )
                  ],
                ),
    );
  }
}
