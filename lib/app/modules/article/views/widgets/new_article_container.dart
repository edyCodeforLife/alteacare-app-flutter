// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/screen_size.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/article/controllers/article_controller.dart';
import 'package:altea/app/modules/article/views/widgets/article_card.dart';
import 'package:altea/app/routes/app_pages.dart';

class NewArticleContainer extends GetView<ArticleController> {
  final ArticleController _articleController = Get.put(ArticleController());
  final screenWidth = Get.width;
  @override
  Widget build(BuildContext context) {
    ScreenSize.recalculate(context);
    return FutureBuilder(
      future: _articleController.getPopularArticles(),
      builder: (c, data) {
        return Container(
          color: kBackground,
          height: 70.hb, //? Change the size later after put the content
          width: 120.wb,
          // width: screenWidth * 0.8,
          padding: EdgeInsets.symmetric(horizontal: 10.wb),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.hb,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Artikel Kesehatan Terbaru",
                    style: kPoppinsSemibold600.copyWith(
                      color: kBlackColor.withOpacity(0.8),
                      fontSize: 1.7.wb,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // _articleController.goToMainScreenFromHome();
                      controller.menus.value = [];

                      if (!controller.menus.contains("Article")) {
                        controller.menus.add("Beranda");
                        controller.menus.add("Article");
                      }
                      Get.toNamed(Routes.ARTICLE);
                    },
                    child: Text(
                      "Lihat Semua",
                      style: kTextInputStyle.copyWith(wordSpacing: 1, color: kDarkBlue, fontSize: 1.wb, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 1.hb,
              ),
              SizedBox(
                width: 120.wb,
                height: 40.hb,
                child: ListView.builder(
                  itemCount: _articleController.popularArticles.length < 5 ? _articleController.popularArticles.length : 5,
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
                        controller.menus.value = [];

                        if (!controller.menus.contains("Article")) {
                          controller.menus.add("Beranda");
                          controller.menus.add("Article");
                        }
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
                height: 1.hb,
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
