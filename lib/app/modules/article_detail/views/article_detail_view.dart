// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import 'package:altea/app/modules/article_detail/controllers/article_detail_controller.dart';
import 'package:altea/app/modules/article_detail/views/desktop_web_view/desktop_article_detail_screen.dart';
import 'package:altea/app/modules/article_detail/views/mobile_web_view/mw_article_detail_screen.dart';

class ArticleDetailView extends StatelessWidget {
  final String slug = Get.parameters['slug'].toString();
  late final ArticleDetailController controller = Get.find<ArticleDetailController>(tag: slug);
  @override
  Widget build(BuildContext context) {
    // controller.checkAndSortArticles();
    // print("slug di article detail view : $slug");

    if (GetPlatform.isWeb) {
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return MWArticleDetailScreen(
            slug: slug,
          );
        } else {
          return DesktopArticleDetailScreen(
            slug: slug,
          );
        }
      });
    } else {
      return Container();
    }
  }
}
