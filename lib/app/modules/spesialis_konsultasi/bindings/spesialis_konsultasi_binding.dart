// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/spesialis_konsultasi_controller.dart';

class SpesialisKonsultasiBinding extends Bindings {
  @override
  void dependencies() {
    if (GetPlatform.isWeb) {
      final String doctorId = Get.parameters.containsKey('doctorId') ? Get.parameters['doctorId'].toString() : "";
      Get.lazyPut<SpesialisKonsultasiController>(
        () => SpesialisKonsultasiController(doctorIdFromParam: doctorId),
      );
    } else {
      Get.lazyPut<SpesialisKonsultasiController>(
        () => SpesialisKonsultasiController(),
      );
    }
  }
}
