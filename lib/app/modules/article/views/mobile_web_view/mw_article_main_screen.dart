// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/data/model/article.dart';
import 'package:altea/app/modules/article/controllers/article_controller.dart';
import 'package:altea/app/modules/article/views/widgets/new_small_article_section.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/footer_mobile_web_view.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
// Package imports:
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class MWArticleMainScreen extends GetView<ArticleController> {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;

    return Scaffold(
      appBar: MobileWebMainAppbar(
        scaffoldKey: scaffoldKey,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BreadCrumb.builder(
                //   itemCount: controller.menus.length,
                //   builder: (index) {
                //     // print("menus ->${controller.menus[index]}");
                //     // print(
                //     //     "selection dokter -> ${controller.spesialisMenus[index].name!}");
                //     return BreadCrumbItem(
                //       content: Text(
                //         controller.menus[index],
                //       ),
                //       onTap: index < controller.menus.length
                //           ? () {
                //               if (index == 0) {
                //                 controller.menus.removeAt(index + 1);
                //                 Get.back();
                //               }
                //             }
                //           : null,
                //       textColor: (controller.menus[index] == ("Article")) ? kButtonColor : kLightGray,
                //     );
                //   },
                //   divider: const Text(" / "),
                // ),
                SizedBox(
                  height: screenWidth * 0.03,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        child: TypeAheadField<DatumArticleV2>(
                            hideOnLoading: true,
                            textFieldConfiguration: TextFieldConfiguration(
                              style: kPoppinsRegular400.copyWith(color: hinTextColor, fontSize: 12),
                              decoration: InputDecoration(
                                prefix: const SizedBox(
                                  width: 10,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(26),
                                  borderSide: BorderSide(
                                    color: searchBarBorderColor.withOpacity(0.7),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(26),
                                  borderSide: BorderSide(
                                    color: searchBarBorderColor.withOpacity(0.1),
                                  ),
                                ),
                                hintText: "Search…",
                                hintStyle: kPoppinsRegular400.copyWith(color: hinTextColor, fontSize: 12),
                                suffixIcon: const Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: Icon(
                                    Icons.search,
                                    size: 22,
                                  ),
                                ),
                                isDense: true,
                              ),
                            ),
                            suggestionsBoxVerticalOffset: 0,
                            suggestionsBoxDecoration:
                                const SuggestionsBoxDecoration(borderRadius: BorderRadius.all(Radius.circular(26)), elevation: 2, color: kBackground),
                            suggestionsCallback: (pattern) async {
                              controller.searchText.value = pattern;
                              final List<DatumArticleV2> res = await controller.getArticlesFromSearch(tag: pattern);
                              return res.map((e) => e);
                            },
                            noItemsFoundBuilder: (context) {
                              return SizedBox(
                                height: 80,
                                child: Center(child: Text("Tidak menemukan artikel", style: kPoppinsMedium500.copyWith(color: hinTextColor))),
                              );
                            },
                            itemBuilder: (_, DatumArticleV2 suggestion) {
                              return InkWell(
                                onTap: () {
                                  if (homeController.menus.isNotEmpty) {
                                    homeController.menus.value = <String>[];
                                    homeController.menus.add("Artikel");
                                  } else {
                                    homeController.menus.add("Artikel");
                                  }

                                  homeController.menus.add(suggestion.title.toString());
                                  // Get.back();
                                  Get.toNamed(
                                    "/article-detail/${suggestion.slug}",
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        height: Get.width * 0.05,
                                        width: Get.width * 0.05,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                          image: NetworkImage(suggestion.image.toString()),
                                        )),
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          suggestion.title.toString(),
                                          style: kPoppinsRegular400.copyWith(fontSize: 10),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            onSuggestionSelected: (suggestion) async {}),
                        // buildSearchArticleTextField(),
                      ),
                    ),
                    // SizedBox(
                    //   width: screenWidth * 0.01,
                    // ),
                    // Expanded(
                    //   child: buildSortDoctorField(),
                    // )
                  ],
                ),
                SizedBox(
                  height: screenWidth * 0.01,
                ),

                // Article Populer section
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Artikel Populer",
                        style: kSubHeaderStyle.copyWith(color: kBlackColor.withOpacity(0.8), fontSize: 20),
                      ),
                      SizedBox(
                        height: screenWidth * 0.01,
                      ),
                      SizedBox(
                        // height: screenWidth * 0.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                // Get.back();
                                Get.toNamed(
                                  "/article-detail/${controller.popularArticles[0].slug.toString()}",
                                );
                              },
                              child: Container(
                                height: 300,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(addCDNforLoadImage(controller.popularArticles[0].image!), fit: BoxFit.cover)),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 150,
                              child: ListView.builder(
                                itemCount: controller.popularArticles.length > 5 ? 4 : controller.popularArticles.length - 1,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (c, i) {
                                  return InkWell(
                                    onTap: () {
                                      // Get.back();
                                      Get.toNamed(
                                        "/article-detail/${controller.popularArticles[i + 1].slug.toString()}",
                                      );
                                      // controller.getArticleDetail(controller.popularArticles[i + 1].slug.toString());
                                      // Get.to(() => MWArticleDetailScreen());
                                    },
                                    child: NewSmallArticleSection(
                                      screenWidth: screenWidth,
                                      data: controller.popularArticles[i + 1],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenWidth * 0.025,
                ),
                // Article Populer section
                Container(
                  width: screenWidth * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Artikel Kesehatan Terbaru",
                        style: kSubHeaderStyle.copyWith(color: kBlackColor.withOpacity(0.8), fontSize: 20),
                      ),
                      SizedBox(
                        height: screenWidth * 0.01,
                      ),
                      if (controller.dataPagination.value.totalPage == 1)
                        Center(
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: kDarkBlue)),
                            child: Center(
                              child: Text(
                                controller.dataPagination.value.page.toString(),
                                style: kSubHeaderStyle.copyWith(color: kDarkBlue),
                              ),
                            ),
                          ),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.chevron_left_rounded,
                                  color: kDarkBlue,
                                )),
                            Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: kDarkBlue)),
                                  child: Center(
                                    child: Text(
                                      "1",
                                      style: kSubHeaderStyle.copyWith(color: kDarkBlue),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: kDarkBlue)),
                                  child: Center(
                                    child: Text(
                                      "2",
                                      style: kSubHeaderStyle.copyWith(color: kDarkBlue),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: kDarkBlue)),
                                  child: Center(
                                    child: Text(
                                      "3",
                                      style: kSubHeaderStyle.copyWith(color: kDarkBlue),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.chevron_right_rounded,
                                  color: kDarkBlue,
                                )),
                          ],
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenWidth * 0.01,
          ),
          FooterMobileWebView(screenWidth: screenWidth)
        ],
      ),
    );
  }
}
