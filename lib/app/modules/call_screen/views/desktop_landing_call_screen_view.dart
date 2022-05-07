// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:

import 'package:altea/app/modules/onboard_end_call/controllers/onboard_end_call_controller.dart';
import '../controllers/call_screen_controller.dart';
import 'desktop_web_view/desktop_web_view.dart';

class DesktopLandingCallScreen extends GetView<CallScreenController> {
  final OnboardEndCallController _onboardEndCallController = Get.find<OnboardEndCallController>();
  @override
  Widget build(BuildContext context) {
    // print('call => ${ModalRoute.of(context)!.settings.arguments}');

    if (GetPlatform.isWeb) {
      if (Get.arguments == null) {
        Future.delayed(const Duration(seconds: 1), () {
          Get.offNamedUntil("/home", (route) => false);
        });
      }

      final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;
      final String callIdFromArgs = args.containsKey('callType') ? args['callType'].toString() : "";
      // print("call id from args : $callIdFromArgs");
      final String orderId = Get.parameters.containsKey('orderId') ? Get.parameters['orderId'].toString() : "";
      final String callType = Get.parameters.containsKey('callType') ? Get.parameters['callType'].toString() : "";

      if (orderId.isEmpty) {
        Future.delayed(const Duration(seconds: 1), () {
          Get.offNamedUntil("/home", (route) => false);
        });
      } else {
        // controller.orderId.value = orderId;
      }
      return DesktopWebCallScreen(
        orderIdFromParam: orderId,
        callType: callType.isNotEmpty ? callType : callIdFromArgs,
      );
    } else {
      return Container();
    }
  }
}
