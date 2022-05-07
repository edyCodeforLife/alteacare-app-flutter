// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import 'package:altea/app/modules/spesialis_konsultasi/views/mobile_app_view/mobile_app_view.dart';
import 'package:altea/app/modules/spesialis_konsultasi/views/mobile_web_view/mobile_web_view.dart';
import '../controllers/spesialis_konsultasi_controller.dart';
import 'desktop_web_view/desktop_web_view.dart';

class SpesialisKonsultasiView extends GetView<SpesialisKonsultasiController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return MobileWebViewSpesialisKonsultasiPage();
        } else {
          return DesktopViewSpesialisKonsultasiPage();
        }
      });
    } else {
      return MobileAppViewSpesialisKonsultasiPage();
    }
  }
}
