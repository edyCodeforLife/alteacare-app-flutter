// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/profile_privacy_controller.dart';

class ProfilePrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePrivacyController>(
      () => ProfilePrivacyController(),
    );
  }
}
