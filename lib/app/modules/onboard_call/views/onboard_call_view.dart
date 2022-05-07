// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import '../controllers/onboard_call_controller.dart';
import 'desktop_web_view/desktop_web_view.dart';
import 'mobile_web_view/mobile_web_view.dart';

class OnboardCallView extends GetView<OnboardCallController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      final String orderId = Get.parameters.containsKey('orderId') ? Get.parameters['orderId'].toString() : "";
      if (orderId.isEmpty) {
        Future.delayed(Duration.zero, () {
          Get.offAndToNamed("/err_404");
        });
      } else {}
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return MobileWebOnboardCallPage(
            orderIdFromParam: orderId,
          );
        } else {
          return DesktopWebOnboardCallPage(
            orderIdFromParam: orderId,
          );
        }
      });
    } else {
      return Container();
    }
  }
}
