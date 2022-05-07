// Package imports:
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  //TODO: Implement OnBoardingController

  final count = 0.obs;
  @override
  void onInit() {
    // print('inittt');
    super.onInit();
    // print('on init onboarding');

    // if (GetPlatform.isWeb) {
    //   Get.toNamed('/home');
    // } else {
    //   Get.toNamed('/login');
    // }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
