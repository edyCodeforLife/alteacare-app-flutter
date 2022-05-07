// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import 'package:altea/app/modules/notifications/views/mobile_web_view/mw_notification_screen.dart';
import '../controllers/notifications_controller.dart';
import 'desktop_web_view/dekstop_web_notification_page.dart';
import 'mobile_app_view/notifications_mobile_view.dart';

class NotificationsView extends GetView<NotificationsController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return MWNotificationScreen();
        } else {
          return const DesktopWebNotificationPage();
        }
      });
    } else {
      return NotificationsMobileView();
    }
  }
}
