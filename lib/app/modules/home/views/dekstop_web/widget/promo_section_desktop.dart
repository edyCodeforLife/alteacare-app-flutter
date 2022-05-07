// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/screen_size.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/styles.dart';

class PromoSectionWidget extends GetView<HomeController> {
  const PromoSectionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize.recalculate(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.wb),
      child: SizedBox(
        width: 120.wb,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(
            //   height: 2.hb,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Promo Program",
                  style: kPoppinsSemibold600.copyWith(
                    color: kBlackColor.withOpacity(0.8),
                    fontSize: 1.7.wb,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    "Lihat Semua",
                    style: kTextInputStyle.copyWith(wordSpacing: 1, color: kDarkBlue, fontSize: 14, fontWeight: FontWeight.bold),
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
                itemCount: controller.dataPromosBanner.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            // print("click -> $index");
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: FadeInImage.assetNetwork(
                              placeholder: "assets/loadingPlaceholder.gif",
                              image: addCDNforLoadImage(controller.dataPromosBanner[index].imageDesktop!),
                              width: 50.wb,
                              height: 40.hb,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      if (index != controller.dataPromosBanner.length - 1) ...[
                        SizedBox(
                          width: 2.wb,
                        ),
                      ]
                    ],
                  );
                },
              ),
            ),
            // SizedBox(
            //   // width: screenWidth * 0.8,
            //   height: screenWidth * 0.15,
            //   child: ListView.builder(
            //     itemCount: 5,
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (BuildContext context, int index) {
            //       return InkWell(
            //         onTap: () {},
            //         child: SizedBox(
            //           width: screenWidth * 0.2,
            //           height: screenWidth * 0.2,
            //           child: Container(
            //             color: Colors.blue,
            //           ),
            //         ),
            //       );
            //     },
            //   ),

            // ListView.builder(
            //   itemCount: controller.dataPromosBanner.length,
            //   scrollDirection: Axis.horizontal,
            //   itemBuilder: (context, index) {
            //     return InkWell(
            //       onTap: () {
            //         controller
            //             .launchURL(controller.dataPromosBanner[index].urlWeb!);
            //       },
            //       child: Container(
            //         width: screenWidth * 0.3,
            //         child: Container(
            // width: screenWidth * 0.3,
            // height: screenWidth * 0.3,
            //           decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(18),
            //               image: DecorationImage(
            //                 image: NetworkImage(
            //                   controller.dataPromosBanner[index].imageDesktop ??
            //                       "http://cdn.onlinewebfonts.com/svg/img_148071.png",
            //                 ),
            //                 fit: BoxFit.cover,
            //               )),
            //         ),
            //       ),
            //     );
            //   },
            // ),
            // ),
          ],
        ),
      ),
    );
  }
}
