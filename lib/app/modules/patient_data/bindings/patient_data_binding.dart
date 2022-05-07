// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/patient_data_controller.dart';

class PatientDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientDataController>(
      () => PatientDataController(),
    );
  }
}
