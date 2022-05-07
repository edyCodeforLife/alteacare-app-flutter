// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/article/controllers/article_controller.dart';
import 'package:altea/app/modules/article/views/widgets/search_article_text_field.dart';
import 'package:altea/app/modules/article/views/widgets/small_article_section.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/footer_mobile_web_view.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';

class MobileWebViewArticle extends GetView<ArticleController> {
  const MobileWebViewArticle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      appBar: MobileWebMainAppbar(
        scaffoldKey: scaffoldKey,
      ),
      drawer: MobileWebHamburgerMenu(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BreadCrumb.builder(
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
          ),
          SizedBox(
            height: screenWidth * 0.05,
          ),
          SizedBox(
            width: screenWidth,
            height: screenWidth * 0.1,
            child: buildSearchArticleTextField(),
          ),
          SizedBox(
            height: screenWidth * 0.01,
          ),
          // Article Populer section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
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
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(image: NetworkImage(controller.listPopularArticle[0].image!), fit: BoxFit.cover)),
                    ),
                  ),
                  SizedBox(
                    height: screenWidth * 0.01,
                  ),
                  Container(
                    width: screenWidth,
                    height: screenWidth * 0.3,
                    child: ListView.builder(
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            height: screenWidth * 0.25,
                            width: screenWidth * 0.25,
                            child: buildSmallArticleSection(screenWidth, controller.listPopularArticle[index + 1]),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),

          SizedBox(
            height: screenWidth * 0.02,
          ),
          // Article Populer section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: screenWidth,
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
                  SizedBox(
                    width: screenWidth,
                    height: screenWidth * 2,
                    child: GridView.count(
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: List.generate(
                        8,
                        (index) => Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: screenWidth * 0.25,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(controller.listAllArticleNewAndPopular[index].image!), fit: BoxFit.cover)),
                              ),
                              SizedBox(
                                height: screenWidth * 0.01,
                              ),
                              Row(
                                  children: controller.listAllArticleNewAndPopular[index].tags!
                                      .map(
                                        (tag) => Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Container(
                                            height: screenWidth * 0.05,
                                            padding: EdgeInsets.symmetric(horizontal: 4),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: kButtonColor.withOpacity(0.2)),
                                            child: Text(tag.name!,
                                                style: kTextInputStyle.copyWith(
                                                    color: kButtonColor, fontSize: screenWidth * 0.02, fontWeight: FontWeight.w500)),
                                          ),
                                        ),
                                      )
                                      .toList()),
                              SizedBox(
                                height: screenWidth * 0.01,
                              ),
                              SizedBox(
                                width: screenWidth,
                                child: Text(
                                  controller.listAllArticleNewAndPopular[index].title!,
                                  style: kTextInputStyle.copyWith(color: kBlackColor, fontSize: screenWidth * 0.03, fontWeight: FontWeight.w500),
                                  maxLines: 2,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              SizedBox(
                                height: screenWidth * 0.01,
                              ),
                              Text(controller.formattedDate(controller.listAllArticleNewAndPopular[index].createdAt!),
                                  style: kTextInputStyle.copyWith(
                                      color: kBlackColor.withOpacity(0.3), fontSize: screenWidth * 0.02, fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                    ),
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
