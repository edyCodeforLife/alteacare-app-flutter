// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/wait_ma_info_controller.dart';

class WaitMaInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WaitMaInfoController>(
      () => WaitMaInfoController(),
    );
  }
}
