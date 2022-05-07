// Package imports:
// Project imports:
import 'package:altea/app/modules/onboard_end_call/controllers/onboard_end_call_controller.dart';
import 'package:get/get.dart';

import '../controllers/call_screen_controller.dart';

class CallScreenBinding extends Bindings {
  @override
  void dependencies() {
    if (GetPlatform.isWeb) {
      final String orderId = Get.parameters.containsKey("orderId") ? Get.parameters['orderId'].toString() : "";
      Get.lazyPut<CallScreenController>(
        () => CallScreenController(orderIdFromParam: orderId),
      );
    }
    Get.lazyPut<CallScreenController>(
      () => CallScreenController(),
    );
    Get.lazyPut<OnboardEndCallController>(
      () => OnboardEndCallController(),
    );
  }
}
