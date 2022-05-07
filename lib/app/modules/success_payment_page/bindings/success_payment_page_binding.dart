// Package imports:
// Project imports:
import 'package:altea/app/modules/choose_payment/controllers/choose_payment_controller.dart';
import 'package:altea/app/modules/patient_confirmation/controllers/patient_confirmation_controller.dart';
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
import 'package:get/get.dart';

import '../controllers/success_payment_page_controller.dart';

class SuccessPaymentPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuccessPaymentPageController>(
      () => SuccessPaymentPageController(),
    );
    if (GetPlatform.isWeb) {
      Get.lazyPut<PatientConfirmationController>(
        () => PatientConfirmationController(),
      );
      Get.lazyPut<ChoosePaymentController>(
        () => ChoosePaymentController(),
      );
      Get.lazyPut<PatientDataController>(
        () => PatientDataController(),
      );
    }
  }
}
