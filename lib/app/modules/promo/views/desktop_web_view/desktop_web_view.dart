// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/modules/home/views/dekstop_web/widget/footer_section_view.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';

class DekstopWebViewPromoDetailPage extends StatelessWidget {
  const DekstopWebViewPromoDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;

    return Scaffold(
      body: ListView(
        children: [
          TopNavigationBarSection(
            screenWidth: screenWidth,
          ),

          // TODO: do the content screen for promo dekstop web view

          SizedBox(
            height: screenWidth * 0.01,
          ),
          FooterSectionWidget(screenWidth: screenWidth)
        ],
      ),
    );
  }
}
