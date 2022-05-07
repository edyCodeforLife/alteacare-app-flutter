// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/patient-type/controllers/patient_type_controller.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

class MobileAppView extends StatefulWidget {
  @override
  _MobileAppViewState createState() => _MobileAppViewState();
}

class _MobileAppViewState extends State<MobileAppView> {
  PatientTypeController controller = Get.put(PatientTypeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          'Tipe Pasien',
          style: kAppBarTitleStyle,
        ),
        centerTitle: true,
        backgroundColor: kBackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: kBlackColor,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih tipe pasien yang akan melakukan konsultasi',
                style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor),
              ),
              SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () {
                  controller.selectedPatientType.value = 'PRIBADI';
                  Get.toNamed('/patient-data');
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: kBackground, boxShadow: [kBoxShadow]),
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
                            style: kPoppinsSemibold600.copyWith(fontSize: 12, color: kBlackColor),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            'Jenis Pasien Pribadi',
                            style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.7)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.selectedPatientType.value = 'PERUSAHAAN';
                  Get.toNamed('/patient-data');
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: kBackground, boxShadow: [kBoxShadow]),
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
                            style: kPoppinsSemibold600.copyWith(fontSize: 12, color: kBlackColor),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            'Jenis Pasien Perusahaan',
                            style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.7)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.selectedPatientType.value = 'ASURANSI';
                  Get.toNamed('/patient-data');
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: kBackground, boxShadow: [kBoxShadow]),
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
                            style: kPoppinsSemibold600.copyWith(fontSize: 12, color: kBlackColor),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            'Jenis Pasien Asuransi',
                            style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.7)),
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
