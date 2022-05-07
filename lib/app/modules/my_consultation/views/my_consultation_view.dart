// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import 'package:altea/app/modules/my_consultation/views/mobile_app_view/consultation_mobile_view.dart';
import '../controllers/my_consultation_controller.dart';
import 'desktop_web_view/desktop_web_view.dart';
import 'mobile_web_view/mobile_web_view.dart';

class MyConsultationView extends GetView<MyConsultationController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return MobileWebMyConsultationView();
        } else {
          return DesktopWebMyConsultationView();
        }
      });
    } else {
      return ConsultationMobileView();
    }
  }
}
