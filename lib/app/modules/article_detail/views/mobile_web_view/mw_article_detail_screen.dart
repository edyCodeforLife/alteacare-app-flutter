// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/helper.dart' as helper;
import 'package:altea/app/core/utils/settings.dart' as settings;
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/article/views/widgets/new_small_article_section.dart';
import 'package:altea/app/modules/article_detail/controllers/article_detail_controller.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/footer_mobile_web_view.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MWArticleDetailScreen extends StatelessWidget {
  final String slug;
  MWArticleDetailScreen({required this.slug}) {
    controller = Get.find<ArticleDetailController>(tag: slug);
  }
  late final ArticleDetailController controller;
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: MobileWebHamburgerMenu(),
      appBar: MobileWebMainAppbar(
        scaffoldKey: scaffoldKey,
      ),
      body: ListView(
        children: [
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
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.03,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  controller.articleDetail.title.toString(),
                                  style: kPoppinsSemibold600.copyWith(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Ditulis oleh: ",
                                            style: kPoppinsRegular400.copyWith(fontSize: 11, color: kTextHintColor),
                                          ),
                                          Text(
                                            controller.articleDetail.peninjauMateri.toString(),
                                            style: kPoppinsMedium500.copyWith(
                                              fontSize: 11,
                                              color: kDarkBlue,
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        helper.getDateAsString(
                                          controller.articleDetail.createdAt.toString(),
                                        ),
                                        style: kPoppinsRegular400.copyWith(fontSize: 11, color: kTextHintColor),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Wrap(
                                  children: controller.articleDetail.tags!
                                      .map(
                                        (tag) => InkWell(
                                          onTap: () {
                                            // print(tag.toString());
                                            // String s = tag.replaceAll(" ", "%20");
                                            // print("/article-tag/$s");
                                            // Get.toNamed("/article-tag/$s");
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
                                              style: kPoppinsRegular400.copyWith(
                                                fontSize: 11,
                                                color: kButtonColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
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

                                    //share kalo udah nemu
                                    SizedBox(
                                      width: Get.width * 0.5,
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // InkWell(
                                          //   onTap: () {
                                          //     Share.share(
                                          //       controller.slug.toString(),
                                          //     );
                                          //   },
                                          //   child: SizedBox(
                                          //     width: Get.width * 0.09,
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
                                            },
                                            child: SizedBox(
                                              width: Get.width * 0.09,
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
                                              width: Get.width * 0.09,
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
                                              width: Get.width * 0.09,
                                              child: Image.asset("assets/logo_fb.png"),
                                            ),
                                          ),
                                          // InkWell(
                                          //   onTap: () {
                                          //     Share.share(controller.slug);
                                          //   },
                                          //   child: SizedBox(
                                          //     width: Get.width * 0.09,
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
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: Get.width * 0.01,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //gambar yg paling besar
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ClipRect(
                                        child: Image.network(addCDNforLoadImage(controller.articleDetail.image.toString())),
                                      ),
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
                                    HtmlWidget(
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
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Padding(
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
                                    SizedBox(
                                      height: 160,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        separatorBuilder: (c, i) {
                                          return const Divider();
                                        },
                                        itemCount: controller.articlesFromTag.length > 4 ? 4 : controller.articlesFromTag.length,
                                        itemBuilder: (c, i) {
                                          return InkWell(
                                            onTap: () {
                                              Get.toNamed('/home/article');
                                              controller.getArticleDetail(
                                                controller.articlesFromTag[i].slug.toString(),
                                              );
                                              Get.toNamed(
                                                "/article-detail/${controller.articlesFromTag[i].slug.toString()}",
                                              );
                                              // controller.getArticleDetail(controller.articlesFromTag[i].slug.toString());
                                              // Get.to(()=>MWArticleDetailScreen());
                                            },
                                            child: NewSmallArticleSection(
                                              data: controller.articlesFromTag[i],
                                              screenWidth: Get.width,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
          ),
          FooterMobileWebView(screenWidth: Get.width),
        ],
      ),
    );
  }
}
