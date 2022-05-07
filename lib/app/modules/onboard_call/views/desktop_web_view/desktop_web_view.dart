// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/add_patient/controllers/add_patient_controller.dart';
import 'package:altea/app/modules/call_screen/controllers/call_screen_controller.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/footer_section_view.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import 'package:altea/app/modules/onboard_call/controllers/onboard_call_controller.dart';
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
import 'package:altea/app/modules/register/presentation/modules/register/controllers/register_controller.dart';
import 'package:altea/app/routes/app_pages.dart';

class DesktopWebOnboardCallPage extends GetView<OnboardCallController> {
  DesktopWebOnboardCallPage({Key? key, required this.orderIdFromParam}) : super(key: key);
  final String orderIdFromParam;

  final OnboardCallController onboardCallController = Get.find<OnboardCallController>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final CallScreenController callScreenController = Get.put(CallScreenController(orderIdFromParam: orderIdFromParam));
    final patientDataController = Get.find<PatientDataController>();

    return Scaffold(
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
                Column(
                  children: [
                    Center(
                      child: Container(
                        width: 60,
                        height: 60,
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
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.4),
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
                                      // Get.toNamed(Routes.ONBOARD_END_CALL);
                                      await onboardCallController.setSelectedPatientDataFromOrderId(orderIdFromParam);
                                      callScreenController.callId.value = "new";
                                      callScreenController.initCallDoctor.value = false;
                                      if (patientDataController.selectedPatientData.value.firstName.toString() == "null") {}
                                      final String name = (patientDataController.selectedPatientData.value.firstName.toString() == "null")
                                          ? onboardCallController.patientName
                                          : "${patientDataController.selectedPatientData.value.firstName} ${patientDataController.selectedPatientData.value.lastName}";

                                      if (GetPlatform.isMobile) {
                                        Get.toNamed("${Routes.CALL_SCREEN_MOBILE}?orderId=$orderIdFromParam", arguments: {
                                          "patientName": name,
                                          "callType": "callma" // desktop use this to handle which call MA/doctor
                                        });
                                      } else {
                                        Get.toNamed("${Routes.CALL_SCREEN_DESKTOP}?orderId=$orderIdFromParam", arguments: {
                                          "patientName": name,
                                          "callType": "callma" // desktop use this to handle which call MA/doctor
                                        });
                                      }

                                      Get.delete<PatientDataController>();
                                      Get.delete<AddPatientController>();
                                      Get.delete<RegisterController>();
                                    },
                                    color: kButtonColor,
                                  ),
                          ),
                          // const SizedBox(
                          //   height: 8,
                          // ),
                          // CustomFlatButton(
                          //     borderColor: kButtonColor,
                          //     width: screenWidth,
                          //     text: "Cancel",
                          //     onPressed: () {},
                          //     color: kBackground),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 58,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                FooterSectionWidget(screenWidth: screenWidth)
              ],
            ),
          )
        ],
      ),
    );
  }
}
