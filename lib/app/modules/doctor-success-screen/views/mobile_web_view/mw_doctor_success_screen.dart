// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/data/model/my_consultation.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/my_consultation_detail/controllers/my_consultation_detail_controller.dart';
import 'package:altea/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

class MWDoctorSuccessScreen extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();
  final String elapsedTime;
  final String orderId;

  MWDoctorSuccessScreen({required this.elapsedTime, required this.orderId});
  final MyConsultation myConsultation = Get.put(MyConsultation());

  final MyConsultationDetailController myConsultationDetail = Get.put(MyConsultationDetailController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(Routes.HOME);
        Get.to(() => Routes.MY_CONSULTATION);
        return false;
      },
      child: Scaffold(
        backgroundColor: kBackground,
        body: Container(
          margin: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: MediaQuery.of(context).size.width / 8,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Sesi Konsultasi Berakhir',
                style: kPoppinsRegular400.copyWith(fontSize: 15, color: kBlackColor),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                elapsedTime.toString(),
                style: kPoppinsSemibold600.copyWith(fontSize: 25, color: kDarkBlue),
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  'Untuk melihat ringkasan medis, Silakan buka  "Memo Altea" ',
                  textAlign: TextAlign.center,
                  style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor),
                ),
              ),
              const SizedBox(
                height: 74,
              ),
              CustomFlatButton(
                  width: double.infinity,
                  text: 'Memo Altea',
                  onPressed: () {
                    myConsultationDetail.orderId.value = orderId;

                    Get.offNamed("${Routes.MY_CONSULTATION_DETAIL}?orderId=$orderId");
                  },
                  color: kButtonColor),
              const SizedBox(
                height: 15,
              ),
              CustomFlatButton(
                  width: double.infinity,
                  text: 'Info Pemesanan Obat',
                  borderColor: kButtonColor,
                  onPressed: () {
                    Get.toNamed('/pharmacy-information');
                  },
                  color: kBackground)
            ],
          ),
        ),
      ),
    );
  }
}
