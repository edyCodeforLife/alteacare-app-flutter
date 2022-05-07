// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/screen_size.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/custom_flat_button.dart';
import '../../../controllers/home_controller.dart';

class AlteaLoyaltySectionWidget extends GetView<HomeController> {
  const AlteaLoyaltySectionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    ScreenSize.recalculate(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.wb),
      child: Row(
        children: [
          SizedBox(
              width: 40.wb,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.dataAlteaLoyalty.title ?? "",
                    style: kSubHeaderStyleBold.copyWith(fontSize: 2.wb, height: 1.3),
                  ),
                  SizedBox(
                    height: 1.hb,
                  ),
                  Text(
                    controller.dataAlteaLoyalty.description ?? "",
                    style: kPoppinsRegular400.copyWith(fontSize: 1.wb, height: 1.7),
                  ),
                  SizedBox(
                    height: 5.hb,
                  ),
                  CustomFlatButton(
                      width: 12.wb,
                      height: 5.5.hb,
                      text: 'Download Sekarang',
                      onPressed: () {
                        controller.launchURL(controller.dataAlteaLoyalty.urlWeb ?? "");
                      },
                      color: kButtonColor),
                ],
              )),
          const Spacer(),
          SizedBox(
            width: 35.wb,
            child: FadeInImage.assetNetwork(
              placeholder: "assets/loadingPlaceholder.gif",
              image: controller.dataAlteaLoyalty.imageDesktop != null
                  ? "${controller.dataAlteaLoyalty.imageDesktop!.substring(0, 8)}cdn.statically.io/img/${controller.dataAlteaLoyalty.imageDesktop!.substring(8, controller.dataAlteaLoyalty.imageDesktop!.length)}"
                  : "http://cdn.onlinewebfonts.com/svg/img_148071.png",
              fit: BoxFit.cover,
            ),
          ),
          // SizedBox(
          //   width: screenWidth * 0.3,
          // ),
        ],
      ),
    );
  }
}
