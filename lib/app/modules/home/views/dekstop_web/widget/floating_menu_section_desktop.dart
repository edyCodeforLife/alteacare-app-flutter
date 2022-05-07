// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/screen_size.dart';
import 'package:altea/app/core/utils/styles.dart';

class FloatingNavigationSectionWidget extends StatelessWidget {
  const FloatingNavigationSectionWidget({
    Key? key,
    required this.screenWidth,
    required this.floatingMenus,
  }) : super(key: key);

  final double screenWidth;
  final List<Map<String, dynamic>> floatingMenus;

  @override
  Widget build(BuildContext context) {
    ScreenSize.recalculate(context);

    return Container(
      // width: 100.wb,
      height: 8.hb,
      width: 120.wb,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(56)),
      child: Row(
        children: floatingMenus
            .map(
              (data) => Expanded(
                child: InkWell(
                  onTap: () {
                    Get.toNamed(data["routes"] as String);
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 3.wb,
                        child: Image.asset(data["assetImage"] as String),
                      ),
                      SizedBox(
                        width: 1.wb,
                      ),
                      Text(
                        data["title"] as String,
                        style: kSubHeaderStyle.copyWith(
                          fontSize: 0.9.wb,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
