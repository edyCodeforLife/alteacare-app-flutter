// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/modules/article_detail/views/mobile_web_view/mw_article_detail_screen.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/demo_try_filepicker.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_home_spesialis_container.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/widgets/custom_flat_button.dart';
import '../../../../routes/app_pages.dart';
import '../../../article/controllers/article_controller.dart';
import '../../../doctor/controllers/doctor_controller.dart';
import '../../controllers/home_controller.dart';
import 'mobile_web_hamburger_menu.dart';
import 'widgets/build_mobile_spesialis_menu.dart';
import 'widgets/footer_mobile_web_view.dart';
import 'widgets/mobile_banner.dart';
import 'widgets/mobile_promo.dart';

class MobileView extends GetView<HomeController> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>(
    debugLabel: "drawer di home webview",
  );

  DoctorController doctorController = Get.put(DoctorController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(
      () => Scaffold(
        key: scaffoldKey,
        backgroundColor: kBackground,
        appBar: MobileWebMainAppbar(
          scaffoldKey: scaffoldKey,
        ),
        drawer: MobileWebHamburgerMenu(),
        body: controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  Column(
                    children: [
                      const MobileBanner(),
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            color: kWhiteGray,
                            padding: const EdgeInsets.only(
                              top: 90,
                              left: 24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MobileWebHomeSpesialisContainer(),
                                const SizedBox(
                                  height: 15,
                                ),
                                MobilePromo(),
                                const SizedBox(
                                  height: 48,
                                ),
                                buildMobileDownload(context, screenWidth),
                              ],
                            ),
                          ),
                          buildMobileFloatingMenu(context),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      HomeWebMobileArticleContainer(screenWidth: screenWidth),
                      FooterMobileWebView(screenWidth: screenWidth),
                    ],
                  )
                ],
              ),
      ),
    );
  }

  Container buildMobileArticle(double screenWidth) {
    final articleController = Get.put(ArticleController());

    return Container(
      color: kBackground,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: screenWidth * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Artikel Kesehatan Terbaru",
                style: kHomeSubHeaderStyle,
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
                  style: kHomeSmallText.copyWith(fontSize: 10),
                ),
              )
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            width: screenWidth * 0.9,
            height: screenWidth * 0.65,
            child: ListView.builder(
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(4),
                  width: screenWidth * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.5,
                        height: screenWidth * 0.3,
                        child: Image.network(
                          addCDNforLoadImage(controller.listArticles[index].image!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: screenWidth * 0.03,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: kButtonColor.withOpacity(0.2)),
                          child: Text(controller.listArticles[index].tags!.first.toString(),
                              style: kTextInputStyle.copyWith(color: kButtonColor, fontSize: 10, fontWeight: FontWeight.w500)),
                        ),
                      ),
                      SizedBox(
                        height: screenWidth * 0.01,
                      ),
                      SizedBox(
                        width: screenWidth * 0.48,
                        child: Text(controller.listArticles[index].title!,
                            style: kTNCapproveStyle.copyWith(fontWeight: FontWeight.w500, color: const Color(0xFF535556))),
                      ),
                      SizedBox(
                        height: screenWidth * 0.03,
                      ),
                      Text(articleController.formattedDate(controller.listArticles[index].createdAt!),
                          style: kHomeSmallText.copyWith(color: const Color(0xFF535556)))
                    ],
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
          // Text("Sample bodytext SEO Altecare", style: kSubHeaderStyle),
          // SizedBox(
          //   height: screenWidth * 0.01,
          // ),
          // Text(
          //     "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          //     style: kValidationText.copyWith(height: 2)),
          // SizedBox(
          //   height: screenWidth * 0.02,
          // ),
          // Text(
          //     "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          //     style: kValidationText.copyWith(height: 2)),
          // SizedBox(
          //   height: screenWidth * 0.04,
          // ),
        ],
      ),
    );
  }

  Widget buildMobileDownload(BuildContext context, double screenWidth) {
    if (GetPlatform.isWeb) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              controller.dataAlteaLoyalty.title ?? "",
              style: kSubHeaderStyle.copyWith(fontSize: 18),
              softWrap: true,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              controller.dataAlteaLoyalty.description ?? "",
              softWrap: true,
              style: kVerifText1.copyWith(
                color: const Color(0xFF535556),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          CustomFlatButton(
              width: MediaQuery.of(context).size.width * 0.5,
              text: 'Download Sekarang',
              onPressed: () {
                // print('downloadd');
                controller.launchURL(controller.dataAlteaLoyalty.urlWeb!);
              },
              color: kButtonColor),
          const SizedBox(
            height: 45,
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 3,
            child: FadeInImage.assetNetwork(
              placeholder: "assets/loadingPlaceholder.gif",
              image: controller.dataAlteaLoyalty.imageDesktop ?? "http://cdn.onlinewebfonts.com/svg/img_148071.png",
              fit: BoxFit.contain,
            ),
          )
        ],
      );
    } else {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                'Unggah Kwitansi dan Dapatkan Cashback 50%',
                style: kSubHeaderStyle,
                softWrap: true,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                'Download Altea Loyalty sekarang dan dapatkan cashback dari transaksi di Mitra Keluarga! *Maksimal Rp 10.000,- ShopeePay',
                softWrap: true,
                style: kVerifText1.copyWith(
                  color: const Color(0xFF535556),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            CustomFlatButton(
                width: MediaQuery.of(context).size.width * 0.45, text: 'Download Sekarang', onPressed: () => print('downloadd'), color: kButtonColor),
            const SizedBox(
              height: 45,
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 3,
              child: Image.asset(
                'assets/carousel2.png',
                alignment: Alignment.bottomRight,
              ),
            )
          ],
        ),
      );
    }
  }

  Transform buildMobileFloatingMenu(BuildContext context) {
    return Transform(
      transform: Matrix4.translationValues(0.0, -30.0, 0.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
            margin: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width * 1.5,
            decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(48), boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: controller
                  .floatingMenu()
                  .map((e) => InkWell(
                        onTap: () {
                          if (e['title'] == "Cari Spesialis") {
                            Get.toNamed(Routes.SEARCH_SPECIALIST);
                          }
                          // print(e['title']);
                        },
                        child: Container(
                          child: Row(
                            children: [
                              Image.asset(
                                e['assetImage'].toString(),
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                e['title'].toString(),
                                style: kfloatingMenuStyle,
                              )
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            )),
      ),
    );
  }
}

class HomeMobileWebFloatingMenu extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Transform(
      transform: Matrix4.translationValues(0.0, -30.0, 0.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width * 1.5,
          decoration: BoxDecoration(
            color: kBackground,
            borderRadius: BorderRadius.circular(48),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: controller
                .floatingMenu()
                .map(
                  (e) => InkWell(
                    onTap: () {
                      Get.toNamed(Routes.SEARCH_SPECIALIST);
                      // print(e['title']);
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Image.asset(
                            e['assetImage'].toString(),
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            e['title'].toString(),
                            style: kfloatingMenuStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class HomeWebMobileArticleContainer extends StatelessWidget {
  final double screenWidth;
  HomeWebMobileArticleContainer({required this.screenWidth});

  final HomeController controller = Get.find<HomeController>();
  final ArticleController _articleController = Get.put(ArticleController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackground,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: screenWidth * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Artikel Kesehatan Terbaru",
                style: kHomeSubHeaderStyle.copyWith(fontSize: 15),
              ),
              InkWell(
                onTap: () {
                  _articleController.goToMainScreenFromHome();
                  // _articleController.menus.add("Article");
                  // _articleController.articleList.value = controller.listArticles;
                  // _articleController.dataPagination.value = controller.dataPageArticle.value;
                  Get.toNamed(
                    Routes.ARTICLE,
                  );
                },
                child: Text(
                  "Lihat Semua",
                  style: kHomeSmallText.copyWith(fontSize: 10),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: screenWidth * 0.9,
            height: screenWidth * 0.65,
            child: Obx(() => ListView.builder(
                  itemCount: _articleController.popularArticles.length > 4 ? 4 : _articleController.popularArticles.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.toNamed(
                          "/article-detail/${_articleController.popularArticles[index].slug.toString()}",
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: screenWidth * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.5,
                              height: screenWidth * 0.3,
                              child: Image.network(
                                addCDNforLoadImage(_articleController.popularArticles[index].image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: screenWidth * 0.03,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: const Color(0xFFEBF7F5)),
                                child: Text(
                                  _articleController.popularArticles[index].category.toString(),
                                  style: kTextInputStyle.copyWith(color: kButtonColor, fontSize: 9, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenWidth * 0.025,
                            ),
                            SizedBox(
                              width: screenWidth * 0.48,
                              child: Text(_articleController.popularArticles[index].title!,
                                  style: kTNCapproveStyle.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF535556),
                                    fontSize: 11,
                                  )),
                            ),
                            SizedBox(
                              height: screenWidth * 0.03,
                            ),
                            Text(
                              _articleController.formattedDate(_articleController.popularArticles[index].createdAt!),
                              style: kHomeSmallText.copyWith(
                                color: const Color(0xFF535556),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )),
          ),
          SizedBox(
            height: screenWidth * 0.01,
          ),
        ],
      ),
    );
  }
}


// class mobile_hamburger_menu extends StatelessWidget {
//   const mobile_hamburger_menu({
//     Key? key,
//     required this.screenWidth,
//     required this.menuList,
//   }) : super(key: key);

//   final double screenWidth;
//   final List<Map<String, String>> menuList;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         color: kWhiteGray,
//         width: screenWidth,
//         child: Drawer(
//           child: Column(children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 IconButton(
//                     icon: Icon(
//                       Icons.close,
//                       color: kButtonColor,
//                     ),
//                     onPressed: () => Get.back())
//               ],
//             ),
//             Container(
//               margin: const EdgeInsets.only(top: 32),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(left: 16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           margin: const EdgeInsets.only(top: 16),
//                           child: Row(
//                             children: [
//                               Image.asset('assets/account-info.png'),
//                               const SizedBox(
//                                 width: 16,
//                               ),
//                               InkWell(
//                                 child: Text(
//                                   'Sign In',
//                                   style: kSubHeaderStyle.copyWith(
//                                       fontWeight: FontWeight.w500,
//                                       color: kDarkBlue),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 50,
//                         ),
//                         SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.6,
//                           width: MediaQuery.of(context).size.width * 0.5,
//                           child: ListView.builder(
//                             itemCount: menuList.length,
//                             itemBuilder: (context, idx) {
//                               return InkWell(
//                                 onTap: () {
//                                   if (ModalRoute.of(context)?.settings.name ==
//                                       menuList[idx]['path']) {
//                                     Get.back();
//                                   } else {
//                                     Get.toNamed(menuList[idx]['path'] ?? ' ');
//                                   }
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Image.asset(
//                                       menuList[idx]['image'] ?? ' ',
//                                       width: 45,
//                                     ),
//                                     const SizedBox(
//                                       width: 8,
//                                     ),
//                                     Text(
//                                       menuList[idx]['title'] ?? ' ',
//                                       style: kButtonTextStyle.copyWith(
//                                           fontWeight: FontWeight.w400,
//                                           color: const Color(0xFF949698)),
//                                     )
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Image.asset('assets/mask.png')
//                 ],
//               ),
//             )
//           ]),
//         ),
//       ),
//     );
//   }
// }
