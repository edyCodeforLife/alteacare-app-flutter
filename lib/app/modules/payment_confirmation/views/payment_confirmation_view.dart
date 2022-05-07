// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/modules/patient_confirmation/views/mobile_app_view/mobile_app_view.dart';
import '../controllers/payment_confirmation_controller.dart';

class PaymentConfirmationView extends GetView<PaymentConfirmationController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return Container();
    } else {
      return MobileAppView();
    }
  }
}
