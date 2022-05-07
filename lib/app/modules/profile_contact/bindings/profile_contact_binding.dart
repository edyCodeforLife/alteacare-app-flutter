// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/profile_contact_controller.dart';

class ProfileContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileContactController>(
      () => ProfileContactController(),
    );
  }
}
