// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import 'package:altea/app/modules/doctor/views/dekstop_web/desktop_web_view.dart';
import 'package:altea/app/modules/doctor/views/mobile_web/mobile_web_view.dart';
import 'package:altea/app/modules/doctor_spesialis/views/mobile_app_view/mobile_app_spesialis_view.dart';
import '../controllers/doctor_controller.dart';

class DoctorView extends GetView<DoctorController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return MobileWebDoctorSpesialisCategoryView();
        } else {
          return DesktopWebDoctorSpesialisCategoryView();
        }
      });
    } else {
      return MobileAppSpesialisView();
    }
  }
}
