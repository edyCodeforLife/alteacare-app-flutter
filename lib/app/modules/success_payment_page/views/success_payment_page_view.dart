// Flutter imports:
// Project imports:
import 'package:altea/app/modules/success_payment_page/controllers/success_payment_page_controller.dart';
import 'package:altea/app/modules/success_payment_page/views/mobile_app_view/mobile_app_view.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'desktop_web_view/desktop_web_view.dart';
import 'mobile_web_view/mobile_web_view.dart';

// import 'package:altea/app/modules/success_payment_page/views/mobile_app_view/mobile_app_view.dart';

class SuccessPaymentView extends GetView<SuccessPaymentPageController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          final String orderId = Get.parameters.containsKey('orderId') ? Get.parameters['orderId'].toString() : "";
          return MobileWebSuccessPaymentPage(
            appointmentId: orderId,
          );
        } else {
          return DesktopWebSuccessPaymentPage(
            appointmentId: Get.arguments != null ? Get.arguments.toString() : null,
          );
        }
      });
    } else {
      return MobileAppView();
    }
  }
}
