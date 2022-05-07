import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:get/get.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalHeader: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Onboarding",
          style: kPoppinsSemibold600.copyWith(color: Colors.black),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Easy Access",
          body: "Lakukan registrasi atau Sign In untuk mengakses aplikasi Altea Care",
          image: Container(
            height: 200,
            width: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/splash01.png"),
              ),
            ),
          ),
          decoration: PageDecoration(
            titleTextStyle: kPoppinsSemibold600.copyWith(fontSize: 18),
            bodyTextStyle: kPoppinsMedium500.copyWith(fontSize: 14, color: kTextHintColor),
            descriptionPadding: const EdgeInsets.symmetric(horizontal: 30),
          ),
        ),
        PageViewModel(
          title: "Easy Booking",
          body: "Pilih dan booking konsultasi dengan Dokter spesialis berpengalaman",
          image: Container(
            height: 200,
            width: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/splash02.png"),
              ),
            ),
          ),
          decoration: PageDecoration(
            titleTextStyle: kPoppinsSemibold600.copyWith(fontSize: 18),
            bodyTextStyle: kPoppinsMedium500.copyWith(fontSize: 14, color: kTextHintColor),
            descriptionPadding: const EdgeInsets.symmetric(horizontal: 30),
          ),
        ),
        PageViewModel(
          title: "Flexible Consultation",
          body: "Konsultasi kesehatan dengan dokter spesialis kami kapan pun dan di mana pun",
          image: Container(
            height: 200,
            width: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/splash03.png"),
              ),
            ),
          ),
          decoration: PageDecoration(
            titleTextStyle: kPoppinsSemibold600.copyWith(fontSize: 18),
            bodyTextStyle: kPoppinsMedium500.copyWith(fontSize: 14, color: kTextHintColor),
            descriptionPadding: const EdgeInsets.symmetric(horizontal: 30),
          ),
        ),
      ],
      onDone: () {
        Get.toNamed("/login");
      },
      // onSkip: () {
      //   Navigator.of(context).pushNamedAndRemoveUntil('Home', (Route<dynamic> route) => false);
      // },
      showSkipButton: true,
      isBottomSafeArea: true,
      skip: Text("Lewati"),
      next: Text("Selanjutnya"),
      done: Text("Masuk", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: Size.square(10.0),
        activeSize: Size(20.0, 10.0),
        activeColor: const Color(0xFF128EBF),
        color: const Color(0x55128EBF),
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
