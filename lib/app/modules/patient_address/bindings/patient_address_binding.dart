// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/patient_address_controller.dart';

class PatientAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientAddressController>(
      () => PatientAddressController(),
    );
  }
}
