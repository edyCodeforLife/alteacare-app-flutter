// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/data/model/my_consultation.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/footer_section_view.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import 'package:altea/app/modules/my_consultation_detail/controllers/my_consultation_detail_controller.dart';
import 'package:altea/app/routes/app_pages.dart';

class DesktopWebDoctorSuccessScreen extends StatelessWidget {
  const DesktopWebDoctorSuccessScreen({Key? key, required this.elapsedTime, required this.orderId}) : super(key: key);
  final String elapsedTime;
  final String orderId;

  @override
  Widget build(BuildContext context) {
    final MyConsultation myConsultation = Get.put(MyConsultation());
    final MyConsultationDetailController myConsultationDetail = Get.put(MyConsultationDetailController());
    final screenWidth = context.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopNavigationBarSection(screenWidth: screenWidth),
            const SizedBox(
              height: 26,
            ),
            Column(
              children: [
                // foto dokter
                CircleAvatar(
                  radius: screenWidth * 0.05,
                ),
                const SizedBox(
                  height: 26,
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
                  height: 26,
                ),
                SizedBox(
                  width: screenWidth * 0.5,
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
                    width: screenWidth * 0.4,
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
                    width: screenWidth * 0.4,
                    text: 'Info Pemesanan Obat',
                    borderColor: kButtonColor,
                    onPressed: () {
                      Get.offNamed(Routes.PHARMACY_INFORMATION);
                    },
                    color: kBackground),
                const SizedBox(
                  height: 136,
                ),
              ],
            ),
            FooterSectionWidget(screenWidth: screenWidth)
          ],
        ),
      ),
    );
  }
}
