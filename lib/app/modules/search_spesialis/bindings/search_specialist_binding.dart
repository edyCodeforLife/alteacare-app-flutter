// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/search_specialist_controller.dart';

class SearchSpecialistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchSpecialistController>(
      () => SearchSpecialistController(),
    );
  }
}
