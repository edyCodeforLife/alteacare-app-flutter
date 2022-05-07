// Flutter imports:
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/helper.dart' as helper;
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/patient-type/controllers/patient_type_controller.dart';
import 'package:altea/app/modules/patient_confirmation/controllers/patient_confirmation_controller.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import 'package:altea/app/routes/app_pages.dart';

class MobileAppView extends GetView<PatientConfirmationController> {
  SpesialisKonsultasiController konsultasiController = Get.find<SpesialisKonsultasiController>();
  PatientTypeController patientTypeController = Get.find<PatientTypeController>();
  @override
  Widget build(BuildContext context) {
    // print(konsultasiController.doctorAvatar.value);
    // print('confirmation3');
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        elevation: 2,
        title: Text(
          'Booking Konfirmasi',
          style: kAppBarTitleStyle,
        ),
        centerTitle: true,
        backgroundColor: kBackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kBlackColor,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 5,
                          height: MediaQuery.of(context).size.width / 5,
                          // decoration: BoxDecoration(
                          // color: kRedError,
                          // borderRadius: BorderRadius.circular(24)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: ExtendedImage.network(
                              konsultasiController.doctorAvatar.value,
                              fit: BoxFit.cover,
                              cache: true,
                              borderRadius: BorderRadius.circular(48),
                              loadStateChanged: (ExtendedImageState state) {
                                if (state.extendedImageLoadState == LoadState.failed) {
                                  return Icon(
                                    Icons.image_not_supported_rounded,
                                    color: kLightGray,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                konsultasiController.doctorName.value,
                                style: kPoppinsSemibold600.copyWith(fontSize: 16, color: kBlackColor),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Sp. ${konsultasiController.doctorSpecialist.value}',
                                style: kPoppinsSemibold600.copyWith(fontSize: 13, color: kDarkBlue),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: kBlackColor.withOpacity(0.1),
                    height: 2,
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    child: Text(
                      'Detail Konsultasi',
                      style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 14),
                    ),
                  ),
                  buildRowDetail('Pasien :', konsultasiController.selectedPatientName.value),
                  buildRowDetail('Consult By :', konsultasiController.consultBy.value == 'PHONE_CALL' ? 'Phone Call' : 'Video Call'),
                  buildRowDetail('Date :', helper.getDateWithMonthAbv(konsultasiController.selectedDoctorTime.value.date.toString().split(' ')[0])),
                  buildRowDetail('Time :',
                      '${konsultasiController.selectedDoctorTime.value.startTime} - ${konsultasiController.selectedDoctorTime.value.endTime}')
                ],
              ),
              Container(
                margin: EdgeInsets.all(4),
                child: Column(
                  children: [
                    CustomFlatButton(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: double.infinity,
                        text: 'Konfirmasi',
                        onPressed: () async {
                          // print('---------------------------------');
                          // print('doctorId : ${konsultasiController.selectedDoctor.value}');
                          // print('patientId : ${konsultasiController.selectedUid.value}');
                          // print('consultationMethod : ${konsultasiController.consultBy.value}');
                          // print('schedules : ${konsultasiController.selectedDoctorTime.value.toJson()}');

                          var res = await controller.createAppointment({
                            "doctor_id": konsultasiController.selectedDoctor.value,
                            "patient_id": konsultasiController.selectedUid.value,
                            "symptom_note": "",
                            "next_step": "ASK_MA",
                            "video_call_provider": "FLUTTER_WEBRTC",
                            "consultation_method": konsultasiController.consultBy.value,
                            "schedules": [konsultasiController.selectedDoctorTime.value.toJson2()],
                          });

                          // print("res => $res");

                          if (res['status'] == true) {
                            konsultasiController.appointmentId.value = res['data']["appointment_id"].toString();
                            if (patientTypeController.selectedPatientType.value == 'PRIBADI')
                              Get.toNamed('/wait-ma-info');
                            else
                              Get.toNamed('/choose-payment', arguments: konsultasiController.appointmentId.value);
                          } else {
                            Get.dialog(
                              CustomSimpleDialog(
                                icon: const SizedBox(),
                                onPressed: () {
                                  Get.back();
                                },
                                title: "Gagal membuat konsultasi",
                                buttonTxt: "Kembali",
                                subtitle: res['message'] ?? "",
                              ),
                            );
                          }
                        },
                        color: kButtonColor),
                    Transform(
                      transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                      child: CustomFlatButton(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: double.infinity,
                          text: 'Ubah Pasien',
                          textStyle: GoogleFonts.poppins(color: kButtonColor, fontWeight: FontWeight.w500, fontSize: 14),
                          onPressed: () {
                            Get.offNamedUntil(Routes.PATIENT_DATA, (Route<dynamic> page) => page.settings.name == Routes.PATIENT_DATA);
                            Get.back();
                          },
                          borderColor: kButtonColor,
                          color: kBackground),
                    ),
                    Transform(
                      transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                      child: CustomFlatButton(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: double.infinity,
                          borderColor: kButtonColor,
                          text: 'Ubah Jadwal Konsultasi',
                          textStyle: GoogleFonts.poppins(color: kButtonColor, fontWeight: FontWeight.w500, fontSize: 14),
                          onPressed: () {
                            Get.offNamedUntil(
                                Routes.SPESIALIS_KONSULTASI, (Route<dynamic> page) => page.settings.name == Routes.SPESIALIS_KONSULTASI);
                            Get.back();
                          },
                          color: kBackground),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildRowDetail(String title, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: kPoppinsRegular400.copyWith(fontSize: 13, color: kBlackColor.withOpacity(0.5)),
          ),
          Text(
            text,
            style: kPoppinsSemibold600.copyWith(fontSize: 13, color: kBlackColor.withOpacity(0.8)),
          )
        ],
      ),
    );
  }
}
