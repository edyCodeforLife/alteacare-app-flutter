// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/data/model/article.dart';
import 'package:altea/app/modules/article/controllers/article_controller.dart';
import 'package:altea/app/modules/article/views/widgets/new_small_article_section.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/footer_section_view.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
// Package imports:
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class DesktopArticleMainScreen extends GetView<ArticleController> {
  final HomeController homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;

    return WillPopScope(
      onWillPop: () async {
        if (homeController.menus.length > 1) {
          homeController.menus.removeAt(1);
        }
        return true;
      },
      child: Scaffold(
        body: ListView(
          children: [
            TopNavigationBarSection(
              screenWidth: screenWidth,
            ),
            if (homeController.verificationBannerStatus)
              const SizedBox(
                height: 20,
              )
            else
              const SizedBox(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  // BreadCrumb.builder(
                  //   itemCount: homeController.menus.length,
                  //   builder: (index) {
                  //     // print("menus ->${controller.menus[index]}");
                  //     // print(
                  //     //     "selection dokter -> ${controller.spesialisMenus[index].name!}");
                  //     return BreadCrumbItem(
                  //       content: Text(
                  //         homeController.menus[index],
                  //       ),
                  //       onTap: index < homeController.menus.length
                  //           ? () {
                  //               // TODO: CEK LAGI NANTI YA
                  //               if (index == 0) {
                  //                 homeController.menus.removeAt(index + 1);
                  //                 Get.back();
                  //               }
                  //             }
                  //           : null,
                  //       textColor: (controller.menus[index] == ("Article"))
                  //           ? kButtonColor
                  //           : kLightGray,
                  //     );
                  //   },
                  //   divider: const Text(" / "),
                  // ),
                  SizedBox(
                    height: screenWidth * 0.01,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: SizedBox(
                          child: TypeAheadField<DatumArticleV2>(
                              hideOnLoading: true,
                              textFieldConfiguration: TextFieldConfiguration(
                                style: kPoppinsRegular400.copyWith(color: hinTextColor, fontSize: 16),
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
                                  hintStyle: kPoppinsRegular400.copyWith(color: hinTextColor, fontSize: 15),
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
                              suggestionsBoxDecoration: const SuggestionsBoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(26)), elevation: 2, color: kBackground),
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
                                    controller.searchText.value = "";

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
                                            style: kPoppinsRegular400.copyWith(fontSize: 14),
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
                    width: screenWidth * 0.8,
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
                          height: screenWidth * 0.3,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: controller.popularArticles.isEmpty
                                    ? const SizedBox()
                                    : InkWell(
                                        onTap: () {
                                          controller.getArticleDetail(controller.popularArticles[0].slug.toString());
                                          // Get.to(() => DesktopArticleDetailScreen());

                                          // Get.to(ArticleDetailView(), arguments: controller.popularArticles[0].slug.toString() );
                                          // Get.toNamed(
                                          //   "/article-detail?slug=${controller.popularArticles[0].slug.toString()}",
                                          // );
                                          // Get.back();
                                          Get.toNamed(
                                            "/article-detail/${controller.popularArticles[0].slug.toString()}",
                                          );
                                          // Get.toNamed("/article-detail", arguments: controller.popularArticles[0].slug.toString());
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(addCDNforLoadImage(controller.popularArticles[0].image!), fit: BoxFit.cover),
                                        ),
                                      ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.01,
                              ),
                              Container(
                                width: screenWidth * 0.22,
                                child: (controller.popularArticles.isEmpty)
                                    ? const SizedBox()
                                    : Column(
                                        children: [
                                          ...List.generate(
                                            4,
                                            (index) => Padding(
                                              padding: EdgeInsets.only(bottom: index != 3 ? 10.0 : 0),
                                              child: InkWell(
                                                onTap: () {
                                                  // Get.toNamed("/article-detail", arguments: controller.popularArticles[index + 1].slug.toString());
                                                  // Get.to(ArticleDetailView(), arguments: controller.popularArticles[index + 1].slug.toString() );
                                                  // Get.toNamed(
                                                  //   "/article-detail?slug=${controller.popularArticles[index + 1].slug.toString()}",
                                                  // );
                                                  // Get.back();

                                                  Get.toNamed(
                                                    "/article-detail/${controller.popularArticles[index + 1].slug.toString()}",
                                                  );

                                                  // controller.getArticleDetail(controller.popularArticles[index + 1].slug.toString());
                                                  // Get.to(()=>DesktopArticleDetailScreen(slug: controller.popularArticles[index + 1].slug.toString(),));
                                                },
                                                child: NewSmallArticleSection(
                                                  screenWidth: screenWidth,
                                                  data: controller.popularArticles[index + 1],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                              )
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
                        // SizedBox(
                        //   width: screenWidth * 0.8,
                        //   height: screenWidth * 0.5,
                        //   child: GridView.count(
                        //     crossAxisSpacing: 10,
                        //     mainAxisSpacing: 40,
                        //     crossAxisCount: 4,
                        //     physics: const NeverScrollableScrollPhysics(),
                        //     children: List.generate(
                        //       8,
                        //       (index) => Container(
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             SizedBox(
                        //               height: 150,
                        //               child: Image.network(
                        //                   addCDNforLoadImage(controller
                        //                       .listAllArticleNewAndPopular[index]
                        //                       .image!),
                        //                   fit: BoxFit.cover),
                        //             ),
                        //             SizedBox(
                        //               height: screenWidth * 0.01,
                        //             ),
                        //             Row(
                        //                 children: controller
                        //                     .listAllArticleNewAndPopular[index]
                        //                     .tags!
                        //                     .map(
                        //                       (tag) => Padding(
                        //                         padding: const EdgeInsets.only(
                        //                             right: 8.0),
                        //                         child: Container(
                        //                           padding:
                        //                               const EdgeInsets.all(8),
                        //                           decoration: BoxDecoration(
                        //                               borderRadius:
                        //                                   BorderRadius.circular(
                        //                                       16),
                        //                               color: kButtonColor
                        //                                   .withOpacity(0.2)),
                        //                           child: Text(tag.name!,
                        //                               style: kTextInputStyle
                        //                                   .copyWith(
                        //                                       color: kButtonColor,
                        //                                       fontSize: 12,
                        //                                       fontWeight:
                        //                                           FontWeight
                        //                                               .w500)),
                        //                         ),
                        //                       ),
                        //                     )
                        //                     .toList()),
                        //             SizedBox(
                        //               height: screenWidth * 0.01,
                        //             ),
                        //             SizedBox(
                        //               width: screenWidth * 0.15,
                        //               child: Text(
                        //                 controller
                        //                     .listAllArticleNewAndPopular[index]
                        //                     .title!,
                        //                 style: kTextInputStyle.copyWith(
                        //                     color: kBlackColor,
                        //                     fontSize: 15,
                        //                     fontWeight: FontWeight.w500),
                        //                 maxLines: 2,
                        //                 overflow: TextOverflow.fade,
                        //               ),
                        //             ),
                        //             SizedBox(
                        //               height: screenWidth * 0.01,
                        //             ),
                        //             Text(
                        //                 controller.formattedDate(controller
                        //                     .listAllArticleNewAndPopular[index]
                        //                     .createdAt!),
                        //                 style: kTextInputStyle.copyWith(
                        //                     color: kBlackColor.withOpacity(0.3),
                        //                     fontSize: 10,
                        //                     fontWeight: FontWeight.bold))
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
            FooterSectionWidget(screenWidth: screenWidth)
          ],
        ),
      ),
    );
  }

  // Container buildSortArticleAToZ() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 8),
  //     decoration: ShapeDecoration(
  //       shape: RoundedRectangleBorder(
  //         side: BorderSide(
  //             color: kButtonColor, width: 1.0, style: BorderStyle.solid),
  //         borderRadius: BorderRadius.circular(50),
  //       ),
  //     ),
  //     child: DropdownButton<String>(
  //       isExpanded: true,
  //       icon: Icon(
  //         Icons.arrow_drop_down_circle_rounded,
  //         color: kButtonColor,
  //       ),
  //       iconSize: 24,
  //       hint: Text(
  //         controller.hintTextSort,
  //         style: kSubHeaderStyle.copyWith(color: kButtonColor),
  //       ),
  //       elevation: 16,
  //       style: kSubHeaderStyle.copyWith(color: kButtonColor),
  //       underline: Container(),
  //       onChanged: (String? newValue) {
  //         controller.valueChoose.value = newValue!;
  //       },
  //       items: controller.sort.map<DropdownMenuItem<String>>((String value) {
  //         return DropdownMenuItem<String>(
  //           value: value,
  //           child: Row(
  //             children: [
  //               Icon(Icons.radio_button_off_outlined),
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               Text(value)
  //             ],
  //           ),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }
}
