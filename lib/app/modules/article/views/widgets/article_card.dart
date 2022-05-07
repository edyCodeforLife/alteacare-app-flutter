// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/helper.dart' as helper;
import 'package:altea/app/core/utils/screen_size.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/data/model/article.dart';

class ArticleCard extends StatelessWidget {
  final DatumArticleV2 article;
  final screenWidth = Get.width;
  ArticleCard(this.article);

  @override
  Widget build(BuildContext context) {
    ScreenSize.recalculate(context);
    return SizedBox(
      width: 20.wb,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 18.wb,
            height: 17.hb,
            child: Image.network(
              addCDNforLoadImage(article.image!),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 1.hb,
          ),
          Container(
            padding: const EdgeInsets.only(right: 38, left: 30, top: 7, bottom: 7),
            // padding: const EdgeInsets.symmetric(
            //     horizontal: 30, vertical: 7),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: kButtonColor.withOpacity(0.1)),
            child: Text(article.category.toString(),
                style: kPoppinsSemibold600.copyWith(
                  color: kButtonColor,
                  fontSize: 0.8.wb,
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
            height: 1.hb,
          ),
          SizedBox(
            width: 15.wb,
            child: Text(
              article.title!,
              style: kPoppinsSemibold600.copyWith(
                color: kBlackColor,
                fontSize: 1.1.wb,
              ),
              maxLines: 2,
              overflow: TextOverflow.fade,
            ),
          ),
          SizedBox(
            height: 1.hb,
          ),
          Text(
            helper.formattedDate(article.createdAt!),
            style: kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.57), fontSize: 0.95.wb, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
