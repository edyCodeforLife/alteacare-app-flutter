// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/add_patient/controllers/add_patient_controller.dart';
import 'package:altea/app/modules/choose_payment/controllers/choose_payment_controller.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import 'package:altea/app/modules/patient_confirmation/controllers/patient_confirmation_controller.dart';
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import 'package:altea/app/routes/app_pages.dart';

class MobileWebPatientConfirmationPage extends GetView<PatientConfirmationController> {
  MobileWebPatientConfirmationPage({Key? key, required this.doctorIdFromParam}) : super(key: key);
  final String doctorIdFromParam;

  @override
  Widget build(BuildContext context) {
    final spesialisKonsultasiController = Get.find<SpesialisKonsultasiController>();
    final choosePaymentController = Get.put(ChoosePaymentController());

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
            height: 35,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Booking Konfirmasi",
                  style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 16),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "Pastikan informasi di bawah sudah benar",
                  style: kPoppinsRegular400.copyWith(color: kTextHintColor, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          //? Info doctor and patient
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: Image.network(
                        addCDNforLoadImage(spesialisKonsultasiController.doctorInfo.value.photo!.formats!.thumbnail!),
                      ),
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          spesialisKonsultasiController.doctorInfo.value.name!,
                          style: kPoppinsSemibold600.copyWith(
                            color: kBlackColor,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Sp.${spesialisKonsultasiController.doctorInfo.value.specialization!.name!}",
                          style: kPoppinsSemibold600.copyWith(
                            color: kDarkBlue,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 0.5,
                  color: kLightGray,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Text(
              "Detail Konsultasi",
              style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 11),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pasien:",
                  style: kPoppinsRegular400.copyWith(fontSize: 12, color: kLightGray),
                ),
                Text(
                  "${patientDataController.selectedPatientData.value.firstName} ${patientDataController.selectedPatientData.value.lastName}",
                  style: kPoppinsMedium500.copyWith(fontSize: 12, color: kTextHintColor),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 11,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Consult by:",
                  style: kPoppinsRegular400.copyWith(fontSize: 12, color: kLightGray),
                ),
                Text(
                  "${spesialisKonsultasiController.consultBy}",
                  style: kPoppinsMedium500.copyWith(fontSize: 12, color: kTextHintColor),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 11,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date:",
                  style: kPoppinsRegular400.copyWith(fontSize: 12, color: kLightGray),
                ),
                Text(
                  DateFormat("EEEE, dd/MM/yyyy", "id").format(spesialisKonsultasiController.selectedDoctorTime.value.date!),
                  style: kPoppinsMedium500.copyWith(fontSize: 12, color: kTextHintColor),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 11,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Time:",
                  style: kPoppinsRegular400.copyWith(fontSize: 12, color: kLightGray),
                ),
                Text(
                  "${spesialisKonsultasiController.selectedDoctorTime.value.startTime} - ${spesialisKonsultasiController.selectedDoctorTime.value.endTime}",
                  style: kPoppinsMedium500.copyWith(fontSize: 12, color: kTextHintColor),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 145,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Obx(
              () => CustomFlatButton(
                  width: screenWidth,
                  text: "Konfirmasi",
                  onPressed: controller.confirmSelected.value
                      ? null
                      : () async {
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
                                      onPressed: () async {
                                        Get.back();
                                        // print({
                                        //   "doctor_id": spesialisKonsultasiController.doctorInfo.value.doctorId,
                                        //   "patient_id": patientDataController.selectedPatientData.value.id,
                                        //   "symptom_note": "",
                                        //   "consultation_method": "VIDEO_CALL",
                                        //   "schedules": [
                                        //     {
                                        //       "code": spesialisKonsultasiController.selectedDoctorTime.value.code,
                                        //       "date": "${spesialisKonsultasiController.selectedDoctorTime.value.date}",
                                        //       "time_start": spesialisKonsultasiController.selectedDoctorTime.value.startTime,
                                        //       "time_end": spesialisKonsultasiController.selectedDoctorTime.value.endTime
                                        //     }
                                        //   ],
                                        // });
                                        final Map<String, dynamic> createAppointmentData = {
                                          "doctor_id": spesialisKonsultasiController.doctorInfo.value.doctorId,
                                          "patient_id": patientDataController.selectedPatientData.value.id,
                                          "symptom_note": "",
                                          "consultation_method": "VIDEO_CALL",
                                          "video_call_provider": "FLUTTER_WEBRTC",
                                          "schedules": [
                                            {
                                              "code": spesialisKonsultasiController.selectedDoctorTime.value.code,
                                              "date": "${spesialisKonsultasiController.selectedDoctorTime.value.date}",
                                              "time_start": spesialisKonsultasiController.selectedDoctorTime.value.startTime,
                                              "time_end": spesialisKonsultasiController.selectedDoctorTime.value.endTime
                                            }
                                          ],
                                        };
                                        final result = await controller.createAppointment(createAppointmentData) as Map<String, dynamic>;

                                        controller.dataAppointment.value = result as Map<String, dynamic>;

                                        if (result["status"] == true) {
                                          controller.confirmSelected.value = false;
                                          if (patientDataController.selectedPatientType.value == "pribadi") {
                                            final String orderId = (result as Map<String, dynamic>)['data']['appointment_id'].toString();

                                            Get.toNamed("${Routes.ONBOARD_CALL}?orderId=$orderId");

                                            // Get.toNamed(Routes.ONBOARD_CALL);
                                          } else {
                                            final String orderId = (result as Map<String, dynamic>)['data']['appointment_id'].toString();
                                            Get.toNamed("${Routes.SUCCESS_PAYMENT_PAGE}?orderId=$orderId");
                                          }

                                          // Get.toNamed(Routes.WAIT_MA_INFO);
                                        } else {
                                          controller.confirmSelected.value = false;
                                          Get.dialog(
                                            CustomSimpleDialog(
                                              icon: SizedBox(
                                                width: screenWidth * 0.1,
                                                child: Image.asset("assets/failed_icon.png"),
                                              ),
                                              onPressed: () {
                                                Get.back();
                                                // Get.toNamed(Routes.SUCCESS_PAYMENT);
                                              },
                                              title: 'Terjadi kesalahan',
                                              buttonTxt: 'Mengerti',
                                              subtitle: result["message"].toString(),
                                            ),
                                          );
                                        }
                                      },
                                      color: Colors.white,
                                      borderColor: kButtonColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                  color: controller.confirmSelected.value ? kLightGray : kButtonColor),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: CustomFlatButton(
              width: screenWidth,
              text: "Ubah Pasien",
              onPressed: () {
                Get.back();
              },
              color: kBackground,
              borderColor: kButtonColor,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: CustomFlatButton(
                width: screenWidth,
                text: "Ubah Jadwal Konsultasi",
                onPressed: () {
                  Future.delayed(Duration(milliseconds: 100), () {
                    Get.offAndToNamed("${Routes.SPESIALIS_KONSULTASI}?doctorId=$doctorIdFromParam");
                  });
                },
                color: kBackground,
                borderColor: kButtonColor),
          ),
          const SizedBox(
            height: 28,
          ),
        ],
      ),
    );
  }
}
