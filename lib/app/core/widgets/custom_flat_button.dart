import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CustomFlatButton extends StatelessWidget {
  final double width;
  final double? height;
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Color borderColor;
  final TextStyle? textStyle;

  const CustomFlatButton(
      {required this.width,
      required this.text,
      required this.onPressed,
      required this.color,
      this.textStyle,
      this.height,
      this.borderColor = const Color.fromRGBO(0, 0, 0, 0)});
  @override
  Widget build(BuildContext context) {
    // final screenWidth = context.width;
    return TextButton(
      onPressed: onPressed,
      child: Container(
        // padding: const EdgeInsets.all(4),
        width: width,
        height: height ?? 36,
        decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: color == kRedError ? BorderRadius.circular(8) : BorderRadius.circular(32),
            color: color),
        child: Center(
          child: GetPlatform.isWeb
              ? ResponsiveBuilder(builder: (context, sizingInformation) {
                  if (sizingInformation.isMobile) {
                    return Text(
                      text,
                      style: color == kBackground ? kButtonTextStyle2 : kButtonTextStyle.copyWith(fontSize: 12),
                    );
                  } else {
                    return Text(
                      text,
                      style: color == kBackground ? kButtonTextStyle2 : kButtonTextStyle.copyWith(fontSize: 12),
                    );
                  }
                })
              : Text(
                  text,
                  style: color == kBackground
                      ? textStyle == null
                          ? kButtonTextStyle2
                          : textStyle
                      : textStyle == null
                          ? kButtonTextStyle
                          : textStyle,
                ),
        ),
      ),
    );
  }
}
