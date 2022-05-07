// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
import '../controllers/patient_type_controller.dart';

class PatientTypeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientTypeController>(
      () => PatientTypeController(),
    );
    Get.lazyPut<PatientDataController>(
      () => PatientDataController(),
    );
  }
}
