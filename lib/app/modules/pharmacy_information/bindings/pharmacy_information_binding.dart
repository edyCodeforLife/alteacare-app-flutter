import 'package:get/get.dart';

import '../controllers/pharmacy_information_controller.dart';

class PharmacyInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacyInformationController>(
      () => PharmacyInformationController(),
    );
  }
}
