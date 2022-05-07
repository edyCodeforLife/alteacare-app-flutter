// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import 'package:altea/app/modules/article/views/dekstop_view/desktop_article_main_screen.dart';
import 'package:altea/app/modules/article/views/mobile_app_view/mobile_app_view.dart';
import 'package:altea/app/modules/article/views/mobile_web_view/mw_article_main_screen.dart';
import '../controllers/article_controller.dart';

class ArticleView extends GetView<ArticleController> {
  @override
  Widget build(BuildContext context) {
    // controller.checkAndSortArticles();

    if (GetPlatform.isWeb) {
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return MWArticleMainScreen();
        } else {
          return DesktopArticleMainScreen();
        }
      });
    } else {
      return MobileAppViewArticle();
    }
  }
}
