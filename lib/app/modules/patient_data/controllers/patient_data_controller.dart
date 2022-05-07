// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/data/model/patient_data_model.dart';
import 'package:altea/app/data/model/user.dart';
// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/use_shared_pref.dart';

class PatientDataController extends GetxController {
  final http.Client client = http.Client();

  RxList<User> listPatient = <User>[].obs;

  // UniqueKey keyTile = UniqueKey();
  RxBool isExpanded = false.obs;
  RxInt selectedPatient = (-1).obs;
  RxString selectedPatientType = "".obs;
  Rx<Patient> selectedPatientData = Patient().obs;

  Future<PatientData> getPatientList(String accessToken) async {
    try {
      final response = await client.get(Uri.parse("$alteaURL/user/patient"), headers: {"Authorization": "Bearer $accessToken"});

      if (response.statusCode == 200) {
        // print('hasil 200 => ${response.body}');
        return PatientData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return PatientData.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return PatientData.fromJsonErrorCatch(e.toString());
    }
  }

  Future<void> setPatientFromId(String id) async {
    final token = AppSharedPreferences.getAccessToken();
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/user/patient/$id"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        // print('hasil 200 => ${response.body}');
        selectedPatientData.value = Patient.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else {
        // print("hasil bukan 200");
        // print(response.body);
      }
    } catch (e) {
      // print(e.toString());
      // print("masuk catch $e");
      // return PatientData.fromJsonErrorCatch(e.toString());
    }
  }

  void expandTile() {
    isExpanded.value = true;
    update();
  }

  void shrinkTile() {
    isExpanded.value = false;
    update();
  }

  RxBool refreshPatientDataAndGoToListPatient = false.obs;

  PageController pageController = PageController();
  RxInt currentpage = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    if (refreshPatientDataAndGoToListPatient.value) {
      pageController = PageController(initialPage: 1);
    }
    super.onReady();
  }

  @override
  void onClose() {}
}
