// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/use_shared_pref.dart';

class ProfileEditDetailController extends GetxController {
  //TODO: Implement ProfileEditDetailController
  final http.Client client = http.Client();

  RxString email = ''.obs;
  RxString phone = ''.obs;
  RxString otpCode = ''.obs;

  Future getAddresses() async {
    var token = await AppSharedPreferences.getAccessToken();
    try {
      final response =
          await client.get(Uri.parse('$alteaURL/user/address'), headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});
      // print('hasil get address => ${response.statusCode} - ${response.body}');
      return jsonDecode(response.body);
      // if (response.statusCode == 200) {
      //   return User.fromJson(json(response.body) as Map<String, dynamic>);
      // } else {
      //   return User.fromJsonError(
      //     jsonDecode(response.body) as Map<String, dynamic>,
      //   );
      // }
    } catch (e) {
      return e.toString();
    }
  }

  Future updatePrimaryAddress(String addressId) async {
    var token = await AppSharedPreferences.getAccessToken();
    // print('address => $addressId, token => $token');
    // print('$alteaURL/user/$addressId/set-primary/');
    try {
      final response = await client.get(Uri.parse('$alteaURL/user/address/$addressId/set-primary/'),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});
      // print('hasil update address => ${response.statusCode} - ${response.body}');
      return jsonDecode(response.body);
      // if (response.statusCode == 200) {
      //   return User.fromJson(json(response.body) as Map<String, dynamic>);
      // } else {
      //   return User.fromJsonError(
      //     jsonDecode(response.body) as Map<String, dynamic>,
      //   );
      // }
    } catch (e) {
      return e.toString();
    }
  }

  Future<Map<String, dynamic>> changePhoneNum(String phoneNum) async {
    var token = await AppSharedPreferences.getAccessToken();
    // print('address => $phoneNum, token => $token');
    // print('$alteaURL/user/phone/change/otp');
    try {
      final response = await client.post(Uri.parse('$alteaURL/user/phone/change/otp'),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"}, body: jsonEncode({"phone": phoneNum}));
      // print('hasil ganti phone num => ${response.statusCode} - ${response.body}');
      return jsonDecode(response.body) as Map<String, dynamic>;
      // if (response.statusCode == 200) {
      //   return User.fromJson(json(response.body) as Map<String, dynamic>);
      // } else {
      //   return User.fromJsonError(
      //     jsonDecode(response.body) as Map<String, dynamic>,
      //   );
      // }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future sendVerificationEmail() async {
    var token = await AppSharedPreferences.getAccessToken();
    try {
      var response = await client.post(Uri.parse('$alteaURL/user/email/change/otp'),
          body: jsonEncode({"email": email.value}), headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});

      // print('hasil change email verif => ${response.statusCode} : ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      // print('error => $e');
      return {"status": false, "message": e.toString()};
    }
  }

  Future changeEmail() async {
    var token = await AppSharedPreferences.getAccessToken();
    try {
      var response = await client.post(Uri.parse('$alteaURL/user/email/change'),
          body: jsonEncode({"email": email.value, "otp": otpCode.value}),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});

      // print('hasil change email -> ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      // print('error => $e');
      return {"status": false, "message": e.toString()};
    }
  }

  Future verifPhone() async {
    var token = await AppSharedPreferences.getAccessToken();
    // print('phone => ${phone.value}');
    try {
      var response = await client.post(Uri.parse('$alteaURL/user/phone/change'),
          body: jsonEncode({"phone": phone.value, "otp": otpCode.value}),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});

      // print('hasil change email -> ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      // print('error => $e');
      return {"status": false, "message": e.toString()};
    }
  }

  final count = 0.obs;
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
