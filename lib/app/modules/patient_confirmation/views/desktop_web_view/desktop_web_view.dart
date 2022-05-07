// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/data/model/patient_data_model.dart';
import 'package:altea/app/modules/choose_payment/controllers/choose_payment_controller.dart';
import 'package:altea/app/modules/patient_confirmation/controllers/patient_confirmation_controller.dart';
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import 'package:altea/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DesktopWebPatientConfirmationPage extends GetView<PatientConfirmationController> {
  const DesktopWebPatientConfirmationPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spesialisKonsultasiController = Get.find<SpesialisKonsultasiController>();
    final choosePaymentController = Get.put(ChoosePaymentController());

    final screenWidth = context.width;
    final patientDataController = Get.find<PatientDataController>();

    controller.selectedPatientType.value = patientDataController.selectedPatientType.value;

    // final addPatientController = Get.find<AddPatientController>();

    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 35,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: SizedBox(
                    height: 14,
                    width: 14,
                    child: InkWell(
                      onTap: () {
                        patientDataController.pageController.jumpToPage(1);
                        patientDataController.selectedPatient.value = -1;
                        patientDataController.selectedPatientData.value = Patient();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: kBlackColor,
                        size: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 26,
                ),
                Text(
                  "Booking Konfirmasi",
                  style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 22),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "Pastikan informasi di bawah sudah benar",
                  style: kPoppinsRegular400.copyWith(color: kTextHintColor, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          //? Info doctor and patient
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: spesialisKonsultasiController.doctorInfo.value.photo!.formats!.thumbnail != null
                          ? Image.network(addCDNforLoadImage(spesialisKonsultasiController.doctorInfo.value.photo!.formats!.thumbnail!),
                              fit: BoxFit.cover)
                          : Image.asset("assets/account-info@3x.png", fit: BoxFit.cover),
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    SizedBox(
                      height: 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              spesialisKonsultasiController.doctorInfo.value.name!,
                              style: kPoppinsSemibold600.copyWith(
                                color: kBlackColor,
                                fontSize: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Sp.${spesialisKonsultasiController.doctorInfo.value.specialization!.name!}",
                              style: kPoppinsSemibold600.copyWith(
                                color: kDarkBlue,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Divider(
                  height: 1,
                  color: kLightGray,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: Text(
              "Detail Konsultasi",
              style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 14),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pasien:",
                  style: kPoppinsRegular400.copyWith(fontSize: 14, color: kTextHintColor.withOpacity(0.8)),
                ),
                Text(
                  "${patientDataController.selectedPatientData.value.firstName} ${patientDataController.selectedPatientData.value.lastName}",
                  style: kPoppinsMedium500.copyWith(fontSize: 14, color: kTextHintColor),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 11,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Consult by:",
                  style: kPoppinsRegular400.copyWith(fontSize: 14, color: kTextHintColor.withOpacity(0.8)),
                ),
                Text(
                  spesialisKonsultasiController.consultBy.value,
                  style: kPoppinsMedium500.copyWith(fontSize: 14, color: kTextHintColor),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 11,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date:",
                  style: kPoppinsRegular400.copyWith(fontSize: 14, color: kTextHintColor.withOpacity(0.8)),
                ),
                Text(
                  DateFormat("EEEE, dd/MM/yyyy", "id").format(spesialisKonsultasiController.selectedDoctorTime.value.date!),
                  style: kPoppinsMedium500.copyWith(fontSize: 14, color: kTextHintColor),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 11,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Time:",
                  style: kPoppinsRegular400.copyWith(fontSize: 14, color: kTextHintColor.withOpacity(0.8)),
                ),
                Text(
                  "${spesialisKonsultasiController.selectedDoctorTime.value.startTime} - ${spesialisKonsultasiController.selectedDoctorTime.value.endTime}",
                  style: kPoppinsMedium500.copyWith(fontSize: 14, color: kTextHintColor),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 63,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: Obx(() => CustomFlatButton(
                width: screenWidth,
                text: "Konfirmasi",
                onPressed: controller.confirmSelected.value
                    ? null
                    : () async {
                        controller.confirmSelected.value = true;

                        // cek patient type
                        if (patientDataController.selectedPatientType.value == "pribadi") {
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

                          // print("Appointment data -> ${createAppointmentData}");
                          final result = await controller.createAppointment(createAppointmentData);

                          controller.dataAppointment.value = result as Map<String, dynamic>;

                          if (result["status"] == true) {
                            controller.confirmSelected.value = false;
                            // print(result.toString());
                            final String orderId = (result as Map<String, dynamic>)['data']['appointment_id'].toString();
                            // print(orderId);

                            Get.toNamed("${Routes.ONBOARD_CALL}?orderId=$orderId");
                          } else {
                            controller.confirmSelected.value = false;

                            showDialog(
                                context: context,
                                builder: (context) => CustomSimpleDialog(
                                    icon: SizedBox(
                                      width: screenWidth * 0.1,
                                      child: Image.asset("assets/failed_icon.png"),
                                    ),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    title: 'Terjadi Kesalahan',
                                    buttonTxt: 'Mengerti',
                                    subtitle: result["message"].toString()));
                          }
                        } else {
                          Get.offNamed(Routes.SUCCESS_PAYMENT_PAGE);
                        }
                      },
                color: controller.confirmSelected.value ? kLightGray : kButtonColor)),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: CustomFlatButton(
              width: screenWidth,
              text: "Ubah Pasien",
              onPressed: () {
                patientDataController.pageController.jumpToPage(1);
              },
              color: kBackground,
              borderColor: kButtonColor,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: CustomFlatButton(
                width: screenWidth,
                text: "Ubah Jadwal Konsultasi",
                onPressed: () {
                  Get.back();
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
