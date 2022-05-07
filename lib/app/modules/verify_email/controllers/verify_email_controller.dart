// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/core/utils/settings.dart' as settings;

class VerifyEmailController extends GetxController {
  //TODO: Implement VerifyEmailController

  final http.Client client = http.Client();
  final HomeController homeController = Get.find();

  final count = 0.obs;
  RxString email = ''.obs;
  RxString otpCode = ''.obs;

  Future sendVerificationEmail() async {
    try {
      var response = await client.post(Uri.parse('${settings.alteaURL}/user/email/verification'),
          body: jsonEncode({"email": email.value}), headers: {"Content-Type": "application/json"});

      // print('hasil send email verif => ${response.statusCode} : ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      // print('error => $e');
      return {"status": false, "message": e.toString()};
    }
  }

  Future verifEmail() async {
    try {
      var response = await client.post(Uri.parse('${settings.alteaURL}/user/email/verify'),
          body: jsonEncode({"email": email.value, "otp": otpCode.value}), headers: {"Content-Type": "application/json"});

      // print('hasil verif email -> ${response.body}');
      homeController.getUserProfileForWeb();
      return jsonDecode(response.body);
    } catch (e) {
      // print('error => $e');
      return {"status": false, "message": e.toString()};
    }
  }

  Future sendVerificationEmailWithEmailInput(String email) async {
    try {
      var response = await client.post(Uri.parse('${settings.alteaURL}/user/email/verification'),
          body: jsonEncode({"email": email}), headers: {"Content-Type": "application/json"});

      // print('hasil send email verif => ${response.statusCode} : ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        this.email.value = email;
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // print('error => $e');
      return {"status": false, "message": e.toString()};
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
