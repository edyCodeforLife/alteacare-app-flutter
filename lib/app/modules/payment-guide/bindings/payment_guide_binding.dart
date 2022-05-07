// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/payment_guide_controller.dart';

class PaymentGuideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentGuideController>(
      () => PaymentGuideController(),
    );
  }
}
