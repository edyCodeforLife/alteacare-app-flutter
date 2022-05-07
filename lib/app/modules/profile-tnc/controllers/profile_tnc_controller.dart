// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/use_shared_pref.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfileTncController extends GetxController {
  //TODO: Implement ProfileTncController

  final http.Client client = http.Client();

  Future getTNC() async {
    var token = await AppSharedPreferences.getAccessToken();

    try {
      var response = await client.get(Uri.parse('$alteaURL/data/blocks?type=TERMS_CONDITION'));

      // print('hasil get tnc -> ${response.body}');
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
