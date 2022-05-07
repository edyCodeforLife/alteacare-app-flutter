// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/screen_size.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';
import 'carousel_above_section_desktop.dart';
import 'doctor_spesialis_section_dekstop.dart';
import 'floating_menu_section_desktop.dart';

class MainBannerAndDoctorSectionWidget extends GetView<HomeController> {
  const MainBannerAndDoctorSectionWidget({
    Key? key,
    required this.floatingMenus,
  }) : super(key: key);

  final List<Map<String, dynamic>> floatingMenus;

  @override
  Widget build(BuildContext context) {
    ScreenSize.recalculate(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 110.hb,
      width: 100.wb,
      child: Stack(
        children: [
          Column(
            children: [
              Column(
                children: [
                  // ? Carousel above section
                  CarouselAboveSectionWidget(screenWidth: screenWidth),
                  DoctorSpesialisSectionWidget(
                    screenWidth: screenWidth,
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 55.hb,
            left: 10.wb,
            right: 10.wb,
            child: FloatingNavigationSectionWidget(screenWidth: screenWidth, floatingMenus: floatingMenus),
          )
        ],
      ),
    );
  }
}
