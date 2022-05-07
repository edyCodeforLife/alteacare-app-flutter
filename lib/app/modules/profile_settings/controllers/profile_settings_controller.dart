// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/use_shared_pref.dart';

class ProfileSettingsController extends GetxController {
  //TODO: Implement ProfileSettingsController

  Future changePassword(Map<String, dynamic> body) async {
    var token = await AppSharedPreferences.getAccessToken();
    final http.Client client = http.Client();
    // print('body => $body');
    try {
      var response = await client.post(Uri.parse('$alteaURL/user/password/change'),
          body: jsonEncode(body), headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});

      // print('hasil change password -> ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      // print('error => $e');
      return {"status": false, "message": e.toString()};
    }
  }

  Future checkPassword(Map<String, dynamic> body) async {
    var token = await AppSharedPreferences.getAccessToken();
    final http.Client client = http.Client();
    // print('body => $body');
    try {
      var response = await client.post(Uri.parse('$alteaURL/user/password/check'),
          body: jsonEncode(body), headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});

      // print('hasil check password -> ${response.body}');
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
