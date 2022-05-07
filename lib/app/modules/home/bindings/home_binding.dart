// Package imports:
// Project imports:
import 'package:altea/app/modules/doctor/controllers/doctor_controller.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<DoctorController>(() => DoctorController(), fenix: true);
  }
}
