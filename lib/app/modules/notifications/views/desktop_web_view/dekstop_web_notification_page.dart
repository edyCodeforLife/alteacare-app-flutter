// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/footer_section_view.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import 'package:altea/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:altea/app/modules/notifications/views/desktop_web_view/desktop_web_notification_card.dart';

class DesktopWebNotificationPage extends StatefulWidget {
  const DesktopWebNotificationPage({Key? key}) : super(key: key);

  @override
  _DesktopWebNotificationPageState createState() => _DesktopWebNotificationPageState();
}

class _DesktopWebNotificationPageState extends State<DesktopWebNotificationPage> with SingleTickerProviderStateMixin {
  // late TabController tabController; <-- sudah pakai tab controller dari homeController
  final homeController = Get.find<HomeController>();
  final NotificationsController _notificationsController = Get.find<NotificationsController>();

  @override
  void initState() {
    super.initState();

    // buat notif
    // tabController = TabController(
    //     vsync: this, length: homeController.notificationTabMenu.length);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final screenHeight = context.height;
    return Scaffold(
      backgroundColor: kBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopNavigationBarSection(
              screenWidth: screenWidth,
            ),
            SizedBox(
              height: screenWidth * 0.04,
            ),
            SizedBox(
              height: screenWidth * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: Text(
                      "Notifikasi",
                      style: kPoppinsMedium500.copyWith(fontSize: 24, color: kBlackColor),
                    ),
                  ),
                  const SizedBox(
                    height: 33,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: Column(
                      children: [
                        DefaultTabController(
                          length: homeController.notificationTabMenu.length,
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(color: kBackground),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TabBar(
                                          // controller: tabController, <-- sudah diselimuti default tab controller
                                          labelColor: kDarkBlue,
                                          labelPadding: EdgeInsets.zero,
                                          unselectedLabelColor: kSubHeaderColor.withOpacity(0.5),
                                          indicatorColor: kDarkBlue,
                                          labelStyle: kPoppinsMedium500,
                                          tabs: List.generate(
                                              homeController.notificationTabMenu.length,
                                              (index) => Tab(
                                                    text: homeController.notificationTabMenu[index],
                                                  ))),
                                    ),
                                    const Spacer()
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: screenWidth * 0.5,
                                child: TabBarView(
                                  children: [
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
                                          : SingleChildScrollView(
                                              child: Column(
                                                children: _notificationsController.notifications
                                                    .map(
                                                      (e) => DesktopWebNotificationCard(
                                                        notification: e,
                                                        screenWidth: screenWidth,
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                    ),
                                    Obx(
                                      () => (_notificationsController.notifications.where((nm) => nm.type.toLowerCase().contains('payment')).isEmpty)
                                          ? Center(
                                              child: Text(
                                                "Belum ada notifikasi",
                                                style: kPoppinsMedium500.copyWith(
                                                  fontSize: 12,
                                                  color: kBlackColor,
                                                ),
                                              ),
                                            )
                                          : Column(
                                              children: _notificationsController.notifications
                                                  .where((nm) => nm.type.toLowerCase().contains('payment'))
                                                  .map(
                                                    (e) => DesktopWebNotificationCard(
                                                      notification: e,
                                                      screenWidth: screenWidth,
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                    ),
                                    Column(
                                      children: [
                                        ...List.generate(4, (index) => notificationCard()),
                                      ],
                                    ),
                                    Center(
                                      child: Text(
                                        "Belum ada notifikasi",
                                        style: kPoppinsMedium500.copyWith(
                                          fontSize: 12,
                                          color: kBlackColor,
                                        ),
                                      ),
                                    ),
                                    // Column(
                                    //   children: [
                                    //     ...List.generate(4, (index) => notificationCard()),
                                    //   ],
                                    // )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: screenWidth * 0.01,
            ),
            FooterSectionWidget(screenWidth: screenWidth)
          ],
        ),
      ),
    );
  }

  Widget notificationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(color: kLightGray.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: Image.asset(
                "assets/no_file_upload_icon.png",
                color: kDarkBlue,
                height: 30,
                width: 30,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hari ini 09.30",
                style: kPoppinsRegular400.copyWith(color: bannerUploadTextColor, fontSize: 8),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Memo Altea Diterima",
                style: kPoppinsMedium500.copyWith(color: fullBlack, fontSize: 12),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Order ID No. 66870080 telah menerima Memo Altea. Memo ini merupakan memo dummy.",
                style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 9),
              ),
            ],
          )
        ],
      ),
    );
  }
}
