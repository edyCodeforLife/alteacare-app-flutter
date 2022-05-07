// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/choose_payment_controller.dart';

class ChoosePaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChoosePaymentController>(
      () => ChoosePaymentController(),
    );
  }
}
