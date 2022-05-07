// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/add_patient_address_controller.dart';

class AddPatientAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPatientAddressController>(
      () => AddPatientAddressController(),
    );
  }
}
