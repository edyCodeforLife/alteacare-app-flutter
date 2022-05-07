// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import '../controllers/my_profile_controller.dart';
import 'desktop_web_view/desktop_web_view.dart';
import 'mobile_app_view/profile_mobile_app_view.dart';
import 'mobile_web_view/mobile_web_view.dart';

class MyProfileView extends GetView<MyProfileController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return MobileWebMyProfileView();
        } else {
          return DesktopWebMyProfileView();
        }
      });
    } else {
      return ProfileMobileAppView();
    }
  }
}
