// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/verif_otp_controller.dart';

class VerifOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifOtpController>(
      () => VerifOtpController(),
    );
  }
}
