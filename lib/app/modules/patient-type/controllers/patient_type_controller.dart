// Package imports:
import 'package:get/get.dart';

class PatientTypeController extends GetxController {
  //TODO: Implement PatientTypeController

  RxString selectedPatientType = ''.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
