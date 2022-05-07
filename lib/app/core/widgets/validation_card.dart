import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class ValidationCard extends StatelessWidget {
  const ValidationCard({required this.condition, required this.text});

  final bool condition;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (condition)
          Icon(
            Icons.done,
            color: kGreenColor,
          )
        else
          Icon(
            Icons.close,
            color: kRedError,
          ),
        Text(
          text,
          style: kValidationText,
        )
      ],
    );
  }
}
