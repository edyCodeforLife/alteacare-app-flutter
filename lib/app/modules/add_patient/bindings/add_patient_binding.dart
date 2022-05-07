// Package imports:
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import 'package:get/get.dart';

// Project imports:
import '../controllers/add_patient_controller.dart';

class AddPatientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPatientController>(
      () => AddPatientController(),
    );
    Get.lazyPut<SpesialisKonsultasiController>(
      () => SpesialisKonsultasiController(),
    );
  }
}
