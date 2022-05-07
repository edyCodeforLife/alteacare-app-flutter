// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/profile_tnc_controller.dart';

class ProfileTncBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileTncController>(
      () => ProfileTncController(),
    );
  }
}
