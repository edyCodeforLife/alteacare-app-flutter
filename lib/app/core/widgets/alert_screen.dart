import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:flutter/material.dart';

class AlertScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imgPath;
  final String btnText;
  final void Function() onPressed;

  AlertScreen({required this.title, required this.subtitle, required this.imgPath, required this.btnText, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imgPath,
              width: MediaQuery.of(context).size.width / 3,
            ),
            const SizedBox(
              height: 28,
            ),
            Text(
              title,
              style: kDialogTitleStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Text(
                subtitle,
                softWrap: true,
                style: kDialogSubTitleStyle,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            CustomFlatButton(color: kButtonColor, width: MediaQuery.of(context).size.width * 0.7, text: 'Sign In', onPressed: onPressed),
          ],
        ),
      ),
    );
  }
}
