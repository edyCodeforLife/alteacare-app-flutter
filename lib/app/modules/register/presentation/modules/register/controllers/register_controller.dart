// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:altea/app/core/widgets/alert_screen.dart';
import 'package:altea/app/data/model/register_model.dart';
import 'package:altea/app/core/utils/settings.dart' as settings;

class RegisterController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;

  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString ktpNo = ''.obs;
  RxString birthDate = ''.obs;
  RxString nation = ''.obs;
  RxString birthTown = ''.obs;
  RxString gender = ''.obs;
  RxString phoneNum = ''.obs;
  RxString email = ''.obs;
  RxString password = ''.obs;
  RxString retryPassword = ''.obs;
  RxString countryName = ''.obs;
  RxString accessToken = ''.obs;
  RxString otpCode = ''.obs;
  RxBool isPhoneUsable = true.obs;
  RxBool isEmailUsable = true.obs;
  RxList<dynamic> nations = [].obs;
  RxString selectedNation = "".obs;

  ScrollController scrollController = ScrollController();
  RxBool dataSaved = true.obs;
  final http.Client client = http.Client();

  Future getCountry() async {
    const webUrl = "${settings.alteaURL}/data/countries?_limit=2000";
    const mobileUrl = "${settings.alteaURL}/data/countries?_limit=2000";

    // const mobileUrl = "https://jr6gclz3f0.execute-api.us-east-1.amazonaws.com/dev/country-list";
    try {
      final response = await client.get(
        Uri.parse(GetPlatform.isWeb ? webUrl : mobileUrl),
        headers: {"Content-Type": "application/json"},
      );
      // print("get country : ${response.statusCode}");
      // log(response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<Register> registerAccount({required BuildContext context}) async {
    final Register registerModel = Register(
        firstName: firstName.value,
        lastName: lastName.value,
        email: email.value,
        phone: phoneNum.value,
        password: password.value,
        passwowrdConfirmation: retryPassword.value,
        birthDate: birthDate.value,
        birthPlace: birthTown.value,
        birthCountry: nation.value,
        cardId: ktpNo.value,
        gender: gender.value == 'Laki Laki' ? 'MALE' : 'FEMALE');

    // print('model => ${registerModel.toJson()}');

    try {
      final response = await client.post(Uri.parse("${settings.alteaURL}/user/auth/register"),
          headers: {"Content-Type": "application/json"}, body: jsonEncode(registerModel.toJson()));

      if (response.statusCode == 200) {
        // print("masuk success 200");
        return Register.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

        //   if (GetPlatform.isWeb) {
        //     showDialog(
        //         context: context,
        //         builder: (context) {
        //           return CustomSimpleDialog(
        //             buttonTxt: 'Sign In',
        //             subtitle: 'Akun Anda berhasil dibuat, silakan Sign In',
        //             title: 'Akun Berhasil Dibuat',
        //             icon: Icon(
        //               Icons.check_circle_outline,
        //               color: kGreenColor,
        //               size: 150,
        //             ),
        //             onPressed: () {
        //               Get.offAllNamed("/login");
        //             },
        //           );
        //         });
        //   } else {
        //     Get.to(AlertScreen(
        //         title: 'Akun Berhasil Dibuat',
        //         subtitle: 'Akun anda berhasil dibuat. Silahkan sign in.',
        //         imgPath: 'assets/success_icon.png',
        //         btnText: 'Beranda',
        //         onPressed: () => Get.toNamed('/home')));
        //   }
        //
        //   return Register.fromJson(
        //       jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        // print("masuk error 404");
        // print('error 404 ${response.body}');
        return Register.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
        //
        //   Get.to(AlertScreen(
        //       title: 'Pembuatan Akun Gagal',
        //       subtitle: jsonDecode(response.body)['message'].toString(),
        //       imgPath: 'assets/group-5.png',
        //       btnText: 'Hubungi Altea Care',
        //       onPressed: () => Get.offNamed('/login')));
        //
        //
      }
    } catch (e) {
      Get.to(
        () => AlertScreen(
          title: 'Pembuatan Akun Gagal',
          subtitle: 'Pembuatan akun gagal, silakan hubungi CS AlteaCare',
          imgPath: 'assets/group-5.png',
          btnText: 'Hubungi Altea Care',
          onPressed: () => Get.offNamed('/login'),
        ),
      );
      print("masuk catch $e");
      return Register.fromJson(e as Map<String, dynamic>);
    }
    return Register();
  }

  Future checkPhoneAndEmail() async {
    // print('check email');
    try {
      final response = await client.post(Uri.parse('${settings.alteaURL}/user/users/check-user'),
          body: jsonEncode({"email": email.value, "phone": phoneNum.value}), headers: {"Content-Type": "application/json"});

      // print('balikan => ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      return {"message": e.toString()};
    }
  }

  RxString verificationMethod = "phone".obs;

  Future sendPhoneVerification() async {
    verificationMethod.value = "phone";
    try {
      final response = await client.post(Uri.parse('${settings.alteaURL}/user/phone/verification'),
          body: jsonEncode({"phone": phoneNum.value}), headers: {"Authorization": "Bearer ${accessToken.value}", "Content-Type": "application/json"});
      // print("hasil kirim otp => ${response.statusCode} : ${response.body}");
      return jsonDecode(response.body);
    } catch (e) {
      return e.toString();
    }
  }

  Future sendEmailVerification() async {
    verificationMethod.value = "email";
    try {
      final response = await client.post(Uri.parse('${settings.alteaURL}/user/email/verification'),
          body: jsonEncode({"email": email.value}), headers: {"Authorization": "Bearer ${accessToken.value}", "Content-Type": "application/json"});
      print("hasil kirim otp => ${response.statusCode} : ${response.body}");
      return jsonDecode(response.body);
    } catch (e) {
      return e.toString();
    }
  }

  Future verifyPhone() async {
    try {
      final response = await client.post(Uri.parse('${settings.alteaURL}/user/phone/verify'),
          body: jsonEncode({
            "phone": phoneNum.value,
            "otp": otpCode.value,
          }),
          headers: {"Authorization": "Bearer ${accessToken.value}", "Content-Type": "application/json"});
      // print('hasil verif otp => ${response.statusCode} : ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      return e.toString();
    }
  }

  Future verifyEmail() async {
    try {
      final response = await client.post(Uri.parse('${settings.alteaURL}/user/email/verify'),
          body: jsonEncode({
            "email": email.value,
            "otp": otpCode.value,
          }),
          headers: {"Authorization": "Bearer ${accessToken.value}", "Content-Type": "application/json"});
      print('hasil verif otp => ${response.statusCode} : ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      return e.toString();
    }
  }

  /// this function is to get my TNC Altea data
  Future<Map<String, dynamic>> getTnCData() async {
    try {
      final response = await client.get(Uri.parse("${settings.alteaURL}/data/blocks?type=TERMS_CONDITION"), headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      return e as Map<String, dynamic>;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
