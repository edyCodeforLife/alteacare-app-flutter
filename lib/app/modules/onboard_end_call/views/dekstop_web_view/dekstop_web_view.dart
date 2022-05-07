// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/call_screen/controllers/call_screen_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/footer_section_view.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import 'package:altea/app/modules/onboard_end_call/controllers/onboard_end_call_controller.dart';
import 'package:altea/app/routes/app_pages.dart';

class DesktopWebOnboardEndCallPage extends StatelessWidget {
  DesktopWebOnboardEndCallPage({required this.orderId});

  final String orderId;
  final controller = Get.find<OnboardEndCallController>();
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    Get.delete<CallScreenController>();

    return Scaffold(
      backgroundColor: kBackground,
      body: Column(
        children: [
          TopNavigationBarSection(
            screenWidth: screenWidth,
          ),
          Expanded(
            child: ListView(
              children: [
                const SizedBox(
                  height: 24,
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset(
                          "assets/vidcall_icon.png",
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.4),
                  child: Column(
                    children: [
                      Text(
                        "Panggilan Berakhir:",
                        style: kPoppinsRegular400.copyWith(color: kTextHintColor, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        homeController.totalDurationCall.value,
                        style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 25),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Konfirmasi rencana telekonsultasi Anda telah selesai.\nDimohon untuk menyelesaikan pembayaran Anda\npaling lambat 1 jam sebelum konsultasi dimulai.",
                        style: kPoppinsRegular400.copyWith(fontSize: 11, color: kTextHintColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 58,
                      ),
                      Obx(
                        () => (controller.state == OnboardEndCallState.loading)
                            ? const Center(
                                child: Text("Mohon tunggu . . ."),
                              )
                            : (controller.isMyConsultationOk)
                                ? CustomFlatButton(
                                    width: screenWidth,
                                    text: "Pembayaran",
                                    onPressed: () {
                                      Get.toNamed(
                                        "${Routes.CHOOSE_PAYMENT}?orderId=$orderId",
                                        arguments: orderId,
                                      );

                                      // Get.offNamed(Routes.CHOOSE_PAYMENT);
                                    },
                                    color: kButtonColor,
                                  )
                                : CustomFlatButton(
                                    width: screenWidth,
                                    text: "Kembali ke Beranda",
                                    onPressed: () {
                                      Get.toNamed(
                                        "/home",
                                      );

                                      // Get.offNamed(Routes.CHOOSE_PAYMENT);
                                    },
                                    borderColor: kButtonColor,
                                    color: Colors.white,
                                  ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                FooterSectionWidget(screenWidth: screenWidth)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
