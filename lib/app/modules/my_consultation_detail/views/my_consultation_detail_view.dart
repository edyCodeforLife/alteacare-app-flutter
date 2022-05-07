// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import 'package:altea/app/modules/my_consultation_detail/views/desktop_web_view/desktop_web_my_consultation_detail_page.dart';
import 'package:altea/app/modules/my_consultation_detail/views/mobile_app_view/consultation_detail_mobile_view.dart';
import 'package:altea/app/modules/my_consultation_detail/views/mobile_web_view/mobile_web_my_consultation_detail_page.dart';
import '../controllers/my_consultation_detail_controller.dart';

class MyConsultationDetailView extends GetView<MyConsultationDetailController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      final String orderId = Get.parameters.containsKey('orderId') ? Get.parameters['orderId'].toString() : "";
      if (orderId.isEmpty) {
        Future.delayed(Duration.zero, () {
          Get.offAndToNamed("/home");
        });
      }
      return ResponsiveBuilder(
        builder: (_, sizingInformation) {
          if (sizingInformation.isMobile) {
            return MobileWebMyConsultationDetailPage(orderIdFromParam: orderId);
          } else {
            return DesktopWebMyConsultationDetailPage(orderIdFromParam: orderId);
          }
        },
      );
    } else {
      return ConsultationDetailMobileView();
    }
  }
}
