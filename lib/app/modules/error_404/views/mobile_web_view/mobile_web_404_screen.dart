// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/modules/error_404/views/widgets/not_found_content.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/footer_section_view.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/footer_mobile_web_view.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';

// import 'package:altea/app/core/utils/colors.dart';
// import 'package:get/get.dart';

class MobileWeb404Screen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: MobileWebMainAppbar(
        scaffoldKey: scaffoldKey,
      ),
      drawer: MobileWebHamburgerMenu(),
      backgroundColor: kBackground,
      body: ListView(
        children: [
          const SizedBox(
            height: 140,
          ),
          NotFoundContent(screenWidth: MediaQuery.of(context).size.width),
          const SizedBox(
            height: 50,
          ),
          FooterMobileWebView(screenWidth: MediaQuery.of(context).size.width)
        ],
      ),
    );
  }
}
