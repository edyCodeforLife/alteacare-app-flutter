// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import 'package:altea/app/modules/my_consultation/controllers/my_consultation_controller.dart';
import 'package:altea/app/modules/my_consultation_detail/controllers/my_consultation_detail_controller.dart';
import 'package:altea/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:altea/app/modules/notifications/views/desktop_web_view/desktop_web_notification_card.dart';
import 'package:altea/app/modules/notifications/views/mobile_web_view/widgets/mobile_web_notification_card.dart';
import '../../../../routes/app_pages.dart';

class MWNotificationScreen extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  final NotificationsController _notificationsController = Get.find<NotificationsController>();
  // final MyConsultationController _myConsultationController = Get.put(MyConsultationController());
  // final MyConsultationDetailController _myConsultationDetailController = Get.put<MyConsultationDetailController>(MyConsultationDetailController());
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final screenHeight = context.height;
    return Scaffold(
      key: scaffoldKey,
      drawer: MobileWebHamburgerMenu(),
      appBar: MobileWebMainAppbar(
        scaffoldKey: scaffoldKey,
      ),
      backgroundColor: kBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20),
        child: FutureBuilder(
          future: _notificationsController.getNotifWeb(),
          builder: (c, d) {
            return Column(
              children: [
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 15),
                        child: Text(
                          "Notifikasi",
                          style: kPoppinsSemibold600.copyWith(fontSize: 16, color: kBlackColor),
                        ),
                      ),
                      Column(
                        children: [
                          DefaultTabController(
                            length: homeController.notificationTabMenu.length,
                            child: Column(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(color: kBackground),
                                  child: TabBar(
                                      isScrollable: true,
                                      // controller: tabController, <-- sudah diselimuti default tab controller
                                      labelColor: kDarkBlue,
                                      labelPadding: EdgeInsets.zero,
                                      unselectedLabelColor: kSubHeaderColor.withOpacity(0.5),
                                      indicatorColor: kDarkBlue,
                                      // labelStyle: kPoppinsMedium500,
                                      tabs: List.generate(
                                          homeController.notificationTabMenu.length,
                                          (index) => Tab(
                                                child: Container(
                                                  alignment: Alignment.centerLeft,
                                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                                  child: Text(
                                                    homeController.notificationTabMenu[index],
                                                    style: kPoppinsMedium500.copyWith(fontSize: 10),
                                                  ),
                                                ),
                                              ))),
                                ),
                                SizedBox(
                                  height: screenHeight,
                                  child: TabBarView(
                                    children: [
                                      //semuanya
                                      Obx(
                                        () => (_notificationsController.notifications.isEmpty)
                                            ? Center(
                                                child: Text(
                                                  "Belum ada notifikasi",
                                                  style: kPoppinsMedium500.copyWith(
                                                    fontSize: 12,
                                                    color: kBlackColor,
                                                  ),
                                                ),
                                              )
                                            : ListView.separated(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemBuilder: (c, i) {
                                                  return InkWell(
                                                    onTap: () {
                                                      if (_notificationsController.notifications[i].orderId != null) {
                                                        // _myConsultationController.getDataConsultationWeb("on-going");
                                                        // _myConsultationDetailController.orderId.value = _notificationsController.notifications[i].orderId!;
                                                        // Get.toNamed(Routes.MY_CONSULTATION_DETAIL);
                                                      } else {
                                                        Fluttertoast.showToast(msg: "nda ada order ID di statusnya");
                                                      }
                                                    },
                                                    child: MWNotificationCard(
                                                      notification: _notificationsController.notifications[i],
                                                      screenWidth: screenWidth,
                                                    ),
                                                  );
                                                },
                                                separatorBuilder: (c, i) {
                                                  return const Divider(
                                                    color: Colors.grey,
                                                  );
                                                },
                                                itemCount: _notificationsController.notifications.length,
                                              ),
                                      ),

                                      //pembayaran
                                      Obx(
                                        () =>
                                            (_notificationsController.notifications.where((nm) => nm.type.toLowerCase().contains('payment')).isEmpty)
                                                ? Center(
                                                    child: Text(
                                                      "Belum ada notifikasi",
                                                      style: kPoppinsMedium500.copyWith(
                                                        fontSize: 12,
                                                        color: kBlackColor,
                                                      ),
                                                    ),
                                                  )
                                                : ListView.separated(
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemBuilder: (c, i) {
                                                      return MWNotificationCard(
                                                        notification: _notificationsController.notifications
                                                            .where((nm) => nm.type.toLowerCase().contains('payment'))
                                                            .elementAt(i),
                                                        screenWidth: screenWidth,
                                                      );
                                                    },
                                                    separatorBuilder: (c, i) {
                                                      return const Divider(
                                                        color: Colors.grey,
                                                      );
                                                    },
                                                    itemCount: _notificationsController.notifications
                                                        .where((nm) => nm.type.toLowerCase().contains('payment'))
                                                        .length,
                                                  ),
                                      ),

                                      //memo altea
                                      Obx(
                                        () => (_notificationsController.notifications.where((nm) => nm.type.toLowerCase().contains('memo')).isEmpty)
                                            ? Center(
                                                child: Text(
                                                  "Belum ada notifikasi",
                                                  style: kPoppinsMedium500.copyWith(
                                                    fontSize: 12,
                                                    color: kBlackColor,
                                                  ),
                                                ),
                                              )
                                            : ListView.separated(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemBuilder: (c, i) {
                                                  return MWNotificationCard(
                                                    notification: _notificationsController.notifications
                                                        .where((nm) => nm.type.toLowerCase().contains('memo'))
                                                        .elementAt(i),
                                                    screenWidth: screenWidth,
                                                  );
                                                },
                                                separatorBuilder: (c, i) {
                                                  return const Divider(
                                                    color: Colors.grey,
                                                  );
                                                },
                                                itemCount: _notificationsController.notifications
                                                    .where((nm) => nm.type.toLowerCase().contains('memo'))
                                                    .length,
                                              ),
                                      ),

                                      //dokumen medis
                                      Obx(
                                        () =>
                                            (_notificationsController.notifications.where((nm) => nm.type.toLowerCase().contains('document')).isEmpty)
                                                ? Center(
                                                    child: Text(
                                                      "Belum ada notifikasi",
                                                      style: kPoppinsMedium500.copyWith(
                                                        fontSize: 12,
                                                        color: kBlackColor,
                                                      ),
                                                    ),
                                                  )
                                                : ListView.separated(
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemBuilder: (c, i) {
                                                      return MWNotificationCard(
                                                        notification: _notificationsController.notifications
                                                            .where((nm) => nm.type.toLowerCase().contains('document'))
                                                            .elementAt(i),
                                                        screenWidth: screenWidth,
                                                      );
                                                    },
                                                    separatorBuilder: (c, i) {
                                                      return const Divider(
                                                        color: Colors.grey,
                                                      );
                                                    },
                                                    itemCount: _notificationsController.notifications
                                                        .where((nm) => nm.type.toLowerCase().contains('document'))
                                                        .length,
                                                  ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
