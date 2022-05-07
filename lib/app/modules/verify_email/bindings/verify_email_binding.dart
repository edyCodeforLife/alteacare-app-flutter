// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/verify_email_controller.dart';

class VerifyEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyEmailController>(
      () => VerifyEmailController(),
    );
  }
}
