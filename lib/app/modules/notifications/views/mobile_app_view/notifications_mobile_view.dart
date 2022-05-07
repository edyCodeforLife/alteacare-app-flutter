import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsMobileView extends StatefulWidget {
  @override
  _NotificationsMobileViewState createState() => _NotificationsMobileViewState();
}

class _NotificationsMobileViewState extends State<NotificationsMobileView> with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<String> tabs = ['Semua', 'Pembayaran', 'Memo Altea', 'Dokumen Medis'];

  NotificationsController controller = Get.put(NotificationsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        elevation: 3,
        title: Text(
          'Notification',
          style: kAppBarTitleStyle,
        ),
        centerTitle: true,
        backgroundColor: kBackground,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: kBlackColor,
          ),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            isScrollable: true,
            onTap: (idx) {
              setState(() {
                tabController.index = idx;
                // if (idx == 1) {
                //   if (widget.data['symptom_note'] != null) {
                //     tabController.index = idx;
                //   } else {
                //     tabController.index = tabController.previousIndex;
                //   }
                // } else if (idx == 2) {
                //   if ((widget.data['medical_document'] as List).isNotEmpty) {
                //     tabController.index = idx;
                //   } else {
                //     tabController.index = tabController.previousIndex;
                //   }
                // } else {
                //   tabController.index = idx;
                // }
              });
            },
            controller: tabController,
            tabs: [
              for (int index = 0; index < tabs.length; index++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 16),
                  child: AutoSizeText(
                    tabs[index],
                    style: tabController.index == index
                        ? kPoppinsMedium500.copyWith(color: kDarkBlue, fontSize: 10)
                        : kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 10),
                    maxLines: 1,
                    minFontSize: 10,
                  ),
                )
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: FutureBuilder(
                future: controller.getNotif(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List notifList = (snapshot.data as Map<String, dynamic>)['data'] as List;
                    // print('snapshot data notif => ${snapshot.data}');
                    return ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, idx) => Container(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          margin: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(color: kWhiteGray, borderRadius: BorderRadius.circular(16)),
                                child: Image.asset('assets/memo.png'),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Hari ini, 09.30', style: kPoppinsRegular400.copyWith(fontSize: 8, color: kBlackColor.withOpacity(0.6))),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      notifList[idx]['title'].toString(),
                                      style: kPoppinsMedium500.copyWith(fontSize: 11, color: Colors.black),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.6,

                                    child: Text(notifList[idx]['message'].toString(),
                                        style: kPoppinsRegular400.copyWith(color: kBlackColor.withOpacity(0.6), fontSize: 9)),
                                    // RichText(
                                    //     softWrap: true,
                                    //     text: TextSpan(children: [
                                    //       TextSpan(
                                    //           text: 'Memo Altea no. Konsultasi ',
                                    //           style: kPoppinsRegular400.copyWith(
                                    //               color: kBlackColor
                                    //                   .withOpacity(0.6),
                                    //               fontSize: 9)),
                                    //       TextSpan(
                                    //           text: '66870080',
                                    //           style: kPoppinsSemibold600.copyWith(
                                    //               fontSize: 9, color: kDarkBlue)),
                                    //       TextSpan(
                                    //           text:
                                    //               ' telah siap. Klik di sini untuk melihat memo Altea anda.',
                                    //           style: kPoppinsRegular400.copyWith(
                                    //               color: kBlackColor
                                    //                   .withOpacity(0.6),
                                    //               fontSize: 9))
                                    //     ])),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      itemCount: notifList.length,
                    );
                  } else {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
