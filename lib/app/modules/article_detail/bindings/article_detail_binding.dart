// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/modules/article/controllers/article_controller.dart';
import 'package:altea/app/modules/article_detail/controllers/article_detail_controller.dart';

class ArticleDetailBinding extends Bindings {
  @override
  void dependencies() {
    final String slug = Get.parameters.containsKey("slug") ? Get.parameters['slug'].toString() : "";
    if (slug.isEmpty) {
      Get.offAndToNamed("/home");
    } else {
      Get.lazyPut<ArticleDetailController>(
        () => ArticleDetailController(slug: slug),
        tag: slug,
      );
    }
  }
}
