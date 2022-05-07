import 'package:get/get.dart';

import '../controllers/reconnect_call_view_controller.dart';

class ReconnectCallViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReconnectCallViewController>(
      () => ReconnectCallViewController(),
    );
  }
}
