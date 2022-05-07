// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/helper.dart' as helper;
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/data/model/article.dart';

class ArticleCard extends StatelessWidget {
  final DatumArticleV2 article;
  final screenWidth = Get.width;
  ArticleCard(this.article);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth * 0.21,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: screenWidth * 0.2,
            height: screenWidth * 0.1,
            child: Image.network(
              addCDNforLoadImage(article.image!),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: screenWidth * 0.01,
          ),
          Container(
            padding: const EdgeInsets.only(right: 38, left: 30, top: 7, bottom: 7),
            // padding: const EdgeInsets.symmetric(
            //     horizontal: 30, vertical: 7),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: kButtonColor.withOpacity(0.1)),
            child: Text(article.category.toString(),
                style: kPoppinsSemibold600.copyWith(
                  color: kButtonColor,
                  fontSize: 12,
                )),
          ),
          // Row(
          //     children: [article.tags![0],article.tags![1]]
          //         .map(
          //           (tag) => Padding(
          //         padding: const EdgeInsets.only(right: 8.0),
          //         child: Container(
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: 30, vertical: 7),
          //           decoration: BoxDecoration(
          //               borderRadius:
          //               BorderRadius.circular(30),
          //               color: kButtonColor.withOpacity(0.1)),
          //           child: Text(tag.toString(),
          //               style: kPoppinsSemibold600.copyWith(
          //                 color: kButtonColor,
          //                 fontSize: 12,
          //               )),
          //         ),
          //       ),
          //     )
          //         .toList()),
          SizedBox(
            height: screenWidth * 0.01,
          ),
          SizedBox(
            width: screenWidth * 0.15,
            child: Text(
              article.title!,
              style: kPoppinsSemibold600.copyWith(
                color: kBlackColor,
                fontSize: 15,
              ),
              maxLines: 2,
              overflow: TextOverflow.fade,
            ),
          ),
          SizedBox(
            height: screenWidth * 0.01,
          ),
          Text(
            helper.formattedDate(article.createdAt!),
            style: kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.57), fontSize: 13, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
