// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import 'package:altea/app/modules/doctor_spesialis/views/desktop_web_view/dekstop_web_view.dart';
import 'package:altea/app/modules/doctor_spesialis/views/mobile_app_view/mobile_app_view.dart';
import 'package:altea/app/modules/doctor_spesialis/views/mobile_web_view/mobile_web_view.dart';
import '../controllers/doctor_spesialis_controller.dart';

class DoctorSpesialisView extends GetView<DoctorSpesialisController> {
  var args = Get.arguments;
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return const DoctorSpesialisByCategoryMobileWeb();
        } else {
          return DoctorSpesialisByCategoryDesktop();
        }
      });
    } else {
      return DoctorSpesialisByCategoryMobileApp(
        selectedId: (args == null)
            ? ""
            : (args is String || args is int)
                ? args.toString()
                : args.specializationId.toString(),
      );
    }
  }
}
