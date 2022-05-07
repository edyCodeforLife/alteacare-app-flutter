// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:altea/app/data/model/search_doctor.dart';
import '../../../core/utils/settings.dart';
import '../../../data/model/doctor_category_specialist.dart' as doctorSpecialist;

class SearchSpecialistController extends GetxController {
  final http.Client client = http.Client();

  TextEditingController searchSpesialistController = TextEditingController();

  RxList<doctorSpecialist.Datum> spesialisMenus = <doctorSpecialist.Datum>[].obs;

  Future<doctorSpecialist.DoctorSpecialistCategory> getDoctorsPopularCategory() async {
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/specializations/"),
      );

      if (response.statusCode == 200) {
        return doctorSpecialist.DoctorSpecialistCategory.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return doctorSpecialist.DoctorSpecialistCategory.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return doctorSpecialist.DoctorSpecialistCategory.fromJsonErrorCatch(e.toString());
    }
  }

  Future<SearchDoctor> searchDoctor(String query) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/search?_q=$query"),
      );

      if (response.statusCode == 200) {
        return SearchDoctor.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return SearchDoctor.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      return SearchDoctor.fromJsonErrorCatch(e.toString());
    }
  }

  FocusNode searchBarMWFocus = FocusNode();

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
}
