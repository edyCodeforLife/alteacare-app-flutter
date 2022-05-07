// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/patient_confirmation_controller.dart';

class PatientConfirmationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientConfirmationController>(
      () => PatientConfirmationController(),
    );
  }
}
