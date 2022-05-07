// Flutter imports:
// Project imports:
import 'package:altea/app/modules/doctor-success-screen/views/mobile_web_view/mw_doctor_success_screen.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../controllers/doctor_success_screen_controller.dart';
import 'desktop_web_view/desktop_web_view.dart';
import 'mobile_app_view/mobile_end_call_doctor_view.dart';

class DoctorSuccessScreenView extends GetView<DoctorSuccessScreenController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return MWDoctorSuccessScreen(
            elapsedTime: "${Get.arguments['elapsedTime']}",
            orderId: "${Get.arguments['orderId']}",
          );
        } else {
          return DesktopWebDoctorSuccessScreen(
            elapsedTime: "${Get.arguments['elapsedTime']}",
            orderId: "${Get.arguments['orderId']}",
          );
        }
      });
    } else {
      return MobileEndCallDoctorView();
    }
  }
}
