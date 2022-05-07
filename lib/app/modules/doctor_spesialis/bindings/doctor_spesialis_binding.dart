// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/doctor_spesialis_controller.dart';

class DoctorSpesialisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorSpesialisController>(
      () => DoctorSpesialisController(),
    );
  }
}
