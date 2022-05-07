// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/modules/forgot_password/presentation/modules/forgot_password/controllers/forgot_password_controller.dart';

class ForgotVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(),
    );
  }
}
