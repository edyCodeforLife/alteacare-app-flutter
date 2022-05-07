// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';

class FooterMobileWebView extends StatelessWidget {
  const FooterMobileWebView({
    Key? key,
    required this.screenWidth,
  }) : super(key: key);

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: kLightBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: screenWidth * 0.3,
            child: Image.asset("assets/altea_logo.png"),
          ),
          SizedBox(
            height: screenWidth * 0.02,
          ),
          SelectableText(
            "Jl.Raya Utama, Bintaro Jaya Sektor 3A \nTangerang Selatan 15225",
            style: kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.5), fontSize: 11),
          ),
          SizedBox(
            height: screenWidth * 0.05,
          ),
          InkWell(
            onTap: () async {
              if (await canLaunch("https://wa.me/6281315739235")) {
                launch("https://wa.me/6281315739235");
              }
            },
            child: Text(
              "+62 813 15739235",
              style: kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: screenWidth * 0.01,
          ),
          SelectableText(
            "+cs@alteacare.com",
            style: kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 32,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenWidth * 0.01,
              ),
              Text(
                'Company',
                style: kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: screenWidth * 0.02,
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'FAQ',
                  style: kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: screenWidth * 0.01,
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'Syarat & Ketentuan',
                  style: kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: screenWidth * 0.01,
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'Data Privasi',
                  style: kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: screenWidth * 0.01,
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'Blog',
                  style: kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 33),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenWidth * 0.01,
              ),
              Text(
                'Service',
                style: kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: screenWidth * 0.02,
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'Medical Advisor',
                  style: kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: screenWidth * 0.01,
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'Spesialis',
                  style: kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 33),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenWidth * 0.01,
              ),
              Text(
                'Follow Us',
                style: kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: screenWidth * 0.02,
              ),
              SizedBox(
                width: screenWidth * 0.4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: screenWidth * 0.07,
                        child: Image.asset("assets/logo_ig.png"),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: screenWidth * 0.07,
                        child: Image.asset("assets/logo_twitter.png"),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: screenWidth * 0.07,
                        child: Image.asset("assets/logo_linkedin.png"),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: screenWidth * 0.07,
                        child: Image.asset("assets/logo_fb.png"),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: screenWidth * 0.07,
                        child: Image.asset("assets/logo_youtube.png"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 33,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenWidth * 0.01,
              ),
              Text(
                'Download',
                style: kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: screenWidth * 0.02,
              ),
              InkWell(
                onTap: () {},
                child: SizedBox(
                  width: screenWidth * 0.3,
                  child: Image.asset("assets/gplaystore_logo.png"),
                ),
              ),
              SizedBox(
                height: screenWidth * 0.01,
              ),
              InkWell(
                onTap: () {},
                child: SizedBox(
                  width: screenWidth * 0.3,
                  child: Image.asset("assets/appstore_logo.png"),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          const Divider(),
          const SizedBox(
            height: 5,
          ),
          Container(
            alignment: Alignment.center,
            height: 40,
            child: Text(
              "@2021 Alteacare All Rights Reseved",
              style: kDialogSubTitleStyle,
            ),
          ),
        ],
      ),
    );
  }
}
