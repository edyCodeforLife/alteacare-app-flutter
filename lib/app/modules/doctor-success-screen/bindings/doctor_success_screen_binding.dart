// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/modules/call_screen/controllers/call_screen_controller.dart';
import '../controllers/doctor_success_screen_controller.dart';

class DoctorSuccessScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorSuccessScreenController>(
      () => DoctorSuccessScreenController(),
    );
    Get.lazyPut<CallScreenController>(
      () => CallScreenController(),
    );
  }
}
