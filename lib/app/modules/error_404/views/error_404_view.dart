// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import 'package:altea/app/modules/doctor-success-screen/views/mobile_web_view/mw_doctor_success_screen.dart';
import 'package:altea/app/modules/error_404/views/desktop_web_view/desktop_web_404_screen.dart';
import 'package:altea/app/modules/error_404/views/mobile_web_view/mobile_web_404_screen.dart';

class Error404View extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return MobileWeb404Screen();
        } else {
          return DesktopWeb404Screen();
        }
      });
    } else {
      return Container();
    }
  }
}
