// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/article/views/widgets/new_small_article_section.dart';
import 'package:altea/app/modules/article_by_tag/controllers/article_by_tag_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/footer_section_view.dart';
import 'package:altea/app/modules/home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:get/get.dart';

class DesktopArticleByTagMainScreen extends GetView<ArticleByTagController> {
  final HomeController homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final screenHeight = context.height;

    return Scaffold(
      body: ListView(
        children: [
          TopNavigationBarSection(
            screenWidth: screenWidth,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BreadCrumb.builder(
                  itemCount: controller.menus.length,
                  builder: (index) {
                    // print("menus ->${controller.menus[index]}");
                    // print(
                    //     "selection dokter -> ${controller.spesialisMenus[index].name!}");
                    return BreadCrumbItem(
                      content: Text(
                        controller.menus[index],
                      ),
                      onTap: index < controller.menus.length
                          ? () {
                              // TODO: CEK LAGI NANTI YA
                              if (index == 0) {
                                controller.menus.removeAt(index + 1);
                                Get.back();
                              }
                            }
                          : null,
                      textColor: (controller.menus[index] == ("Article")) ? kButtonColor : kLightGray,
                    );
                  },
                  divider: const Text(" / "),
                ),
                SizedBox(
                  height: screenWidth * 0.01,
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
                              child: InkWell(
                                onTap: () {
                                  // controller.getArticleDetail(controller.articlesFromTag[0].slug.toString());
                                  // Get.to(() => DesktopArticleDetailScreen());

                                  // Get.to(ArticleDetailView(), arguments: controller.articlesFromTag[0].slug.toString() );
                                  // Get.toNamed(
                                  //   "/article-detail?slug=${controller.articlesFromTag[0].slug.toString()}",
                                  // );
                                  // Get.back();
                                  Get.toNamed(
                                    "/article-detail/${controller.articlesFromTag[0].slug.toString()}",
                                  );
                                  // Get.toNamed("/article-detail", arguments: controller.articlesFromTag[0].slug.toString());
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(addCDNforLoadImage(controller.articlesFromTag[0].image!), fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.01,
                            ),
                            Container(
                              width: screenWidth * 0.22,
                              child: Column(
                                children: [
                                  ...List.generate(
                                    4,
                                    (index) => Padding(
                                      padding: EdgeInsets.only(bottom: index != 3 ? 10.0 : 0),
                                      child: InkWell(
                                        onTap: () {
                                          // Get.toNamed("/article-detail", arguments: controller.articlesFromTag[index + 1].slug.toString());
                                          // Get.to(ArticleDetailView(), arguments: controller.articlesFromTag[index + 1].slug.toString() );
                                          // Get.toNamed(
                                          //   "/article-detail?slug=${controller.articlesFromTag[index + 1].slug.toString()}",
                                          // );
                                          // Get.back();

                                          Get.toNamed(
                                            "/article-detail/${controller.articlesFromTag[index + 1].slug.toString()}",
                                          );

                                          // controller.getArticleDetail(controller.articlesFromTag[index + 1].slug.toString());
                                          // Get.to(()=>DesktopArticleDetailScreen(slug: controller.articlesFromTag[index + 1].slug.toString(),));
                                        },
                                        child: NewSmallArticleSection(
                                          screenWidth: screenWidth,
                                          data: controller.articlesFromTag[index + 1],
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
