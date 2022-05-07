// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/add_patient_confirmed_controller.dart';

class AddPatientConfirmedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPatientConfirmedController>(
      () => AddPatientConfirmedController(),
    );
  }
}
