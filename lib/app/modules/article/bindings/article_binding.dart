// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/article_controller.dart';

class ArticleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArticleController>(
      () => ArticleController(),
    );
  }
}
