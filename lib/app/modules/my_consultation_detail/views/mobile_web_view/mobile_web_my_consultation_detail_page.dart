// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:altea/app/core/utils/settings.dart' as setting;
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/data/model/patient_data_model.dart';
import 'package:altea/app/modules/call_screen/controllers/call_screen_controller.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import 'package:altea/app/modules/my_consultation_detail/views/mobile_web_view/widgetbaru/mw_consultation_detail_header.dart';
import 'package:altea/app/modules/my_consultation_detail/views/mobile_web_view/widgetbaru/my_consultation_detail_content_02.dart';
import 'package:altea/app/modules/my_consultation_detail/views/mobile_web_view/widgets/mw_consultation_detail_cancelled_content.dart';
import 'package:altea/app/modules/my_consultation_detail/views/mobile_web_view/widgets/mw_consultation_detail_wait_payment_content.dart';
import 'package:altea/app/modules/patient_confirmation/controllers/patient_confirmation_controller.dart';
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import '../../../../core/utils/colors.dart';
import '../../../home/controllers/home_controller.dart';
import '../../controllers/my_consultation_detail_controller.dart';

class MobileWebMyConsultationDetailPage extends GetView<MyConsultationDetailController> {
  MobileWebMyConsultationDetailPage({required this.orderIdFromParam});

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final PatientConfirmationController patientConfirmationController = Get.put(PatientConfirmationController());
  final PatientDataController patientDataController = Get.find<PatientDataController>();

  final HomeController homeController = Get.find<HomeController>();
  final double screenWidth = Get.width;
  final String orderIdFromParam;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kBackground,
      appBar: MobileWebMainAppbar(scaffoldKey: scaffoldKey),
      drawer: MobileWebHamburgerMenu(),
      body: Obx(
        () => (controller.state == MyConsultationDetailState.loading)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : (controller.myConsultationDetail != null)
                ? Stack(
                    children: [
                      Container(
                        height: Get.height,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            MWConsultationDetailHeader(),
                            if ([setting.canceled, setting.canceledBySystem].contains(controller.myConsultationDetail!.status))
                              // MWConsultationDetailCancelledContent()
                              MWConsultationDetailCancelledContent()
                            else if ([setting.waitingForPayment, setting.newOrder, setting.processGP]
                                .contains(controller.myConsultationDetail!.status))
                              MWConsultationDetailWaitPaymentContent(
                                appointmentId: controller.myConsultationDetail!.id.toString(),
                                created: controller.myConsultationDetail!.created.toString(),
                                fees: controller.myConsultationDetail!.fees,
                                dataTransaction:
                                    controller.myConsultationDetail!.transaction == null ? null : controller.myConsultationDetail!.transaction!,
                              )
                            else
                              MWConsultationDetailContent02()
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
                          alignment: Alignment.center,
                          width: Get.width,
                          // height: 50,
                          decoration: BoxDecoration(
                            boxShadow: [kBoxShadow],
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                            color: kBackground,
                            // border: Border.all(color: kBlackColor)
                          ),
                          child: CustomFlatButton(
                            width: Get.width,
                            color: kButtonColor,
                            onPressed: () async {
                              if ([
                                setting.waitingForPayment,
                              ].contains(controller.myConsultationDetail!.status)) {
                              } else if ([
                                // setting.paid,
                                setting.meetSpecialist,
                                setting.onGoing,
                                setting.waitingForMedicalResume,
                                setting.completed,
                              ].contains(controller.myConsultationDetail!.status)) {
                                Get.dialog(
                                  Dialog(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Untuk pengalaman yang lebih baik, silakan download aplikasi Altea untuk smartphone anda.",
                                            style: kPoppinsRegular400.copyWith(color: kBlackColor),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          CustomFlatButton(
                                            width: Get.width,
                                            text: "Download",
                                            onPressed: () {
                                              Get.back();
                                            },
                                            color: kButtonColor,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          CustomFlatButton(
                                            width: Get.width,
                                            text: "Lanjutkan via browser",
                                            onPressed: () {
                                              Get.back();
                                              patientDataController.selectedPatientData.value = Patient(
                                                id: controller.myConsultationDetail!.patient!.id.toString(),
                                                firstName: controller.myConsultationDetail!.patient!.firstName.toString(),
                                                lastName: controller.myConsultationDetail!.patient!.lastName.toString(),
                                              );
                                              final CallScreenController callScreenController =
                                                  Get.put(CallScreenController(orderIdFromParam: orderIdFromParam));

                                              callScreenController.callId.value = "new";
                                              callScreenController.orderId.value = controller.data["id"].toString();
                                              callScreenController.initCallDoctor.value = true;
                                              if (GetPlatform.isMobile) {
                                                Get.toNamed(
                                                  "/call-mobile?orderId=$orderIdFromParam",
                                                  arguments: {
                                                    "patientName":
                                                        "${controller.myConsultationDetail!.patient!.firstName} ${controller.myConsultationDetail!.patient!.lastName}",
                                                    "callType": "doctor"
                                                  },
                                                );
                                              } else {
                                                Get.toNamed(
                                                  "/call-desktop?orderId=$orderIdFromParam",
                                                  arguments: {
                                                    "patientName":
                                                        "${controller.myConsultationDetail!.patient!.firstName} ${controller.myConsultationDetail!.patient!.lastName}",
                                                    "callType": "calldoc"
                                                  },
                                                );
                                              }

                                              // callScreenController.callId.value = "new";
                                              // callScreenController.orderId.value = controller.data["id"].toString();
                                              // callScreenController.initCallDoctor.value = true;
                                              // Get.toNamed("/call-screen?orderId=$orderIdFromParam", arguments: {
                                              //   "patientName": "${controller.data["patient"]["name"]}",
                                              //   "callType": "calldoc"
                                              // });
                                            },
                                            color: Colors.white,
                                            borderColor: kButtonColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else if ([
                                setting.canceled,
                                setting.canceledBySystem,
                                setting.canceledByUser,
                                setting.canceledByGP,
                                setting.paymentExpired,
                                setting.paymentFailed,
                                setting.refunded
                              ].contains(controller.myConsultationDetail!.status)) {
                              } else {
                                //contact altea care
                                Get.dialog(
                                  AlertDialog(
                                    title: Text("Kontak Altea Care"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            if (await canLaunch("https://wa.me/6281315739235")) {
                                              launch("https://wa.me/6281315739235");
                                            }
                                          },
                                          child: Text(
                                            "+62 813 15739235",
                                            style: kTextInputStyle.copyWith(
                                                color: kBlackColor.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                            text:
                                // controller.myConsultationDetail!.status.toString(),
                                ([
                              // setting.newOrder,
                              // setting.processGP,
                              setting.waitingForPayment,
                            ].contains(controller.myConsultationDetail!.status))
                                    ? "Batalkan Konsultasi"
                                    : ([
                                        // setting.paid,
                                        setting.meetSpecialist,
                                        setting.onGoing,
                                        setting.waitingForMedicalResume,
                                        setting.completed,
                                      ].contains(
                                        controller.myConsultationDetail!.status,
                                      ))
                                        ? "Temui Dokter"
                                        : ([
                                            setting.canceled,
                                            setting.canceledBySystem,
                                            setting.canceledByUser,
                                            setting.canceledByGP,
                                            setting.paymentExpired,
                                            setting.paymentFailed,
                                            setting.refunded
                                          ].contains(
                                            controller.myConsultationDetail!.status,
                                          ))
                                            ? "Pilih Jadwal Ulang"
                                            : "Kontak Altea-Care",
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
      ),
    );
  }
}
