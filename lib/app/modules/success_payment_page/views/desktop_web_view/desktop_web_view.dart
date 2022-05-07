// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:clipboard/clipboard.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timer_count_down/timer_count_down.dart';

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/widgets/custom_flat_button.dart';
import '../../../../routes/app_pages.dart';
import '../../../choose_payment/controllers/choose_payment_controller.dart';
import '../../../home/controllers/home_controller.dart';
import '../../../home/views/dekstop_web/widget/footer_section_view.dart';
import '../../../home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import '../../../patient_confirmation/controllers/patient_confirmation_controller.dart';
import '../../controllers/success_payment_page_controller.dart';

class DesktopWebSuccessPaymentPage extends GetView<SuccessPaymentPageController> {
  const DesktopWebSuccessPaymentPage({Key? key, this.appointmentId}) : super(key: key);
  final String? appointmentId;
  // TODO: waiting for API When choose insurance or company type

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final choosePaymentController = Get.find<ChoosePaymentController>();
    final patientConfirmationController = Get.find<PatientConfirmationController>();

    if (patientConfirmationController.selectedPatientType.value == "pribadi" || patientConfirmationController.selectedPatientType.value == "") {
      controller.appointmentId.value = appointmentId ?? patientConfirmationController.dataAppointment["data"]["appointment_id"].toString();
    }

    return Scaffold(
      body: Column(
        children: [
          TopNavigationBarSection(
            screenWidth: screenWidth,
          ),
          Expanded(
            child: (patientConfirmationController.selectedPatientType.value == "pribadi" ||
                    patientConfirmationController.selectedPatientType.value == "")
                ? StreamBuilder(
                    stream: controller.vaCheckStreamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final resultData = snapshot.data! as Map<String, dynamic>;

                        final endTime = DateTime.parse(
                                DateTime.parse((choosePaymentController.resultPayment.value.data!.expiredAt!).toString()).toIso8601String())
                            .difference(DateTime.parse(DateTime.now().toIso8601String()))
                            .inSeconds;

                        return ListView(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            if (choosePaymentController.resultPayment.value.data!.type == choosePaymentController.vaType)
                              VaPaymentContent(
                                endTime: endTime,
                                resultData: resultData,
                              )
                            else
                              FreeAlteaPaymentContent(
                                resultData: resultData,
                              ),
                            const SizedBox(
                              height: 40,
                            ),
                            FooterSectionWidget(screenWidth: screenWidth)
                          ],
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )
                : ListView(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      InsuranceOrCompanyPaymentContent(),
                      const SizedBox(
                        height: 40,
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

class InsuranceOrCompanyPaymentContent extends StatelessWidget {
  InsuranceOrCompanyPaymentContent({
    Key? key,
  }) : super(key: key);
  // final Map<String, dynamic> resultData;
  final choosePaymentController = Get.find<ChoosePaymentController>();
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.3),
          child: Container(
            width: screenWidth,
            decoration: BoxDecoration(
              color: kBackground,
              border: Border.all(color: kLightGray),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(blurRadius: 22, offset: const Offset(0, 3), color: kLightGray)],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                  decoration: BoxDecoration(
                    color: kLightGray,
                    border: Border.all(color: kLightGray.withOpacity(0.2)),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Order id: ",
                        style: kPoppinsRegular400.copyWith(color: kTextHintColor),
                      ),
                      Text(
                        // resultData["data"]["id"].toString(),
                        "687008000",
                        style: kPoppinsSemibold600.copyWith(color: kDarkBlue),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 46,
                ),
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Image.asset(
                    "assets/success_icon.png",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 13,
                ),
                Text(
                  "Konsultasi Berhasil Dibuat",
                  style: kPoppinsSemibold600.copyWith(color: kBlackColor),
                ),
                const SizedBox(
                  height: 39,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.3),
          child: Container(
            width: screenWidth,
            padding: const EdgeInsets.symmetric(horizontal: 26),
            decoration: BoxDecoration(
              color: kBackground,
              border: Border.all(color: kLightGray),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kLightGray,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                          "Jadwal konsultasi berhasil dibuat, beberapa saat lagi Anda akan menerima panggilan dari rumah sakit untuk melakukan konfirmasi data.",
                          style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 12),
                          softWrap: true,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 29,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Konsultasi Dokter:",
                      style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 12),
                    ),
                    Text(
                      // "Rp. ${resultData["data"]["fees"][0]["amount"].toString()}",
                      "Rp 150.000",
                      style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 11,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Biaya Layanan:",
                      style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 12),
                    ),
                    Text(
                      // "Rp. ${resultData["data"]["fees"][1]["amount"].toString()}",
                      "Rp 15.000",
                      style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 11,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pajak:",
                      style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 12),
                    ),
                    Text(
                      "0 %",
                      style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Divider(
                  height: 2,
                  color: kLightGray,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: kPoppinsSemibold600.copyWith(color: kButtonColor),
                    ),
                    Text(
                      // "Rp${choosePaymentController.resultPayment.value.data!.total}",
                      "Rp. 165.000",
                      style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                CustomFlatButton(
                    width: screenWidth,
                    text: "Konsultasi Saya",
                    onPressed: () {
                      // todo: maybe passing id here

                      homeController.isSelectedTabBeranda.value = false;
                      homeController.isSelectedTabDokter.value = false;
                      homeController.isSelectedTabKonsultasi.value = true;
                      Get.offNamed(Routes.MY_CONSULTATION);
                    },
                    color: kButtonColor),
                const SizedBox(
                  height: 8,
                ),
                CustomFlatButton(
                  width: screenWidth,
                  text: "Beranda",
                  onPressed: () {
                    homeController.isSelectedTabBeranda.value = true;
                    homeController.isSelectedTabDokter.value = false;
                    homeController.isSelectedTabKonsultasi.value = false;
                    Future.delayed(Duration.zero, () {
                      Get.offNamedUntil("/home", (route) => false);
                    });
                  },
                  color: kBackground,
                  borderColor: kButtonColor,
                ),
                const SizedBox(
                  height: 13,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FreeAlteaPaymentContent extends StatelessWidget {
  FreeAlteaPaymentContent({Key? key, required this.resultData}) : super(key: key);
  final Map<String, dynamic> resultData;
  final choosePaymentController = Get.find<ChoosePaymentController>();
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.3),
          child: Container(
            width: screenWidth,
            decoration: BoxDecoration(
              color: kBackground,
              border: Border.all(color: kLightGray),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(blurRadius: 22, offset: const Offset(0, 3), color: kLightGray)],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                  decoration: BoxDecoration(
                    color: kLightGray,
                    border: Border.all(color: kLightGray.withOpacity(0.2)),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Order id: ",
                        style: kPoppinsRegular400.copyWith(color: kTextHintColor),
                      ),
                      Text(
                        resultData["data"]["id"].toString(),
                        style: kPoppinsSemibold600.copyWith(color: kDarkBlue),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 46,
                ),
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Image.asset(
                    "assets/success_icon.png",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 13,
                ),
                Text(
                  "Konsultasi Berhasil Dibuat",
                  style: kPoppinsSemibold600.copyWith(color: kBlackColor),
                ),
                const SizedBox(
                  height: 39,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.3),
          child: Container(
            width: screenWidth,
            padding: const EdgeInsets.symmetric(horizontal: 26),
            decoration: BoxDecoration(
              color: kBackground,
              border: Border.all(color: kLightGray),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kLightGray,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                          "Jadwal konsultasi berhasil dibuat, Anda tidak perlu melakukan pembayaran dikaranekan konsultasi ini gratis.",
                          style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 12),
                          softWrap: true,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 29,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Konsultasi Dokter:",
                      style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 12),
                    ),
                    Text(
                      "Rp. ${resultData["data"]["fees"][0]["amount"].toString()}",
                      style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 11,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Biaya Layanan:",
                      style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 12),
                    ),
                    Text(
                      "Rp. ${resultData["data"]["fees"][1]["amount"].toString()}",
                      style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 11,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pajak:",
                      style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 12),
                    ),
                    Text(
                      "0 %",
                      style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Divider(
                  height: 2,
                  color: kLightGray,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: kPoppinsSemibold600.copyWith(color: kButtonColor),
                    ),
                    Text(
                      "Rp${choosePaymentController.resultPayment.value.data!.total}",
                      style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                CustomFlatButton(
                    width: screenWidth,
                    text: "Konsultasi Saya",
                    onPressed: () {
                      // todo: maybe passing id here

                      homeController.isSelectedTabBeranda.value = false;
                      homeController.isSelectedTabDokter.value = false;
                      homeController.isSelectedTabKonsultasi.value = true;
                      Get.toNamed(Routes.MY_CONSULTATION);
                    },
                    color: kButtonColor),
                const SizedBox(
                  height: 8,
                ),
                CustomFlatButton(
                  width: screenWidth,
                  text: "Beranda",
                  onPressed: () {
                    homeController.isSelectedTabBeranda.value = true;
                    homeController.isSelectedTabDokter.value = false;
                    homeController.isSelectedTabKonsultasi.value = false;
                    Future.delayed(Duration.zero, () {
                      Get.offNamedUntil("/home", (route) => false);
                    });
                  },
                  color: kBackground,
                  borderColor: kButtonColor,
                ),
                const SizedBox(
                  height: 13,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class VaPaymentContent extends StatelessWidget {
  VaPaymentContent({Key? key, required this.resultData, required this.endTime}) : super(key: key);
  final Map<String, dynamic> resultData;
  final choosePaymentController = Get.find<ChoosePaymentController>();
  final int endTime;
  final controller = Get.find<SuccessPaymentPageController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    // print("RESULT DATA VA PAYMENT $resultData");

    // print(
    //     "RESULT DATA RESULT PAYMENT -> ${choosePaymentController.resultPayment.toJson()}");

    // print("ICON BANK ADA ? ${resultData["data"]["transaction"]["detail"]["icon"]}");

    final dateTime = DateTime.parse(choosePaymentController.resultPayment.value.data!.expiredAt.toString());
    final timeStamp = dateTime.toUtc().microsecondsSinceEpoch;
    final date = DateTime.fromMicrosecondsSinceEpoch(timeStamp);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
          child: Container(
            decoration: BoxDecoration(
              color: kBackground,
              border: Border.all(color: kLightGray),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(blurRadius: 22, offset: const Offset(0, 3), color: kLightGray)],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                  decoration: BoxDecoration(
                    color: kLightGray.withOpacity(0.2),
                    border: Border.all(color: kLightGray),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Order id: ",
                        style: kPoppinsRegular400.copyWith(color: kTextHintColor),
                      ),
                      Text(
                        resultData["data"]["order_code"].toString(),
                        style: kPoppinsSemibold600.copyWith(color: kDarkBlue),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Batas Akhir Pembayaran:",
                  style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 10),
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat("EEEE, dd MMM yyyy", "id").format(choosePaymentController.resultPayment.value.data!.expiredAt!),
                      style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 13),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      DateFormat.Hm().format(date),
                      style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Countdown(
                  seconds: endTime,
                  build: (BuildContext context, double time) {
                    final remainingTime = Duration(seconds: time.toInt());
                    final timeRes = controller.printDuration(remainingTime);
                    return Text(
                      timeRes,
                      style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 22),
                    );
                  },
                  interval: const Duration(milliseconds: 100),
                ),
                const SizedBox(
                  height: 28,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 26,
            ),
            decoration: BoxDecoration(
              color: kBackground,
              border: Border.all(color: kLightGray),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Container(
                      width: 51,
                      height: 51,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kBackground,
                          image: DecorationImage(
                            image: NetworkImage(addCDNforLoadImage(resultData["data"]["transaction"]["detail"]["icon"].toString())),
                            fit: BoxFit.contain,
                          )),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${resultData["data"]["transaction"]["detail"]["name"]}",
                          style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 14),
                        ),
                        Text(
                          "${resultData["data"]["transaction"]["detail"]["description"]}",
                          style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 10),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                Divider(
                  height: 1,
                  color: kLightGray,
                ),
                const SizedBox(
                  height: 29,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nomor Virtual Account",
                          style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 10),
                        ),
                        Text(
                          "${resultData["data"]["transaction"]["va_number"]}",
                          style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 13),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        FlutterClipboard.copy(
                          resultData["data"]["transaction"]["va_number"].toString(),
                        );

                        Fluttertoast.showToast(
                          msg: "Va number copied",
                          backgroundColor: kGreenColor.withOpacity(0.2),
                          textColor: kGreenColor,
                          webShowClose: true,
                          timeInSecForIosWeb: 8,
                          fontSize: 13,
                          gravity: ToastGravity.TOP,
                          webPosition: 'center',
                          toastLength: Toast.LENGTH_LONG,
                          webBgColor: '#F8FCF5',
                        );
                      },
                      child: Text(
                        "Salin",
                        style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Pembayaran",
                          style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 10),
                        ),
                        Text(
                          NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(resultData["data"]["transaction"]["total"]),
                          style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 13),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        FlutterClipboard.copy(
                          resultData["data"]["transaction"]["total"].toString(),
                        );

                        Fluttertoast.showToast(
                          msg: "Total price copied",
                          backgroundColor: kGreenColor.withOpacity(0.2),
                          textColor: kGreenColor,
                          webShowClose: true,
                          timeInSecForIosWeb: 8,
                          fontSize: 13,
                          gravity: ToastGravity.TOP,
                          webPosition: 'center',
                          toastLength: Toast.LENGTH_LONG,
                          webBgColor: '#F8FCF5',
                        );
                      },
                      child: Text(
                        "Salin Jumlah",
                        style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Konsultasi Dokter:",
                      style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 12),
                    ),
                    Text(
                      NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: "IDR ").format(resultData["data"]["fees"][0]["amount"]),
                      style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 11,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Biaya Layanan:",
                      style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 12),
                    ),
                    Text(
                      NumberFormat.currency(locale: 'id', symbol: "IDR ", decimalDigits: 0).format(resultData["data"]["fees"][1]["amount"]),
                      style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 11,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Diskon:",
                      style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 12),
                    ),
                    Text(
                      NumberFormat.currency(locale: 'id', name: "IDR ", decimalDigits: 0).format(resultData["data"]["fees"][2]["amount"] ?? 0),
                      style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 11,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pajak:",
                      style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 12),
                    ),
                    Text(
                      "0 %",
                      style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Divider(
                  height: 2,
                  color: kLightGray,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: kPoppinsSemibold600.copyWith(color: kButtonColor),
                    ),
                    Text(
                      NumberFormat.currency(locale: 'id', symbol: "IDR ", decimalDigits: 0)
                          .format(choosePaymentController.resultPayment.value.data!.total),
                      style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 26,
            ),
            decoration: BoxDecoration(
              color: kBackground,
              border: Border.all(color: kLightGray),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: screenWidth * 0.01),
                  child: Text(
                    "Panduan Pembayaran",
                    style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  child: Container(
                    height: screenWidth * 0.18,
                    child: FutureBuilder<Map<String, dynamic>>(
                        future: controller.getPaymentGuides("${resultData["data"]["transaction"]["detail"]["code"]}"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final result = snapshot.data!["data"] as List;
                            return ListView.builder(
                              itemCount: result.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    controller.isExpanded.value ? controller.shrinkTile() : controller.expandTile();
                                  },
                                  child: buildExpansionTile(result[index] as Map<String, dynamic>),
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildExpansionTile(Map<String, dynamic> data) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      key: controller.keyTile,
      initiallyExpanded: controller.isExpanded.value,
      title: Text(
        data["title"].toString(),
        style: kPoppinsSemibold600.copyWith(fontSize: 12, color: kDarkBlue),
      ),
      children: [
        HtmlWidget(
          data["text"].toString(),
          customStylesBuilder: (e) {
            return {
              "color": "0xFFD8D8D8",
              "font-size": "10px",
              "font-weight": "normal",
            };
          },
        )
      ],
    );
  }
}
