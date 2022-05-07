// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:responsive_builder/responsive_builder.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/data/model/article.dart';

Widget buildSmallArticleSection(double screenWidth, DatumArticle data) {
  return ResponsiveBuilder(builder: (context, sizingInformation) {
    if (sizingInformation.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: screenWidth * 0.15,
              child: Image.network(addCDNforLoadImage(data.image!), fit: BoxFit.cover),
            ),
          ),
          SizedBox(
            height: screenWidth * 0.01,
          ),
          Container(
            width: screenWidth,
            child: Text(
              data.title!,
              style: kSubHeaderStyle.copyWith(color: kBlackColor.withOpacity(0.5), fontSize: screenWidth * 0.03),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: screenWidth * 0.07,
                child: Image.network(addCDNforLoadImage(data.image!), fit: BoxFit.cover),
              ),
            ),
          ),
          SizedBox(
            width: screenWidth * 0.01,
          ),
          Container(
            width: screenWidth * 0.1,
            child: Text(
              data.title!,
              style: kSubHeaderStyle.copyWith(color: kBlackColor.withOpacity(0.5), fontSize: 18),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      );
    }
  });
}
