import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/add_patient/controllers/add_patient_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/register/presentation/modules/register/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/mobile_patient_address.dart';
import 'widgets/mobile_patient_confirmation.dart';
import 'widgets/mobile_patient_data.dart';

class MobileAppView extends StatefulWidget {
  @override
  _MobileAppViewState createState() => _MobileAppViewState();
}

class _MobileAppViewState extends State<MobileAppView> {
  RegisterController registerController = Get.put(RegisterController());
  HomeController homeController = Get.find<HomeController>();
  AddPatientController controller = Get.put(AddPatientController());
  String? selectedNation = null;
  GlobalKey<FormState> _patientKey = GlobalKey<FormState>();
  String? selectedFamily = null;
  int currentIdx = 0;

  List<String> genders = ['Laki Laki', 'Perempuan'];
  String? selectedGender = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          backgroundColor: kBackground,
          title: Text(
            'Tambah Data Pasien',
            style: kAppBarTitleStyle,
          ),
          centerTitle: true,
          elevation: 3,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: kBlackColor,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30, left: 25),
                    color: kLightGray,
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 3,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 24, left: 25),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: kButtonColor,
                              radius: 10,
                              child: Text(
                                '1',
                                style: kPoppinsSemibold600.copyWith(fontSize: 11, color: kBackground),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Personal Data',
                              style: kPoppinsSemibold600.copyWith(
                                  fontWeight: currentIdx >= 0 ? FontWeight.bold : FontWeight.w500, fontSize: 9, color: kButtonColor),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: currentIdx >= 1 ? kButtonColor : kLightGray,
                              radius: 10,
                              child: Text(
                                '2',
                                style: kPoppinsSemibold600.copyWith(fontSize: 11, color: kBackground),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Alamat',
                              style: kPoppinsSemibold600.copyWith(
                                fontSize: 9,
                                fontWeight: currentIdx >= 1 ? FontWeight.bold : FontWeight.w500,
                                color: currentIdx >= 1 ? kButtonColor : kLightGray,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: currentIdx >= 2 ? kButtonColor : kLightGray,
                              radius: 10,
                              child: Text(
                                '3',
                                style: kPoppinsSemibold600.copyWith(fontSize: 11, color: kBackground),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Konfirmasi',
                              style: kPoppinsSemibold600.copyWith(
                                  fontSize: 9,
                                  fontWeight: currentIdx >= 2 ? FontWeight.bold : FontWeight.w500,
                                  color: currentIdx >= 2 ? kButtonColor : kLightGray),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              if (currentIdx == 0)
                MobilePatientData(
                  nextPage: () => setState(() => currentIdx = 1),
                )
              else
                currentIdx == 1
                    ? MobilePatientAddress(
                        nextPage: () => setState(() => currentIdx = 2),
                      )
                    : MobilePatientConfirmation()
            ],
          ),
        ));
  }
}
