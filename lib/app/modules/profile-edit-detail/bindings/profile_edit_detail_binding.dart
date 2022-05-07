// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/profile_edit_detail_controller.dart';

class ProfileEditDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileEditDetailController>(
      () => ProfileEditDetailController(),
    );
  }
}
