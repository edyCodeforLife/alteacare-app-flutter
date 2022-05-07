// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:another_flushbar/flushbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/bottom_nav_bar.dart';
import 'package:altea/app/data/model/user.dart';
import 'package:altea/app/modules/doctor/controllers/doctor_controller.dart';
import 'package:altea/app/modules/doctor/views/mobile_app/doctor_app_view.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/home/views/mobile_app/mobile_app_home_view.dart';
import 'package:altea/app/modules/my_consultation/views/mobile_app_view/consultation_mobile_view.dart';
import 'package:altea/app/modules/my_profile/views/my_profile_view.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';

class MobileAppView extends StatefulWidget {
  @override
  _MobileAppViewState createState() => _MobileAppViewState();
}

class _MobileAppViewState extends State<MobileAppView> {
  HomeController controller = Get.find<HomeController>();
  DoctorController docController = Get.put(DoctorController());

  var subscription;
  bool isDisconnected = false;

  @override
  initState() {
    super.initState();
    getUserProfile();
    // super.initState();
    // print('init state');

    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // print('result => $result');
      // Got a new connectivity status!
      // Kalau Tidak ada Koneksi
      if (result == ConnectivityResult.none) {
        isDisconnected = true;
        Flushbar(
          blockBackgroundInteraction: false,
          flushbarPosition: FlushbarPosition.TOP,
          icon: Icon(
            Icons.error_outline,
            color: kBackground,
          ),
          backgroundColor: kRedError,
          messageText: Text(
            'Tidak ada koneksi internet.',
            style: kValidationText.copyWith(color: kBackground),
          ),
          mainButton: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 15,
            ),
            onPressed: () => Get.back(),
          ),
        ).show(context);
      }
      //Kalau Koneksi sempat mati, dan sudah nyala kembali.
      if (isDisconnected && (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi)) {
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          blockBackgroundInteraction: false,
          icon: Icon(
            Icons.error_outline,
            color: kBackground,
          ),
          backgroundColor: kPaleGreen,
          messageText: Text(
            'Koneksi terhubung kembali',
            style: kValidationText.copyWith(color: kBackground),
          ),
          mainButton: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 15,
            ),
            onPressed: () => Get.back(),
          ),
        ).show(context);
      }
    });
  }

  Future getUserProfile() async {
    User user = await controller.getUserProfile();
    // print('user profile => ${user.message}');
    if (user.message == 'Missing or wrong Authorization request header') {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: CustomSimpleDialog(
                    icon: ImageIcon(
                      AssetImage('assets/group-5.png'),
                      color: kRedError,
                      size: 100,
                    ),
                    onPressed: () {
                      Get.offAndToNamed('/login');
                    },
                    title: 'Maaf',
                    buttonTxt: 'Login',
                    subtitle: 'Harap Login Kembali'),
              ));
    } else if (user.data == null) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: CustomSimpleDialog(
                  icon: ImageIcon(
                    AssetImage('assets/group-5.png'),
                    color: kRedError,
                    size: 100,
                  ),
                  onPressed: () {
                    Get.offAndToNamed('/login');
                  },
                  title: 'Maaf',
                  buttonTxt: 'Login',
                  subtitle: 'Harap Login Kembali')));
    } else if (user.data!.isVerifiedEmail == false) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        blockBackgroundInteraction: false,
        duration: Duration(seconds: 10),
        icon: Icon(
          Icons.error_outline,
          color: kBackground,
        ),
        backgroundColor: kMidnightBlue,
        messageText: Text(
          'Verifikasi Email',
          style: kValidationText.copyWith(color: kBackground),
        ),
        mainButton: Row(
          children: [
            InkWell(
              onTap: () => Get.toNamed('/verify'),
              child: Container(
                decoration:
                    BoxDecoration(color: kMidnightBlue, borderRadius: BorderRadius.circular(8), border: Border.all(color: kBackground, width: 1)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Verifikasi',
                  style: kValidationText.copyWith(color: kBackground),
                ),
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 15,
              ),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ).show(context);
    }
  }

// Be sure to cancel subscription after you are done
  @override
  dispose() {
    super.dispose();

    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: kBackground,
          appBar: controller.currentIdx.value == 0
              ? AppBar(
                  leading: Container(),
                  elevation: 0,
                  backgroundColor: kWhiteGray,
                  centerTitle: false,
                  title: Container(
                    child: Transform(
                      transform: Matrix4.translationValues(-50.0, 0.0, 0.0),
                      child: Image.asset(
                        'assets/altea_logo.png',
                        width: MediaQuery.of(context).size.width / 3.5,
                      ),
                    ),
                  ),
                  actions: [
                    Container(
                      padding: EdgeInsets.only(right: 8),
                      child: InkWell(
                          onTap: () {
                            Get.toNamed('/notifications');
                          },
                          child: Image.asset(
                            'assets/group-2.png',
                          )),
                    )
                  ],
                )
              : AppBar(
                  elevation: 2,
                  title: Text(
                    controller.currentIdx.value == 1
                        ? 'Spesialis'
                        : controller.currentIdx.value == 2
                            ? 'Konsultasi Saya'
                            : controller.currentIdx.value == 3
                                ? 'Akun'
                                : ' ',
                    style: kAppBarTitleStyle,
                  ),
                  centerTitle: true,
                  backgroundColor: kBackground,
                  leading: Container(),
                ),
          body: buildBodyScreen(controller.currentIdx.value),
          bottomNavigationBar: BottomNavBar(),
        ),
      );
    });
  }
}

Widget buildBodyScreen(int idx) {
  switch (idx) {
    case 0:
      return MobileAppHomeView();
    case 1:
      return DoctorAppView();
    case 2:
      return ConsultationMobileView();
    case 3:
      return MyProfileView();
    default:
      return Container();
  }
}
