// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/helper.dart' as helper;
import 'package:altea/app/core/utils/settings.dart' as settings;
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/article/views/widgets/new_small_article_section.dart';
import 'package:altea/app/modules/article_detail/controllers/article_detail_controller.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/footer_section_view.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DesktopArticleDetailScreen extends StatelessWidget {
  final String slug;
  DesktopArticleDetailScreen({required this.slug}) {
    controller = Get.find<ArticleDetailController>(tag: slug);
  }
  late final ArticleDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          TopNavigationBarSection(
            screenWidth: Get.width,
          ),
          //BREADCRUMBS
          Obx(
            () => (controller.state == ArticleDetailState.loading)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : (controller.state == ArticleDetailState.error)
                    ? Center(
                        child: InkWell(
                          onTap: () {
                            controller.getArticleDetail(slug);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text("Silakan klik di sini untuk mengulang"),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
                            width: Get.width * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  controller.articleDetail.title.toString(),
                                  style: kPoppinsSemibold600.copyWith(fontSize: 26),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  width: Get.width * 0.7,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Ditulis oleh: ",
                                            style: kPoppinsRegular400.copyWith(fontSize: 14, color: kTextHintColor),
                                          ),
                                          Text(
                                            controller.articleDetail.peninjauMateri.toString(),
                                            style: kPoppinsMedium500.copyWith(
                                              fontSize: 14,
                                              color: kDarkBlue,
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        helper.getDateAsString(
                                          controller.articleDetail.createdAt.toString(),
                                        ),
                                        style: kPoppinsRegular400.copyWith(fontSize: 14, color: kTextHintColor),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                Wrap(
                                  children: controller.articleDetail.tags!
                                      .map((tag) => InkWell(
                                            onTap: () {
                                              // Get.toNamed("/article-tag/$tag");
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(right: 8),
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: const Color(0xffebf7f5),
                                              ),
                                              child: Text(
                                                tag,
                                                style: kPoppinsRegular400.copyWith(fontSize: 14, color: kButtonColor),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                //bagikan container
                                Row(
                                  children: [
                                    Text(
                                      "Bagikan : ",
                                      style: kPoppinsMedium500.copyWith(
                                        fontSize: 14,
                                        color: kDarkBlue,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    // InkWell(
                                    //   onTap: () {
                                    //     Share.share(
                                    //       controller.slug.toString(),
                                    //       subject: controller.slug.toString(),
                                    //     );
                                    //   },
                                    //   child: Container(
                                    //     padding: const EdgeInsets.symmetric(
                                    //       horizontal: 10,
                                    //       // vertical: 5,
                                    //     ),
                                    //     decoration: BoxDecoration(
                                    //       color: kDarkBlue,
                                    //       borderRadius: BorderRadius.circular(10),
                                    //     ),
                                    //     child: Text(
                                    //       "Share",
                                    //       style: kPoppinsSemibold600.copyWith(
                                    //         color: Colors.white,
                                    //         fontSize: 12,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    //instagram
                                    SizedBox(
                                      width: Get.width * 0.12,
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // InkWell(
                                          //   onTap: () {
                                          //     Share.share(controller.slug);
                                          //   },
                                          //   child: SizedBox(
                                          //     width: Get.width * 0.02,
                                          //     child: Image.asset("assets/logo_ig.png"),
                                          //   ),
                                          // ),
                                          InkWell(
                                            onTap: () async {
                                              final String thisDomain = "${settings.thisWebUrl}/article-detail/${controller.slug}";
                                              final String title = controller.articleDetail.title.toString();
                                              String url = "https://twitter.com/share?url=$thisDomain&text=$title";
                                              if (await canLaunch(url)) {
                                                launch(url);
                                              }
                                              // Share.share(controller.slug);
                                            },
                                            child: SizedBox(
                                              width: Get.width * 0.02,
                                              child: Image.asset("assets/logo_twitter.png"),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              // Share.share(controller.slug);
                                              final String thisDomain = "${settings.thisWebUrl}/article-detail/${controller.slug}";
                                              final String title = controller.articleDetail.title.toString();

                                              final String url = "https://www.linkedin.com/shareArticle?url=$thisDomain&title=$title";
                                              if (await canLaunch(url)) {
                                                launch(url);
                                              }
                                            },
                                            child: SizedBox(
                                              width: Get.width * 0.02,
                                              child: Image.asset("assets/logo_linkedin.png"),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              String thisDomain = "${settings.thisWebUrl}/article-detail/${controller.slug}";
                                              String url = "https://www.facebook.com/sharer.php?u=$thisDomain";
                                              if (await canLaunch(url)) {
                                                launch(url);
                                              }
                                            },
                                            child: SizedBox(
                                              width: Get.width * 0.02,
                                              child: Image.asset("assets/logo_fb.png"),
                                            ),
                                          ),
                                          // InkWell(
                                          //   onTap: () {
                                          //     Share.share(controller.slug);
                                          //   },
                                          //   child: SizedBox(
                                          //     width: Get.width * 0.02,
                                          //     child: Image.asset("assets/logo_youtube.png"),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.03,
                              vertical: Get.width * 0.01,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.7,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //gambar yg paling besar
                                      Container(
                                        width: Get.width * 0.7,
                                        height: 400,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  addCDNforLoadImage(controller.articleDetail.image.toString()),
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                                      //article image text
                                      Text(
                                        controller.articleDetail.imageDescription.toString(),
                                        style: kPoppinsRegular400.copyWith(fontSize: 14, color: kButtonColor),
                                      ),
                                      //container berita
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.7,
                                        child: HtmlWidget(
                                          controller.articleDetail.text.toString(),
                                          onTapImage: (v) async {
                                            if (await canLaunch(v.sources.first.url)) {
                                              launch(v.sources.first.url);
                                            }
                                          },
                                          onTapUrl: (url) async {
                                            if (await canLaunch(url)) {
                                              launch(url);
                                            }
                                          },
                                          textStyle: kPoppinsRegular400.copyWith(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Artikel Terkait",
                                          style: kPoppinsMedium500.copyWith(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Container(
                                          height: 1,
                                          color: const Color(0xffe0e5e8),
                                          width: 300,
                                          margin: const EdgeInsets.symmetric(vertical: 15),
                                        ),
                                        ListView.separated(
                                          shrinkWrap: true,
                                          separatorBuilder: (c, i) {
                                            return const Divider();
                                          },
                                          itemCount: controller.articlesFromTag.length > 4 ? 4 : controller.articlesFromTag.length,
                                          itemBuilder: (c, i) {
                                            return InkWell(
                                              onTap: () {
                                                // Get.toNamed("/article-detail", arguments: controller.articlesFromTag[i].slug.toString());
                                                // Get.to(ArticleDetailView(), arguments: controller.popularArticles[i].slug.toString() );
                                                // Get.toNamed(
                                                //     "/article-detail?slug=${controller.articlesFromTag[0].slug.toString()}",);
                                                // Get.back();
                                                // Navigator.pop(context);
                                                Get.toNamed('/home/article');
                                                controller.getArticleDetail(
                                                  controller.articlesFromTag[i].slug.toString(),
                                                );

                                                Get.toNamed(
                                                  "/article-detail/${controller.articlesFromTag[i].slug.toString()}",
                                                );
                                                // controller.getArticleDetail(controller.articlesFromTag[i].slug.toString());
                                                // Get.to(()=>DesktopArticleDetailScreen(slug: controller.articlesFromTag[i].slug.toString()));
                                              },
                                              child: NewSmallArticleSection(
                                                data: controller.articlesFromTag[i],
                                                screenWidth: Get.width,
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
          ),
          FooterSectionWidget(screenWidth: Get.width),
        ],
      ),
    );
  }
}
