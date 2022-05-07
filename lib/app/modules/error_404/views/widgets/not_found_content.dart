// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class NotFoundContent extends StatelessWidget {
  const NotFoundContent({
    Key? key,
    required this.screenWidth,
  }) : super(key: key);

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "assets/404.png",
          width: screenWidth * 0.1,
          height: screenWidth * 0.1,
        ),
        const SizedBox(
          height: 18,
        ),
        Center(
          child: Text(
            "Not Found",
            style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 22),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            "The resource requested could not be found in this server ",
            style: kPoppinsRegular400.copyWith(color: kTextHintColor),
          ),
        ),
      ],
    );
  }
}
