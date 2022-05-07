// Flutter imports:
// Project imports:
import 'package:altea/app/modules/home/views/mobile_app/mobile_app_view.dart';
import 'package:altea/app/modules/home/views/mobile_web/home_mobile_view.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../controllers/home_controller.dart';
import 'dekstop_web/home_dekstop_web.dart';

class HomeView extends GetView<HomeController> {
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (GetPlatform.isWeb) {
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return MobileView();
        } else {
          return DesktopView(
            screenWidth: screenWidth,
            spesialisMenus: HomeController.spesialisMenus,
            floatingMenus: HomeController.floatingMenus,
          );
        }
      });
    } else {
      return MobileAppView();
    }
  }
}
