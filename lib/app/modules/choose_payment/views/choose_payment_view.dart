// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import '../controllers/choose_payment_controller.dart';
import 'dekstop_web_view/dekstop_web_view.dart';
import 'mobile_app_view/mobile_app_view.dart';
import 'mobile_web_view/mobile_web_view.dart';

class ChoosePaymentView extends GetView<ChoosePaymentController> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChoosePaymentController());
    if (GetPlatform.isWeb) {
      final orderId = Get.parameters.containsKey('orderId') ? Get.parameters['orderId'].toString() : "";
      if (orderId.isEmpty) {
        Future.delayed(Duration.zero, () {
          Get.offAndToNamed("/err_404");
        });
      }
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return MobileWebChoosePaymentView(
            appointmentId: orderId,
          );
        } else {
          return DesktopWebChoosePaymentView(
            appointmentId: orderId,
          );
        }
      });
    } else {
      return MobileAppView();
    }
  }
}
