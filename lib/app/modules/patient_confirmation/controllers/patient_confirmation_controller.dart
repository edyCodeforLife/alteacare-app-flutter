// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/use_shared_pref.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PatientConfirmationController extends GetxController {
  final http.Client client = http.Client();
  Future createAppointment(Map<String, dynamic> body) async {
    try {
      var token = AppSharedPreferences.getAccessToken();
      final response = await client.post(
          Uri.parse(
            // "$alteaURL/appointment/make-consultation",
            "$alteaURL/appointment/v3/consultation",
          ),
          body: jsonEncode(body),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        // print('statusCode => ${response.statusCode} : ${response.body}');

        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // print("masuk catch $e");
      return e.toString();
    }
  }

  RxString selectedPatientType = "".obs;

  RxMap<String, dynamic> dataAppointment = <String, dynamic>{}.obs;

  final count = 0.obs;
  RxBool confirmSelected = false.obs;

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
