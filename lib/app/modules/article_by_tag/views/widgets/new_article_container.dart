// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/article/controllers/article_controller.dart';
import 'package:altea/app/modules/article/views/widgets/article_card.dart';
import 'package:altea/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';

class NewArticleContainer extends GetView<ArticleController> {
  final ArticleController _articleController = Get.put(ArticleController());
  final screenWidth = Get.width;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _articleController.getPopularArticles(),
      builder: (c, data) {
        return Container(
          color: kBackground,
          height: screenWidth * 0.35, //? Change the size later after put the content

          // width: screenWidth * 0.8,
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenWidth * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Artikel Kesehatan Terbaru",
                    style: kPoppinsSemibold600.copyWith(
                      color: kBlackColor.withOpacity(0.8),
                      fontSize: 22,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _articleController.goToMainScreenFromHome();
                      Get.toNamed(Routes.ARTICLE);
                    },
                    child: Text(
                      "Lihat Semua",
                      style: kTextInputStyle.copyWith(wordSpacing: 1, color: kDarkBlue, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: screenWidth * 0.01,
              ),
              Container(
                width: screenWidth * 0.8,
                height: screenWidth * 0.23,
                child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        // // controller.getArticleDetail(_articleController.popularArticles[index].slug.toString());
                        // Get.toNamed(
                        //   "/article-detail?slug=${_articleController.articlesFromSearch[index].slug.toString()}",
                        //   arguments: _articleController.popularArticles[index].slug.toString(),
                        // );
                        // Get.back();
                        Get.toNamed(
                          "/article-detail/${_articleController.popularArticles[index].slug.toString()}",
                        );
                        // Get.to(()=>ArticleDetailView(), arguments: _articleController.popularArticles[index].slug.toString() );
                      },
                      child: ArticleCard(_articleController.popularArticles[index]),
                    );
                  },
                ),
              ),
              SizedBox(
                height: screenWidth * 0.01,
              ),
              // const Divider(),
              // SizedBox(
              //   height: screenWidth * 0.01,
              // ),

              // TODO: Uncomment later
              // Text("Sample bodytext SEO Altecare",
              //     style: kTextInputStyle.copyWith(
              //         color: kBlackColor,
              //         fontSize: 24,
              //         fontWeight: FontWeight.w500)),
              // SizedBox(
              //   height: screenWidth * 0.01,
              // ),
              // Text(
              //     "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
              //     style: kTextInputStyle.copyWith(
              //         color: kBlackColor.withOpacity(0.3),
              //         fontSize: 14,
              //         fontWeight: FontWeight.bold)),
              // SizedBox(
              //   height: screenWidth * 0.01,
              // ),
              // Text(
              //     "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
              //     style: kTextInputStyle.copyWith(
              //         color: kBlackColor.withOpacity(0.3),
              //         fontSize: 14,
              //         fontWeight: FontWeight.bold)),
              // SizedBox(
              //   height: screenWidth * 0.04,
              // ),
            ],
          ),
        );
      },
    );
  }
}
