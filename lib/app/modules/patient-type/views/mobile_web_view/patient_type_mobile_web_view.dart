// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import '../../../patient_data/controllers/patient_data_controller.dart';

class PatientTypeMobileWebView extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = Get.find<PatientDataController>();
  final String? doctorIdFromParam;
  PatientTypeMobileWebView({this.doctorIdFromParam});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: MobileWebMainAppbar(
        scaffoldKey: scaffoldKey,
      ),
      drawer: MobileWebHamburgerMenu(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
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
              SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () {
                  controller.selectedPatientType.value = "pribadi";
                  Get.toNamed('/patient-data?doctorId=$doctorIdFromParam');
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: kBackground,
                    boxShadow: [kBoxShadow],
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/account-info.png'),
                      SizedBox(
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
                          SizedBox(
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
              InkWell(
                onTap: () {
                  controller.selectedPatientType.value = "company";
                  Get.toNamed('/patient-data?doctorId=$doctorIdFromParam');
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: kBackground,
                    boxShadow: [kBoxShadow],
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/account-info-copy.png'),
                      SizedBox(
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
                          SizedBox(
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
              InkWell(
                onTap: () {
                  controller.selectedPatientType.value = "insurance";
                  Get.toNamed('/patient-data?doctorId=$doctorIdFromParam');
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: kBackground,
                    boxShadow: [kBoxShadow],
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/account-info-copy-2.png'),
                      SizedBox(
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
                          SizedBox(
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
        ),
      ),
    );
  }
}
