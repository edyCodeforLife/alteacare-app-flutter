// Package imports:
import 'package:altea/app/modules/onboard_call/controllers/onboard_call_controller.dart';
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
import 'package:get/get.dart';

import '../controllers/onboard_end_call_controller.dart';

class OnboardEndCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardEndCallController>(
      () => OnboardEndCallController(),
    );
    if (GetPlatform.isWeb) {
      final String orderId = Get.parameters.containsKey('orderId') ? Get.parameters['orderId'].toString() : "";
      if (orderId.isEmpty) {
        Future.delayed(Duration.zero, () {
          Get.offAndToNamed("/home");
        });
      } else {
        Get.lazyPut<OnboardCallController>(
          () => OnboardCallController(orderIdFromParam: orderId),
        );
        Get.lazyPut<PatientDataController>(
          () => PatientDataController(),
        );
      }
    }
  }
}
