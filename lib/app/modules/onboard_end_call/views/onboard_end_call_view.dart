// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/onboard_end_call_controller.dart';
import 'dekstop_web_view/dekstop_web_view.dart';
import 'mobile_app_view/mobile_app_view.dart';
import 'mobile_web_view/mobile_web_view.dart';

class OnboardEndCallView extends GetView<OnboardEndCallController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      final String orderId = Get.parameters.containsKey('orderId') ? Get.parameters['orderId'].toString() : "";
      if (orderId.isEmpty) {
        Future.delayed(Duration.zero, () {
          Get.offAndToNamed("/err_404");
        });
      } else {}
      if (GetPlatform.isMobile) {
        return MobileWebOnboardEndCallPage(
          orderId: orderId,
        );
      } else {
        return DesktopWebOnboardEndCallPage(
          orderId: orderId,
        );
      }
    } else {
      return MobileAppView();
    }
  }
}
