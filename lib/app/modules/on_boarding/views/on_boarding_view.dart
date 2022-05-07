// Flutter imports:
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:altea/app/core/utils/use_shared_pref.dart';
import 'package:url_launcher/url_launcher.dart';

class OnBoardingView extends StatefulWidget {
  @override
  _OnBoardingViewState createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  SharedPreferences? _sp;
  @override
  void initState() {
    super.initState();
    getAccessToken();
  }

  final String alteaPlaystoreURL = "https://play.google.com/store/apps/details?id=com.dre.loyalty";

  Future getAccessToken() async {
    _sp = await SharedPreferences.getInstance();
    final bool isFirstTime = _sp?.getBool("isFirstTime") ?? true;
    if (!GetPlatform.isWeb) {
      var token = await AppSharedPreferences.getAccessToken();
      // print('accessTokennih  => $token');
      if (token == '') {
        if (isFirstTime) {
          Get.dialog(
            WillPopScope(
              child: CustomSimpleDualButtonDialog(
                icon: SizedBox(),
                onPressed1: () {
                  Get.back();
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Get.offAndToNamed("/intro");
                  });
                },
                onPressed2: () {
                  Get.back();
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Get.offAndToNamed("/intro");
                    goToPlaystore();
                  });
                },
                title: 'Untuk kebutuhan internal testing',
                subtitle:
                    "Saat ini Alteacare Lite sedang dalam tahap pengembangan dan testing. User dapat melakukan konsultasi lewat aplikasi AlteaCare",
                buttonTxt1: 'Saya Mengerti',
                buttonTxt2: 'Download AlteaCare App',
              ),
              onWillPop: () async {
                return false;
              },
            ),
            barrierDismissible: false,
          );

          if (_sp != null) {
            _sp!.setBool("isFirstTime", false);
          }
        } else {
          Get.dialog(
            WillPopScope(
              child: CustomSimpleDualButtonDialog(
                icon: SizedBox(),
                onPressed1: () {
                  Get.back();
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Get.offAndToNamed("/login");
                  });
                },
                onPressed2: () {
                  Get.back();
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Get.offAndToNamed("/login");
                    goToPlaystore();
                  });
                },
                title: 'Untuk kebutuhan internal testing',
                subtitle:
                    "Saat ini Alteacare Lite sedang dalam tahap pengembangan dan testing. User dapat melakukan konsultasi lewat aplikasi AlteaCare",
                buttonTxt1: 'Saya Mengerti',
                buttonTxt2: 'Download AlteaCare App',
              ),
              onWillPop: () async {
                return false;
              },
            ),
            barrierDismissible: false,
          );
        }
      } else {
        Get.dialog(
          WillPopScope(
            child: CustomSimpleDualButtonDialog(
              icon: SizedBox(),
              onPressed1: () {
                Get.back();

                Future.delayed(const Duration(milliseconds: 100), () {
                  Get.offAndToNamed("/home");
                });
              },
              onPressed2: () {
                Get.back();
                Future.delayed(const Duration(milliseconds: 100), () {
                  Get.offAndToNamed("/home");
                  goToPlaystore();
                });
              },
              title: 'Untuk kebutuhan internal testing',
              subtitle:
                  "Saat ini Alteacare Lite sedang dalam tahap pengembangan dan testing. User dapat melakukan konsultasi lewat aplikasi AlteaCare",
              buttonTxt1: 'Saya Mengerti',
              buttonTxt2: 'Download AlteaCare App',
            ),
            onWillPop: () async {
              return false;
            },
          ),
          barrierDismissible: false,
        );
      }
    }
  }

  Future<void> goToPlaystore() async {
    if (GetPlatform.isAndroid) {
      if (await canLaunch(alteaPlaystoreURL)) {
        launch(alteaPlaystoreURL);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('ONBOARDING !!!!');
    return Scaffold(
        body: Center(
      child: Image.asset(
        'assets/altea_logo.png',
        width: MediaQuery.of(context).size.width / 2,
      ),
    ));
  }
}
