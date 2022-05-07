// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/modules/doctor/controllers/doctor_controller.dart';
import '../../../controllers/home_controller.dart';
import 'navbar_section_login_desktop.dart';
import 'navbar_section_no_login_dekstop.dart';

class TopNavigationBarSection extends GetView<HomeController> {
  const TopNavigationBarSection({
    Key? key,
    required this.screenWidth,
  }) : super(key: key);
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final doctorController = Get.put(DoctorController());

    return Obx(() => Container(
          child: controller.accessTokens.value.isNotEmpty
              ? NavBarSectionLoginWidget(
                  screenWidth: screenWidth,
                )
              : NavBarSectionWidget(screenWidth: screenWidth),
        ));
  }
}
