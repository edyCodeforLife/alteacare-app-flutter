// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/doctor_controller.dart';

class DoctorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorController>(
      () => DoctorController(),
    );
  }
}
