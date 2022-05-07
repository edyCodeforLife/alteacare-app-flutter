// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/profile_edit_controller.dart';

class ProfileEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileEditController>(
      () => ProfileEditController(),
    );
  }
}
