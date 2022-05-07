// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/styles.dart';
import '../../../patient_data/controllers/patient_data_controller.dart';

class PatientTypeDesktopWebView extends StatelessWidget {
  const PatientTypeDesktopWebView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final addPatientController = Get.find<AddPatientController>();
    final controller = Get.find<PatientDataController>();

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 25,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tipe Pasien",
            style: kPoppinsSemibold600.copyWith(
              fontSize: 17,
              color: kBlackColor,
            ),
          ),
          Text(
            'Pilih tipe pasien yang akan melakukan konsultasi',
            style: kPoppinsRegular400.copyWith(
              fontSize: 10,
              color: kBlackColor,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: kBackground,
              boxShadow: [kBoxShadow],
            ),
            child: InkWell(
              onTap: () {
                controller.pageController.jumpToPage(1);
                controller.selectedPatientType.value = "pribadi";
              },
              child: Row(
                children: [
                  Image.asset('assets/account-info.png'),
                  const SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pribadi',
                        style: kPoppinsMedium500.copyWith(
                          fontSize: 12,
                          color: kBlackColor,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Jenis Pasien Pribadi',
                        style: kPoppinsRegular400.copyWith(
                          fontSize: 10,
                          color: kBlackColor.withOpacity(0.7),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: kBackground,
              boxShadow: [kBoxShadow],
            ),
            child: InkWell(
              onTap: () {
                controller.pageController.jumpToPage(1);
                controller.selectedPatientType.value = "company";
              },
              child: Row(
                children: [
                  Image.asset('assets/account-info-copy.png'),
                  const SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Perusahaan',
                        style: kPoppinsMedium500.copyWith(
                          fontSize: 12,
                          color: kBlackColor,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Jenis Pasien Perusahaan',
                        style: kPoppinsRegular400.copyWith(
                          fontSize: 10,
                          color: kBlackColor.withOpacity(0.7),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: kBackground,
              boxShadow: [kBoxShadow],
            ),
            child: InkWell(
              onTap: () {
                controller.pageController.jumpToPage(1);
                controller.selectedPatientType.value = "insurance";
              },
              child: Row(
                children: [
                  Image.asset('assets/account-info-copy-2.png'),
                  const SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Asuransi',
                        style: kPoppinsMedium500.copyWith(
                          fontSize: 12,
                          color: kBlackColor,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Jenis Pasien Asuransi',
                        style: kPoppinsRegular400.copyWith(
                          fontSize: 10,
                          color: kBlackColor.withOpacity(0.7),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
