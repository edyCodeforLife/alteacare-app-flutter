// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/data/model/patient_data_model.dart';
// import 'package:altea/app/data/model/user.dart';
// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/use_shared_pref.dart' as usp;

enum PatientListState { loading, error, ok, fetch }

class PatientListController extends GetxController {
  final http.Client client = http.Client();

  RxList<Patient> _listPatient = <Patient>[].obs;
  List<Patient> get listPatient => _listPatient.toList();
  Rx<PatientListState> _patientListState = PatientListState.ok.obs;
  PatientListState get patientListState => _patientListState.value;
  RxInt _page = 1.obs;
  int get page => _page.value;
  RxInt _maxPage = 1.obs;
  int get maxPage => _maxPage.value;

  Future<void> getPatientList() async {
    if (page == 1) {
      _patientListState.value = PatientListState.loading;
    } else {
      _patientListState.value = PatientListState.fetch;
    }
    final String token = await usp.AppSharedPreferences.getAccessToken();
    try {
      final response = await client.get(Uri.parse("$alteaURL/user/patient"), headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        // print('hasil 200 => ${response.body}');
        if (page == 1) {
          _listPatient.assignAll((json.decode(response.body)['data']['patient'] as List).map((e) => Patient.fromJson(e)).toList());
        } else {
          _listPatient.addAll((json.decode(response.body)['data']['patient'] as List).map((e) => Patient.fromJson(e)).toList());
        }
        try {
          _maxPage.value = json.decode(response.body)['data']['meta']['total_page'];
        } catch (e) {
          // print("err total page : $e");
        }
        _patientListState.value = PatientListState.ok;

        // return PatientData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        // _listPatient.assignAll([]);
        // return PatientData.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
        _patientListState.value = PatientListState.ok;
      }
    } catch (e, sss) {
      // print(sss);
      // _listPatient.assignAll([]);
      // print("err get patient list $e");
      _patientListState.value = PatientListState.error;

      // print("masuk catch $e");
      // return PatientData.fromJsonErrorCatch(e.toString());
    }
  }

  void nextPatientList() {
    _page.value++;
    getPatientList();
  }

  void resetPage() {
    _page.value = 1;
  }

  // Future<void> setPatientFromId(String id) async {
  //   final token = AppSharedPreferences.getAccessToken();
  //   try {
  //     final response = await client.get(
  //       Uri.parse("$alteaURL/user/patient/$id"),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       // print('hasil 200 => ${response.body}');
  //       selectedPatientData.value = Patient.fromJson(
  //         jsonDecode(response.body) as Map<String, dynamic>,
  //       );
  //     } else {
  //       // print("hasil bukan 200");
  //       // print(response.body);
  //     }
  //   } catch (e) {
  //     // print(e.toString());
  //     // print("masuk catch $e");
  //     // return PatientData.fromJsonErrorCatch(e.toString());
  //   }
  // }

  PageController pageController = PageController();
  RxInt currentpage = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getPatientList();
  }

  @override
  void onClose() {}
}
