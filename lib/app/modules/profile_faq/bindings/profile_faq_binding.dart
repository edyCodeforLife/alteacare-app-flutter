// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/profile_faq_controller.dart';

class ProfileFaqBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileFaqController>(
      () => ProfileFaqController(),
    );
  }
}
