// Flutter imports:
// Project imports:
import 'package:altea/app/modules/search_spesialis/views/desktop_web_view/desktop_web_view.dart';
import 'package:altea/app/modules/search_spesialis/views/mobile_app_view/mobile_app_view.dart';
import 'package:altea/app/modules/search_spesialis/views/mobile_web_view/mobile_web_view.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../controllers/search_specialist_controller.dart';

class SearchSpecialistView extends GetView<SearchSpecialistController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return MobileWebViewSearchDoctorSpesialis();
        } else {
          return const DesktopWebViewSearchDoctorSpesialis();
        }
      });
    } else {
      return const MobileAppViewSearchDoctorSpesialis();
    }
  }
}
