// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/footer_section_view.dart';
import '../../../home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';

class DekstopWebPharmacyInformationPage extends StatelessWidget {
  DekstopWebPharmacyInformationPage({Key? key}) : super(key: key);

  final List<String> instruction = [
    "1. Anda akan dihubungi oleh petugas farmasi Rumah Sakit dalam 30menit",
    "2. Konfirmasi pembelian obat & alamat pengiriman obat",
    "3. Pembayaran ",
    "4. Pengiriman obat ke lokasi tujuan",
    "5. Obat sampai di tujuan "
  ];
  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final homeController = Get.find<HomeController>();
    homeController.isSelectedTabBeranda.value = false;
    homeController.isSelectedTabDokter.value = false;
    homeController.isSelectedTabKonsultasi.value = true;
    return Scaffold(
      backgroundColor: kBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopNavigationBarSection(screenWidth: screenWidth),
            const SizedBox(
              height: 96,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Text(
                "Info Pemesanan Obat",
                style: kPoppinsMedium500.copyWith(fontSize: 22, color: fullBlack),
              ),
            ),
            const SizedBox(
              height: 56,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              height: screenWidth * 0.6,
              child: ListView.builder(
                itemCount: instruction.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 22.0),
                    child: Row(
                      children: [
                        Container(
                          width: 93,
                          height: 93,
                          decoration: BoxDecoration(color: kButtonColor, borderRadius: BorderRadius.circular(16)),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            instruction[index],
                            style: kPoppinsRegular400.copyWith(fontSize: 12, color: kBlackColor.withOpacity(0.6)),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            // const SizedBox(
            //   height: 103,
            // ),
            FooterSectionWidget(screenWidth: screenWidth)
          ],
        ),
      ),
    );
  }
}
