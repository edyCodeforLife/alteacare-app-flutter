// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import 'package:altea/app/modules/article_by_tag/views/dekstop_view/desktop_article_by_tag_main_screen.dart';
import 'package:altea/app/modules/article_by_tag/views/mobile_web_view/mw_article_by_tag_main_screen.dart';
import '../controllers/article_by_tag_controller.dart';

class ArticleByTagView extends GetView<ArticleByTagController> {
  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return MWArticleByTagMainScreen();
        } else {
          return DesktopArticleByTagMainScreen();
        }
      });
    } else {
      return Container();
    }
  }
}
