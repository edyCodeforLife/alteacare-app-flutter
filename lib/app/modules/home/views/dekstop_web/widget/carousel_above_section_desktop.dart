// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/screen_size.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/routes/app_pages.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/custom_flat_button.dart';

class CarouselAboveSectionWidget extends GetView<HomeController> {
  const CarouselAboveSectionWidget({
    Key? key,
    required this.screenWidth,
  }) : super(key: key);

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    // print(
    //     "check url -> ${controller.dataMainBanner.imageDesktop!.substring(0, 8)}cdn.statically.io/img/${controller.dataMainBanner.imageDesktop!.substring(8, controller.dataMainBanner.imageDesktop!.length)}");
    // print(
    //     "check url -> ${controller.dataMainBanner.imageDesktop!.substring(8, controller.dataMainBanner.imageDesktop!.length)}");
    ScreenSize.recalculate(context);

    return Container(
      color: kBackground,
      height: 60.hb,
      width: 120.wb,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.wb),
        child: Row(
          children: [
            // SizedBox(
            //   width: screenWidth * 0.1,
            // ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 35.wb,
                  child: Text(
                    controller.dataMainBanner.title ?? "Title not load",
                    style: kSubHeaderStyleBold.copyWith(fontSize: 2.wb, height: 1.3),
                  ),
                ),
                SizedBox(
                  height: 1.hb,
                ),
                SizedBox(
                  width: 30.wb,
                  child: Text(
                    controller.dataMainBanner.description ?? "Description not load",
                    style: kPoppinsRegular400.copyWith(fontSize: 1.wb, height: 1.7),
                  ),
                ),
                SizedBox(
                  height: 8.hb,
                ),
                CustomFlatButton(
                    width: 12.wb,
                    height: 5.5.hb,
                    text: 'Konsultasi Sekarang',
                    onPressed: () async {
                      // controller.launchURL(controller.dataMainBanner.urlWeb!);
                      Get.toNamed(Routes.DOCTOR_SPESIALIS);
                    },
                    color: kButtonColor),
              ],
            )),
            Expanded(
              child: FadeInImage.assetNetwork(
                placeholder: "assets/loadingPlaceholder.gif",
                image: controller.dataMainBanner.imageDesktop != null
                    ? addCDNforLoadImage(controller.dataMainBanner.imageDesktop!)
                    : "http://cdn.onlinewebfonts.com/svg/img_148071.png",
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }
}
