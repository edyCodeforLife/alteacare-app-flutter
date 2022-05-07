// Flutter imports:
// Project imports:
import 'package:altea/app/modules/onboard_end_call/controllers/onboard_end_call_controller.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../controllers/call_screen_controller.dart';
import 'desktop_web_view/desktop_web_view.dart';
import 'mobile_app_view/mobile_app_view.dart';
import 'mobile_web_view/mobile_web_call_screen.dart';

class CallScreenView extends GetView<CallScreenController> {
  final OnboardEndCallController _onboardEndCallController = Get.find<OnboardEndCallController>();
  @override
  Widget build(BuildContext context) {
    // print('call => ${ModalRoute.of(context)!.settings.arguments}');
    final String orderId = Get.parameters.containsKey('orderId') ? Get.parameters['orderId'].toString() : "";

    if (GetPlatform.isWeb) {
      if (Get.arguments == null) {
        Future.delayed(const Duration(seconds: 1), () {
          Get.offNamedUntil("/home", (route) => false);
        });
      }
      // final String orderId = Get.parameters.containsKey('orderId') ? Get.parameters['orderId'].toString() : "";

      final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;
      final String callIdFromArgs = args.containsKey('callType') ? args['callType'].toString() : "";
      // print("call id from args : $callIdFromArgs");
      if (orderId.isEmpty) {
        Future.delayed(const Duration(seconds: 1), () {
          Get.offNamedUntil("/home", (route) => false);
        });
      } else {
        // controller.orderId.value = orderId;
      }
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;
          final String callIdFromArgs = args.containsKey('callType') ? args['callType'].toString() : "";
          // print("call id from args : $callIdFromArgs");
          return MobileWebCallScreen(
            callIdFromArgs: callIdFromArgs,
            callIdForRoom: "",
            orderIdFromParam: orderId,
            callType: callIdFromArgs,
          );
        } else {
          return DesktopWebCallScreen(orderIdFromParam: orderId, callType: callIdFromArgs);
        }
      });
    } else {
      return MobileAppCallScreen(
        callId: ModalRoute.of(context)!.settings.arguments == null ? 'new' : 'doctor',
        appointmentId: orderId,
      );
    }
  }
}
