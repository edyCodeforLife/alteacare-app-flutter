import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../controllers/pharmacy_information_controller.dart';
import 'dekstop_web_view/desktop_web_view.dart';
import 'mobile_app_view/mobile_app_view.dart';
import 'mobile_web_view/mobile_web_view.dart';

class PharmacyInformationView extends GetView<PharmacyInformationController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return MobileWebPharmacyInformationPage();
        } else {
          return DekstopWebPharmacyInformationPage();
        }
      });
    } else {
      return MobileAppPharmacyInformationPage();
    }
  }
}
