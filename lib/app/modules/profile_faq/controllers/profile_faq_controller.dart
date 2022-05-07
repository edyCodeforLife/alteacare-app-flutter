// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/use_shared_pref.dart';

class ProfileFaqController extends GetxController {
  //TODO: Implement ProfileFaqController
  final http.Client client = http.Client();
  Future getFAQ() async {
    var token = await AppSharedPreferences.getAccessToken();

    try {
      var response = await client.get(Uri.parse('$alteaURL/data/faqs'));

      // print('hasil get faq -> ${response.body}');
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
