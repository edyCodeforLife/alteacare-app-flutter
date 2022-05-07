// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';

class CustomSimpleDialog extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final String buttonTxt;
  final void Function() onPressed;

  const CustomSimpleDialog({
    required this.icon,
    required this.onPressed,
    required this.title,
    required this.buttonTxt,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    title,
                    style: kDialogTitleStyle,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      subtitle,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: kDialogSubTitleStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  CustomFlatButton(width: double.infinity, text: buttonTxt, onPressed: onPressed, color: kButtonColor),
                ],
              ),
            ),
          );
        } else {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.01),
            ),
            content: Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.55,
              decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    title,
                    style: kDialogTitleStyle,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      subtitle,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: kDialogSubTitleStyle.copyWith(fontSize: 24),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomFlatButton(width: double.infinity, text: buttonTxt, onPressed: onPressed, color: kButtonColor),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class CustomSimpleDualButtonDialog extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final String buttonTxt1;
  final String buttonTxt2;
  final void Function() onPressed1;
  final void Function() onPressed2;

  const CustomSimpleDualButtonDialog({
    required this.icon,
    required this.onPressed1,
    required this.onPressed2,
    required this.title,
    required this.buttonTxt1,
    required this.buttonTxt2,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    title,
                    style: kDialogTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    // width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      subtitle,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: kDialogSubTitleStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  CustomFlatButton(width: double.infinity, text: buttonTxt1, onPressed: onPressed1, color: kButtonColor),
                  const SizedBox(
                    height: 4,
                  ),
                  CustomFlatButton(width: double.infinity, text: buttonTxt2, onPressed: onPressed2, color: kButtonColor),
                ],
              ),
            ),
          );
        } else {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.01),
            ),
            content: Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.55,
              decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    title,
                    style: kDialogTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      subtitle,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: kDialogSubTitleStyle.copyWith(fontSize: 24),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomFlatButton(width: double.infinity, text: buttonTxt1, onPressed: onPressed1, color: kButtonColor),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomFlatButton(width: double.infinity, text: buttonTxt2, onPressed: onPressed2, color: kButtonColor),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
