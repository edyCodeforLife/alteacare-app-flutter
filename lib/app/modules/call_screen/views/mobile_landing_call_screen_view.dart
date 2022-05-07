// Flutter imports:
// Project imports:
import 'package:altea/app/modules/onboard_end_call/controllers/onboard_end_call_controller.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

import '../controllers/call_screen_controller.dart';
import 'mobile_web_view/mobile_web_call_screen.dart';

class MobileLandingCallScreen extends GetView<CallScreenController> {
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
      final String orderId = Get.parameters.containsKey('orderId') ? Get.parameters['orderId'].toString() : "";
      if (orderId.isEmpty) {
        Future.delayed(const Duration(seconds: 1), () {
          Get.offNamedUntil("/home", (route) => false);
        });
      } else {
        // controller.orderId.value = orderId;
      }
      final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;
      final String callIdFromArgs = args.containsKey('callType') ? args['callType'].toString() : "";
      return MobileWebCallScreen(
        callIdFromArgs: callIdFromArgs,
        callIdForRoom: "",
        orderIdFromParam: orderId,
        callType: callIdFromArgs,
      );
    } else {
      return Container();
    }
  }
}
