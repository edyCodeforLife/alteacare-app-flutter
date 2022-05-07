import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileAppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/home');

        return false;
      },
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: MediaQuery.of(context).size.width / 8,
                backgroundColor: kButtonColor.withOpacity(0.08),
                child: Icon(
                  Icons.videocam,
                  color: kButtonColor,
                  size: MediaQuery.of(context).size.width / 6,
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Layanan Medical Advisor GRATIS',
                      style: kPoppinsSemibold600.copyWith(fontSize: 16, color: kBlackColor.withOpacity(0.8)),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Anda akan terhubung dengan Medical Advisor AlteaCare untuk verifikasi identitas. Dimohon Menyiapkan :',
                      style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.8), height: 1.6),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Icon(
                              Icons.circle,
                              color: kButtonColor,
                              size: 10,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            'Siapkan KTP',
                            style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 12),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Icon(
                              Icons.circle,
                              color: kButtonColor,
                              size: 10,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              'Laporan hasil pemeriksaan penunjang (laboratorium, radiologi, dll) yang berkaitan dengan keluhan Anda saat ini.',
                              style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 12),
                              softWrap: true,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              CustomFlatButton(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: double.infinity,
                  text: 'Start Video Call',
                  onPressed: () {
                    Get.toNamed('/call-screen');
                  },
                  color: kButtonColor),
              Transform(
                transform: Matrix4.translationValues(0.0, -5.0, 0.0),
                child: CustomFlatButton(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: double.infinity,
                  text: 'Cancel',
                  onPressed: () {
                    Get.offNamed('/home');
                  },
                  color: kBackground,
                  borderColor: kButtonColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
