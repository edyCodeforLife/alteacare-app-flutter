// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/screen_size.dart';
import 'package:altea/app/modules/article/views/widgets/new_article_container.dart';
import 'package:altea/app/modules/doctor/controllers/doctor_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/altea_loyalty_section_desktop.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/footer_section_view.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/main_banner_doctor_spesialis_section_desktop.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/promo_section_desktop.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

class DesktopView extends GetView<HomeController> {
  DesktopView({
    Key? key,
    required this.screenWidth,
    required this.spesialisMenus,
    required this.floatingMenus,
  }) : super(key: key);

  final double screenWidth;
  final List<Map<String, dynamic>> spesialisMenus;
  final List<Map<String, dynamic>> floatingMenus;

  final DoctorController doctorController = Get.put(DoctorController());
  @override
  Widget build(BuildContext context) {
    ScreenSize.recalculate(context);
    return Obx(() => GestureDetector(
          onTap: () {
            controller.showNotificationContainer.value = false;
          },
          child: Scaffold(
            backgroundColor: kTextFieldColor,
            body: controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Scrollbar(
                    isAlwaysShown: true,
                    showTrackOnHover: true,
                    child: ListView(
                      children: [
                        Stack(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 5.hb,
                                ),
                                MainBannerAndDoctorSectionWidget(floatingMenus: floatingMenus),
                                const PromoSectionWidget(),
                                SizedBox(
                                  height: 10.hb,
                                ),
                                const AlteaLoyaltySectionWidget(),
                                NewArticleContainer(),
                                FooterSectionWidget(screenWidth: screenWidth)
                              ],
                            ),
                            TopNavigationBarSection(
                              screenWidth: screenWidth,
                            ),
                            // if (controller.showNotificationContainer.value) ...[
                            //   Positioned(
                            //       right: screenWidth * 0.1,
                            //       top: screenWidth * 0.05,
                            //       child: NotificationContainer())
                            // ],
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ));
  }
}
