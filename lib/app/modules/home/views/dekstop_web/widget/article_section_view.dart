// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/article/controllers/article_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/routes/app_pages.dart';

class ArticleSectionWidget extends GetView<HomeController> {
  const ArticleSectionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articleController = Get.put(ArticleController());
    final screenWidth = MediaQuery.of(context).size.width;
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
                  articleController.menus.add("Article");
                  articleController.articleList.value = controller.listArticles;
                  articleController.dataPagination.value = controller.dataPageArticle.value;
                  Get.toNamed(
                    Routes.ARTICLE,
                  );
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
                  onTap: () {},
                  child: SizedBox(
                    width: screenWidth * 0.21,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.2,
                          height: screenWidth * 0.1,
                          child: Image.network(
                            addCDNforLoadImage(controller.listArticles[index].image!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: screenWidth * 0.01,
                        ),
                        Row(
                            children: controller.listArticles[index].tags!
                                .map(
                                  (tag) => Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 7),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: kButtonColor.withOpacity(0.1)),
                                      child: Text(tag.name!,
                                          style: kPoppinsSemibold600.copyWith(
                                            color: kButtonColor,
                                            fontSize: 12,
                                          )),
                                    ),
                                  ),
                                )
                                .toList()),
                        SizedBox(
                          height: screenWidth * 0.01,
                        ),
                        SizedBox(
                          width: screenWidth * 0.15,
                          child: Text(
                            controller.listArticles[index].title!,
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
                        Text(articleController.formattedDate(controller.listArticles[index].createdAt!),
                            style: kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.57), fontSize: 13, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
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
  }
}
