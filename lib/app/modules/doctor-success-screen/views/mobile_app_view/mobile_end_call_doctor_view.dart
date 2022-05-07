import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import 'package:altea/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileEndCallDoctorView extends StatefulWidget {
  @override
  _MobileEndCallDoctorViewState createState() => _MobileEndCallDoctorViewState();
}

class _MobileEndCallDoctorViewState extends State<MobileEndCallDoctorView> {
  HomeController homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    // print('args => ${ModalRoute.of(context)!.settings.arguments}');
    return WillPopScope(
        onWillPop: () async {
          homeController.currentIdx.value = 2;
          Get.offNamed('/home');
          return false;
        },
        child: Scaffold(
          backgroundColor: kBackground,
          body: Container(
            margin: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 8,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Sesi Konsultasi Berakhir',
                  style: kPoppinsRegular400.copyWith(fontSize: 15, color: kBlackColor),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  ModalRoute.of(context)!.settings.arguments.toString(),
                  style: kPoppinsSemibold600.copyWith(fontSize: 25, color: kDarkBlue),
                ),
                SizedBox(
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
                SizedBox(
                  height: 74,
                ),
                CustomFlatButton(
                    width: double.infinity,
                    text: 'Memo Altea',
                    onPressed: () {
                      Get.offNamed(Routes.MY_CONSULTATION_DETAIL, arguments: Get.find<SpesialisKonsultasiController>().appointmentId.value);
                    },
                    color: kButtonColor),
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
        ));
  }
}
