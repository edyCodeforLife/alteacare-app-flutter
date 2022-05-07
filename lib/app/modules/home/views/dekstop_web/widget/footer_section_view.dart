// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:altea/app/core/utils/screen_size.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/styles.dart';

class FooterSectionWidget extends StatelessWidget {
  const FooterSectionWidget({
    Key? key,
    required this.screenWidth,
  }) : super(key: key);

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    ScreenSize.recalculate(context);
    return Container(
      padding: const EdgeInsets.all(16),
      color: kLightBlueColor,
      child: Column(
        children: [
          SizedBox(
            height: 1.hb,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.wb),
            child: SizedBox(
              width: 120.wb,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FooterSubDetailWidgetWithAlteaLogo(screenWidth: screenWidth),
                  FooterSubDetailWidgetCompany(
                    screenWidth: screenWidth,
                    title: "Company",
                    option1: "FAQ",
                    option2: "Syarat & Ketentuan",
                    option3: "Data Privasi",
                    option4: "Blog",
                  ),
                  FooterSubDetailWidgetService(
                    screenWidth: screenWidth,
                    title: "Service",
                    option1: "Medical Advisor",
                    option2: "Spesialis",
                  ),
                  FooterSubDetailWidgetFollowUs(screenWidth: screenWidth, title: "Follow Us"),
                  FooterSubDetailWidgetDownload(
                    screenWidth: screenWidth,
                    title: "Download",
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1.hb,
          ),
          Divider(
            color: kTextHintColor.withOpacity(0.5),
          ),
          SizedBox(
            height: 1.hb,
          ),
          Text(
            "@2021 Alteacare All Rights Reseved",
            style: kPoppinsSemibold600.copyWith(fontSize: 1.wb, color: kBlackColor.withOpacity(0.8), wordSpacing: 1),
          )
        ],
      ),
    );
  }
}

class FooterSubDetailWidgetWithAlteaLogo extends StatelessWidget {
  const FooterSubDetailWidgetWithAlteaLogo({
    Key? key,
    required this.screenWidth,
  }) : super(key: key);

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    ScreenSize.recalculate(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 10.wb,
          height: 10.hb,
          child: Image.asset("assets/altea_logo.png"),
        ),
        SizedBox(
          height: 3.hb,
        ),
        Text(
          "Jl.Raya Utama, Bintaro Jaya Sektor 3A \nTangerang Selatan 15225",
          style: kTextInputStyle.copyWith(wordSpacing: 0.5, color: kBlackColor.withOpacity(0.8), fontSize: 0.8.wb),
        ),
        SizedBox(
          height: screenWidth * 0.02,
        ),
        Text(
          "+62 813 15739235",
          style: kTextInputStyle.copyWith(color: kBlackColor.withOpacity(0.8), fontSize: 0.9.wb, wordSpacing: 0.5, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 0.5.hb,
        ),
        Text(
          "+cs@alteacare.com",
          style: kTextInputStyle.copyWith(wordSpacing: 0.5, color: kBlackColor.withOpacity(0.8), fontSize: 0.9.wb, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class FooterSubDetailWidgetCompany extends StatelessWidget {
  const FooterSubDetailWidgetCompany({
    Key? key,
    required this.screenWidth,
    required this.title,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
  }) : super(key: key);

  final double screenWidth;
  final String title;
  final String option1;
  final String option2;
  final String option3;
  final String option4;

  @override
  Widget build(BuildContext context) {
    ScreenSize.recalculate(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 2.hb,
        ),
        Text(
          title,
          style: kPoppinsRegular400.copyWith(color: kBlackColor.withOpacity(0.8), fontSize: 1.wb, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 4.1.hb,
        ),
        InkWell(
          onTap: () {},
          child: Text(
            option1,
            style: kPoppinsRegular400.copyWith(
              color: kBlackColor.withOpacity(0.8),
              fontSize: 0.8.wb,
            ),
          ),
        ),
        SizedBox(
          height: 2.hb,
        ),
        InkWell(
          onTap: () {},
          child: Text(
            option2,
            style: kPoppinsRegular400.copyWith(
              color: kBlackColor.withOpacity(0.8),
              fontSize: 0.8.wb,
            ),
          ),
        ),
        SizedBox(
          height: 2.hb,
        ),
        InkWell(
          onTap: () {},
          child: Text(
            option3,
            style: kPoppinsRegular400.copyWith(
              color: kBlackColor.withOpacity(0.8),
              fontSize: 0.8.wb,
            ),
          ),
        ),
        SizedBox(
          height: 2.hb,
        ),
        InkWell(
          onTap: () {},
          child: Text(
            option4,
            style: kPoppinsRegular400.copyWith(
              color: kBlackColor.withOpacity(0.8),
              fontSize: 0.8.wb,
            ),
          ),
        ),
      ],
    );
  }
}

class FooterSubDetailWidgetService extends StatelessWidget {
  const FooterSubDetailWidgetService({
    Key? key,
    required this.screenWidth,
    required this.title,
    required this.option1,
    required this.option2,
  }) : super(key: key);

  final double screenWidth;
  final String title;
  final String option1;
  final String option2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 2.hb,
        ),
        Text(
          title,
          style: kPoppinsRegular400.copyWith(color: kBlackColor.withOpacity(0.8), fontSize: 1.wb, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 4.0.hb,
        ),
        InkWell(
          onTap: () {},
          child: Text(
            option1,
            style: kPoppinsRegular400.copyWith(
              color: kBlackColor.withOpacity(0.8),
              fontSize: 0.8.wb,
            ),
          ),
        ),
        SizedBox(
          height: 2.hb,
        ),
        InkWell(
          onTap: () {},
          child: Text(
            option2,
            style: kPoppinsRegular400.copyWith(
              color: kBlackColor.withOpacity(0.8),
              fontSize: 0.8.wb,
            ),
          ),
        ),
      ],
    );
  }
}

class FooterSubDetailWidgetFollowUs extends StatelessWidget {
  const FooterSubDetailWidgetFollowUs({
    Key? key,
    required this.screenWidth,
    required this.title,
  }) : super(key: key);

  final double screenWidth;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.hb),
        Text(
          title,
          style: kPoppinsRegular400.copyWith(color: kBlackColor.withOpacity(0.8), fontSize: 1.wb, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.0.hb),
        SizedBox(
          width: 12.wb,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {},
                child: SizedBox(
                  width: 2.wb,
                  child: Image.asset("assets/logo_ig.png"),
                ),
              ),
              InkWell(
                onTap: () {},
                child: SizedBox(
                  width: 2.wb,
                  child: Image.asset("assets/logo_twitter.png"),
                ),
              ),
              InkWell(
                onTap: () {},
                child: SizedBox(
                  width: 2.wb,
                  child: Image.asset("assets/logo_linkedin.png"),
                ),
              ),
              InkWell(
                onTap: () {},
                child: SizedBox(
                  width: 2.wb,
                  child: Image.asset("assets/logo_fb.png"),
                ),
              ),
              InkWell(
                onTap: () {},
                child: SizedBox(
                  width: 2.wb,
                  child: Image.asset("assets/logo_youtube.png"),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class FooterSubDetailWidgetDownload extends StatelessWidget {
  const FooterSubDetailWidgetDownload({
    Key? key,
    required this.screenWidth,
    required this.title,
  }) : super(key: key);

  final double screenWidth;
  final String title;

  @override
  Widget build(BuildContext context) {
    ScreenSize.recalculate(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.hb),
        Text(
          title,
          style: kPoppinsRegular400.copyWith(color: kBlackColor.withOpacity(0.8), fontSize: 1.wb, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 4.0.hb,
        ),
        InkWell(
          onTap: () {},
          child: SizedBox(
            width: 8.wb,
            child: Image.asset("assets/gplaystore_logo.png"),
          ),
        ),
        SizedBox(
          height: 1.hb,
        ),
        InkWell(
          onTap: () {},
          child: SizedBox(
            width: 8.wb,
            child: Image.asset("assets/appstore_logo.png"),
          ),
        ),
      ],
    );
  }
}
