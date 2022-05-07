import 'package:altea/app/modules/promo/views/desktop_web_view/desktop_web_view.dart';
import 'package:altea/app/modules/promo/views/mobile_app_view/mobile_app_view.dart';
import 'package:altea/app/modules/promo/views/mobile_web_view/mobile_web_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/promo_controller.dart';

class PromoView extends GetView<PromoController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      if (GetPlatform.isMobile) {
        return MobileWebPromoDetailPage();
      } else {
        return DekstopWebViewPromoDetailPage();
      }
    } else {
      return MobileAppViewPromoDetailPage();
    }
  }
}
