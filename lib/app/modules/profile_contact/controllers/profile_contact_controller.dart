// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/use_shared_pref.dart';

class ProfileContactController extends GetxController {
  //TODO: Implement ProfileContactController
  final http.Client client = http.Client();
  Future getQuestionType() async {
    var token = await AppSharedPreferences.getAccessToken();
    final http.Client client = http.Client();
    try {
      var response = await client.get(Uri.parse('$alteaURL/data/message-types'));

      // print('hasil get questions -> ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      // print('error => $e');
      return {"status": false, "message": e.toString()};
    }
  }

  Future postQuestion(Map<String, dynamic> body) async {
    var token = await AppSharedPreferences.getAccessToken();
    final http.Client client = http.Client();
    // print('body => $body');
    try {
      var response = await client.post(Uri.parse('$alteaURL/data/messages'),
          body: jsonEncode(body), headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});

      // print('hasil post questions -> ${response.body}');
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
