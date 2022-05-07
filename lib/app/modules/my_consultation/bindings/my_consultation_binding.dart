// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/my_consultation_controller.dart';

class MyConsultationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyConsultationController>(
      () => MyConsultationController(),
    );
  }
}
