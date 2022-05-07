// Flutter imports:
import 'dart:developer';

import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:altea/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/helper.dart' as helper;
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/choose_payment/controllers/choose_payment_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/my_consultation_detail/views/mobile_app_view/widgets/cancelled_consultation_tab.dart';
import 'package:altea/app/modules/my_consultation_detail/views/mobile_app_view/widgets/meet_doctor_tab.dart';
import 'package:altea/app/modules/my_consultation_detail/views/mobile_app_view/widgets/waiting_payment_consultation_tab.dart';
import 'package:altea/app/modules/patient_confirmation/controllers/patient_confirmation_controller.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:altea/app/core/utils/settings.dart' as settings;

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    // print('hexxx => $hexColor');
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class ConsultationDetailMobileView extends StatefulWidget {
  @override
  _ConsultationDetailMobileViewState createState() => _ConsultationDetailMobileViewState();
}

class _ConsultationDetailMobileViewState extends State<ConsultationDetailMobileView> {
  ChoosePaymentController paymentController = Get.put(ChoosePaymentController());
  SpesialisKonsultasiController konsultasiController = Get.put(SpesialisKonsultasiController());

  HomeController homeController = Get.find<HomeController>();

  String status = '';

  Widget buildByStatus(String status, Map<String, dynamic> map) {
    switch (status) {
      case 'NEW':
        return Container();
      case 'PROCESS_GP':
        return WaitingPaymentConsultationTab(data: map);
      case 'WAITING_FOR_PAYMENT':
        return WaitingPaymentConsultationTab(data: map);
      case 'PAID':
        return MeetDoctorTab(
          data: map,
        );
      case 'MEET_SPECIALIST':
        return MeetDoctorTab(data: map);
      case 'ON_GOING':
        return MeetDoctorTab(data: map);
      case 'WAITING_FOR_MEDICAL_RESUME':
        return MeetDoctorTab(data: map);
      case 'COMPLETED':
        return MeetDoctorTab(data: map);
      case "CANCELED_BY_SYSTEM":
        return CancelledConsultationTab(data: map);
      case "CANCELED_BY_GP":
        return CancelledConsultationTab(data: map);
      case "CANCELED_BY_USER":
        return CancelledConsultationTab(data: map);
      case "PAYMENT_EXPIRED":
        return CancelledConsultationTab(data: map);
      case "PAYMENT_FAILED":
        return CancelledConsultationTab(data: map);
      case "REFUNDED":
        return CancelledConsultationTab(data: map);
      default:
        return Container();
    }
  }

  String buttonText(String status) {
    switch (status) {
      case 'NEW':
        return 'Pilih Metode Pembayaran';
      case 'PROCESS_GP':
        return 'Pilih Metode Pembayaran';
      case 'WAITING_FOR_PAYMENT':
        return 'Cek Status Pembayaran';
      case 'PAID':
        return 'Konsultasi Ulang';
      case 'MEET_SPECIALIST':
        return 'Temui Dokter';
      case 'ON_GOING':
        return 'Konsultasi Ulang';
      case 'WAITING_FOR_MEDICAL_RESUME':
        return 'Konsultasi Ulang';
      case 'COMPLETED':
        return 'Konsultasi Ulang';
      case "CANCELED_BY_SYSTEM":
        return 'Pilih Jadwal Ulang';
      case "CANCELED_BY_GP":
        return 'Pilih Jadwal Ulang';
      case "CANCELED_BY_USER":
        return 'Pilih Jadwal Ulang';
      case "PAYMENT_EXPIRED":
        return 'Pilih Jadwal Ulang';
      case "PAYMENT_FAILED":
        return 'Pilih Jadwal Ulang';
      case "REFUNDED":
        return 'Contact Altea Care';
      default:
        return 'Contact Altea Care';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      // print('status => $status');
      // if (status == 'NEW') {
      //   CallScreenController callScreenController =
      //       Get.put(CallScreenController());
      //   // var data = await paymentController.getDetailAppointment(sp, goToCall)
      //   Get.to('/call-screen');
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    var consultationId = ModalRoute.of(context)?.settings.arguments;
    return WillPopScope(
      onWillPop: () async {
        homeController.currentIdx.value = 2;
        Get.offNamed('/home');
        return false;
      },
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          backgroundColor: kBackground,
          elevation: 2,
          title: Text(
            'Konsultasi Saya',
            style: kPoppinsMedium500.copyWith(fontSize: 15, color: kBlackColor),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: kBlackColor,
            ),
            onPressed: () {
              homeController.currentIdx.value = 2;
              Get.offNamed('/home');
            },
          ),
        ),
        body: FutureBuilder(
          future: paymentController.getDetailAppointment(consultationId.toString(), true),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // print('snapshot dataaaaa => ${snapshot.data}');
              var snap = (snapshot.data as Map<String, dynamic>)['data'];
              // print('snap => $snap');
              return Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Order ID : ',
                                  style: kPoppinsRegular400.copyWith(color: kBlackColor.withOpacity(0.4), fontSize: 10),
                                ),
                                Text(
                                  snap['order_code'].toString(),
                                  style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 10),
                                ),
                              ],
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: HexColor(snap['status_detail']['bg_color'].toString()).withOpacity(0.5),
                                ),
                                child: Text(
                                  snap['status_detail']['label'].toString(),
                                  style: kPoppinsSemibold600.copyWith(
                                    fontSize: 9,
                                    color: HexColor(snap['status_detail']['text_color'].toString()),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: kBlackColor.withOpacity(0.3),
                        width: double.infinity,
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 5,
                              height: MediaQuery.of(context).size.width / 5,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: ExtendedImage.network(
                                  snap['doctor']['photo'] == null ? ' ' : snap['doctor']['photo']['formats']['thumbnail'].toString(),
                                  fit: BoxFit.fill,
                                  cache: true,
                                  borderRadius: BorderRadius.circular(24),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${snap['doctor']['name']}',
                                  style: kPoppinsSemibold600.copyWith(fontSize: 14, color: kBlackColor),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Sp. ${snap['doctor']['specialist']['name']}',
                                  style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 10),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.date_range,
                                      color: kLightGray,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      helper.getDateWithMonthAbv(snap['schedule']['date'].toString()),
                                      style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Icon(
                                      Icons.access_time,
                                      color: kLightGray,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      '${snap['schedule']['time_start']} - ${snap['schedule']['time_end']}',
                                      style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: kBlackColor.withOpacity(0.3),
                        width: double.infinity,
                      ),
                      Expanded(
                        child: buildByStatus(snap['status'].toString(), snap as Map<String, dynamic>),
                      ),
                      // SizedBox(
                      //   height: 16,
                      // ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
                          color: snap['status'].toString() == 'PAID' ? kLightGray : kBackground,
                          boxShadow: [kBoxShadow]),
                      child: CustomFlatButton(
                          width: double.infinity,
                          text: buttonText(snap['status'].toString()),
                          onPressed: () async {
                            if (snap['status'].toString() == 'MEET_SPECIALIST') {
                              Get.put(PatientConfirmationController());
                              konsultasiController.selectedPatientName.value = snap['patient']['name'].toString();
                              konsultasiController.appointmentId.value = snap['id'].toString();
                              Get.toNamed('/call-screen', arguments: 'doctor');
                            } else if (snap['status'].toString() == 'NEW' || snap['status'].toString() == 'PROCESS_GP') {
                              Get.toNamed('/choose-payment', arguments: snap['id']);
                            } else if (snap['status'].toString() == 'WAITING_FOR_PAYMENT') {
                              setState(() {});
                            } else if (snap['status'].toString() == 'CANCELED_BY_SYSTEM' || snap['status'].toString() == 'COMPLETED') {
                              // log(snap.toString());
                              if (snap['doctor'] != null) {
                                Get.dialog(
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  barrierDismissible: false,
                                );
                                try {
                                  final Map<String, dynamic> doctorJson = await getDoctorDetail(snap['doctor']['id']);
                                  Get.back();
                                  Get.toNamed(Routes.SPESIALIS_KONSULTASI, arguments: doctorJson);
                                } catch (e) {
                                  Get.back();
                                  Get.dialog(
                                    CustomSimpleDialog(
                                      icon: const SizedBox(),
                                      onPressed: () {
                                        Get.back();
                                      },
                                      title: "Gagal Mencari Dokter",
                                      buttonTxt: "Kembali",
                                      subtitle: e.toString(),
                                    ),
                                  );
                                }
                              }
                            } else {
                              print(snap['status'].toString());
                            }
                          },
                          color: kButtonColor),
                    ),
                  )
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> getDoctorDetail(String doctorId) async {
    final res = await http.get(Uri.parse("${settings.alteaURL}/data/doctors?id=$doctorId"));
    if (res.statusCode == 200) {
      return json.decode(res.body)['data'][0];
    } else {
      throw "Dokter tidak ditemukan";
    }
  }
}
