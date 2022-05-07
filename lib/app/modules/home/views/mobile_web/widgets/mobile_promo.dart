// Flutter imports:
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';

class MobilePromo extends StatelessWidget {
  HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (GetPlatform.isWeb) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Promo Program',
                style: kHomeSubHeaderStyle.copyWith(fontSize: 15),
              ),
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Lihat Semua',
                    style: kHomeSmallText.copyWith(fontSize: 10),
                  ),
                ),
              )
            ],
          ),
          Container(
            width: screenWidth,
            height: screenWidth * 0.28,
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
                            image: controller.dataPromosBanner[index].imageDesktop!,
                            width: screenWidth * 0.6,
                            height: screenWidth * 0.28,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    if (index != controller.dataPromosBanner.length - 1) ...[
                      const SizedBox(
                        width: 8,
                      ),
                    ]
                  ],
                );
              },
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Promo Program',
                style: kHomeSubHeaderStyle,
              ),
              Container(
                margin: EdgeInsets.only(right: 16),
                child: TextButton(
                  onPressed: () {
                    if (GetPlatform.isWeb) {
                      // Get.toNamed('/doctor');
                    } else {
                      Get.dialog(
                        CustomSimpleDialog(
                            icon: const SizedBox(),
                            onPressed: () {
                              Get.back();
                            },
                            title: "Dalam pengembangan",
                            buttonTxt: "Saya mengerti",
                            subtitle: ""),
                      );
                      // controller.currentIdx.value = 1;
                    }
                  },
                  child: Text(
                    'Lihat Semua',
                    style: kHomeSmallText,
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder<Map<String, dynamic>>(
              future: controller.getPromoBanner(),
              builder: (context, snapshot) {
                // print('result banner => ${snapshot.data}');
                if (snapshot.hasData) {
                  int len = 0;
                  try {
                    len = (snapshot.data?['data'] as List).length;
                  } catch (e) {
                    print("fail to get length $e");
                  }
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.18,
                    child: ListView.builder(
                      itemCount: len,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(right: 16),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.18,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              image: DecorationImage(
                                image: NetworkImage(
                                  snapshot.data?['data'][index]['image_mobile'] == null
                                      ? ' '
                                      : snapshot.data?['data'][index]['image_mobile'] as String,
                                ),
                                fit: BoxFit.fill,
                              )),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
              }),
        ],
      );
    }
  }
}
