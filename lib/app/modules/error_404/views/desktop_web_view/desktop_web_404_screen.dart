// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/modules/error_404/views/widgets/not_found_content.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/footer_section_view.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

class DesktopWeb404Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    return Scaffold(
      backgroundColor: kBackground,
      body: ListView(
        children: [
          TopNavigationBarSection(screenWidth: screenWidth),
          const SizedBox(
            height: 140,
          ),
          NotFoundContent(screenWidth: screenWidth),
          SizedBox(
            height: screenWidth * 0.1,
          ),
          FooterSectionWidget(screenWidth: screenWidth)
        ],
      ),
    );
  }
}
