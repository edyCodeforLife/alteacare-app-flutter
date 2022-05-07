import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../controllers/payment_guide_controller.dart';
import 'desktop_web_view/desktop_web_view.dart';
import 'mobile_app_view/mobile_app_view.dart';
import 'mobile_web_view/mobile_web_view.dart';

class PaymentGuideView extends GetView<PaymentGuideController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return MobileWebPaymentGuidePage();
        } else {
          return DesktopWebPaymentGuidePage();
        }
      });
    } else {
      return MobileAppView();
    }
  }
}
