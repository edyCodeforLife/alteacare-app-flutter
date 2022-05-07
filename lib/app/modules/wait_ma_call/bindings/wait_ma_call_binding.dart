// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/wait_ma_call_controller.dart';

class WaitMaCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WaitMaCallController>(
      () => WaitMaCallController(),
    );
  }
}
