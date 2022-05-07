// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/profile_settings_controller.dart';

class ProfileSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSettingsController>(
      () => ProfileSettingsController(),
    );
  }
}
