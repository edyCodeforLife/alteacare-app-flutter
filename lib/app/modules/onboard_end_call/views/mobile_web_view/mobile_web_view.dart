// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import 'package:altea/app/modules/onboard_end_call/controllers/onboard_end_call_controller.dart';
import 'package:altea/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

class MobileWebOnboardEndCallPage extends StatelessWidget {
  MobileWebOnboardEndCallPage({required this.orderId});
  final homeController = Get.find<HomeController>();
  final controller = Get.find<OnboardEndCallController>();

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        Future.delayed(Duration.zero, () {
          Get.offNamedUntil("/home", (route) => false);
        });
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: kBackground,
        appBar: MobileWebMainAppbar(scaffoldKey: scaffoldKey),
        drawer: MobileWebHamburgerMenu(),
        body: ListView(
          children: [
            const SizedBox(
              height: 60,
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                    width: 90,
                    height: 90,
                    child: Image.asset(
                      "assets/vidcall_icon.png",
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Column(
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
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Text(
                "Konfirmasi rencana telekonsultasi Anda telah selesai.\nDimohon untuk menyelesaikan pembayaran Anda\npaling lambat 1 jam sebelum konsultasi dimulai.",
                style: kPoppinsRegular400.copyWith(fontSize: 11, color: kTextHintColor),
              ),
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
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            //   child: CustomFlatButton(
            //       width: screenWidth,
            //       text: "Pembayaran",
            //       onPressed: () {
            //         Get.toNamed(
            //           "${Routes.CHOOSE_PAYMENT}?orderId=${onboardCallController.orderIdFromParam}",
            //           arguments: onboardCallController.orderIdFromParam,
            //         );
            //       },
            //       color: kButtonColor),
            // ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
