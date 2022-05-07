// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/patient_list_controller.dart';

class PatientListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientListController>(
      () => PatientListController(),
    );
  }
}
