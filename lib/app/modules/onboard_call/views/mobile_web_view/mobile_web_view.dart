// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/call_screen/controllers/call_screen_controller.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import 'package:altea/app/modules/onboard_call/controllers/onboard_call_controller.dart';
import 'package:altea/app/modules/patient_confirmation/controllers/patient_confirmation_controller.dart';
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
import 'package:altea/app/routes/app_pages.dart';

class MobileWebOnboardCallPage extends GetView<OnboardCallController> {
  const MobileWebOnboardCallPage({Key? key, required this.orderIdFromParam}) : super(key: key);
  final String orderIdFromParam;

  @override
  Widget build(BuildContext context) {
    final CallScreenController callScreenController = Get.put(CallScreenController(orderIdFromParam: orderIdFromParam));
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final PatientConfirmationController patientConfirmationController = Get.find<PatientConfirmationController>();
    final OnboardCallController onboardCallController = Get.find<OnboardCallController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final patientDataController = Get.find<PatientDataController>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kBackground,
      appBar: MobileWebMainAppbar(
        scaffoldKey: scaffoldKey,
      ),
      drawer: MobileWebHamburgerMenu(),
      body: ListView(
        children: [
          const SizedBox(
            height: 60,
          ),
          Center(
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: kButtonColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Image.asset("assets/vidcall_icon.png"),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 31,
                ),
                Text(
                  "Layanan Medical Advisor GRATIS",
                  style: kPoppinsMedium500.copyWith(fontSize: 17, color: kBlackColor),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  "Anda akan terhubung dengan Medical Advisor AlteaCare untuk verifikasi identitas. Dimohon Menyiapkan:",
                  style: kPoppinsMedium500.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.5)),
                ),
                const SizedBox(
                  height: 31,
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: kButtonColor),
                    ),
                    const SizedBox(
                      width: 9,
                    ),
                    Text(
                      "Siapkan KTP",
                      style: kPoppinsMedium500.copyWith(fontSize: 12, color: kButtonColor),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: kButtonColor),
                    ),
                    const SizedBox(
                      width: 9,
                    ),
                    Text(
                      "Laporan hasil pemeriksaan penunjang \n(laboratorium, radiologi, dll) yang berkaitan \ndengan keluhan Anda saat ini.",
                      style: kPoppinsMedium500.copyWith(fontSize: 12, color: kButtonColor),
                    )
                  ],
                ),
                const SizedBox(
                  height: 76,
                ),
                Obx(
                  () => (onboardCallController.state == OnboardCallState.loading)
                      ? const Text("Harap tunggu . . .")
                      : CustomFlatButton(
                          width: screenWidth,
                          text: "Start Video Call",
                          onPressed: () async {
                            await onboardCallController.setSelectedPatientDataFromOrderId(orderIdFromParam);
                            callScreenController.callId.value = "new";
                            callScreenController.initCallDoctor.value = false;
                            final String name = (patientDataController.selectedPatientData.value.firstName.toString() == "null")
                                ? onboardCallController.patientName
                                : "${patientDataController.selectedPatientData.value.firstName} ${patientDataController.selectedPatientData.value.lastName}";

                            if (GetPlatform.isDesktop) {
                              // print("Masuk Desktop Web nih");
                              Get.toNamed("${Routes.CALL_SCREEN_DESKTOP}?orderId=$orderIdFromParam", arguments: {
                                "patientName": name,
                                "callType": "callma" // desktop use this to handle which call MA/doctor
                              });
                            } else {
                              // print("Masuk Mobile Web nih");

                              Get.toNamed("${Routes.CALL_SCREEN_MOBILE}?orderId=$orderIdFromParam", arguments: {
                                "patientName": name,
                                "callType": "callma" // desktop use this to handle which call MA/doctor
                              });
                            }
                          },
                          color: kButtonColor,
                        ),
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomFlatButton(
                    borderColor: kButtonColor,
                    width: screenWidth,
                    text: "Cancel",
                    onPressed: () {
                      Get.back();
                    },
                    color: kBackground),
                const SizedBox(
                  height: 28,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
