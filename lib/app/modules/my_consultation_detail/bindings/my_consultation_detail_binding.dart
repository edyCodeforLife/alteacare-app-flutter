// Package imports:
// Project imports:
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
import 'package:get/get.dart';

import '../controllers/my_consultation_detail_controller.dart';

class MyConsultationDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (GetPlatform.isWeb) {
      // print("dapet patient param ${Get.parameters}");
      String slug = Get.parameters.containsKey('orderId') ? Get.parameters['orderId'].toString() : "";
      if (slug.isEmpty) {
        Get.offAndToNamed("/home");
      } else {
        Get.lazyPut<MyConsultationDetailController>(
          () => MyConsultationDetailController(orderIdFromArgs: slug),
        );
        Get.lazyPut<PatientDataController>(
          () => PatientDataController(),
        );
      }

      // print("dapet patient data controller");
      final MyConsultationDetailController mcdc = Get.find<MyConsultationDetailController>();
      mcdc.getDataConsultationDetailWeb02();
    } else {
      Get.lazyPut<MyConsultationDetailController>(
        () => MyConsultationDetailController(),
      );
    }
  }
}
