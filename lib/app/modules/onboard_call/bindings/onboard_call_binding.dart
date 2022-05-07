// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
import '../controllers/onboard_call_controller.dart';

class OnboardCallBinding extends Bindings {
  @override
  void dependencies() {
    if (GetPlatform.isWeb) {
      final String orderId = Get.parameters.containsKey("orderId") ? Get.parameters['orderId'].toString() : "";
      // print("order ID ada ? $orderId");
      Get.lazyPut<OnboardCallController>(
        () => OnboardCallController(orderIdFromParam: orderId),
      );
      Get.lazyPut<PatientDataController>(
        () => PatientDataController(),
      );
    }
    Get.lazyPut<OnboardCallController>(
      () => OnboardCallController(),
    );
  }
}
