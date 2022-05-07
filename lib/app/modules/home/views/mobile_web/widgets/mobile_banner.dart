// Flutter imports:
// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MobileBanner extends GetView<HomeController> {
  const MobileBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(top: 25, left: 16),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 0),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  controller.dataMainBanner.title ?? "Title not load",
                  style: kSubHeaderStyle.copyWith(
                    fontSize: 18,
                  ),
                  softWrap: true,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  controller.dataMainBanner.description ?? "Description not load",
                  style: kVerifText1.copyWith(
                    color: const Color(0xFF535556),
                    fontSize: 12,
                  ),
                  softWrap: true,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              CustomFlatButton(
                width: MediaQuery.of(context).size.width * 0.5,
                text: 'Konsultasi Sekarang',
                onPressed: () async {
                  if (await canLaunch(controller.dataMainBanner.urlWeb ?? "")) {
                    controller.launchURL(controller.dataMainBanner.urlWeb ?? "");
                  }
                },
                color: kButtonColor,
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FadeInImage.assetNetwork(
                    placeholder: "assets/loadingPlaceholder.gif",
                    image: controller.dataMainBanner.imageDesktop ?? "http://cdn.onlinewebfonts.com/svg/img_148071.png",
                    width: screenWidth * 2,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
