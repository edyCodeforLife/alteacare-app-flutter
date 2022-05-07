// Package imports:
// Project imports:
import 'package:altea/app/modules/forgot_password/presentation/modules/forgot_password/controllers/forgot_password_controller.dart';
import 'package:get/get.dart';

class ForgotNewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(),
    );
  }
}
