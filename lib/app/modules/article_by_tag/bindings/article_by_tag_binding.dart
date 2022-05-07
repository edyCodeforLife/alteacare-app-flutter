// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/article_by_tag_controller.dart';

class ArticleByTagBinding extends Bindings {
  @override
  void dependencies() {
    final String tag = Get.parameters['tag'].toString();
    // print(tag.toString());
    Get.lazyPut<ArticleByTagController>(
      () => ArticleByTagController(tag: tag),
    );
  }
}
