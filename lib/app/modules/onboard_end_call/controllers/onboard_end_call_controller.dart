// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/modules/my_consultation_detail/models/my_consultation_detail_model.dart' as mcdm;
import '../../../core/utils/use_shared_pref.dart';

class OnboardEndCallController extends GetxController {
  //TODO: Implement OnboardEndCallController
  final Rx<OnboardEndCallState> _state = OnboardEndCallState.ok.obs;
  OnboardEndCallState get state => _state.value;

  mcdm.MyConsultationDetail? mcdmForCheck;
  final RxBool _isMyConsultationStatusOK = false.obs;
  bool get isMyConsultationOk => _isMyConsultationStatusOK.value;

  Future<void> checkMyConsultationStatusForNTimes({
    required String status,
    required int times,
    required String orderId,
  }) async {
    // print("mulai cek habis selesai call, sekarang dari on end call screen");
    _isMyConsultationStatusOK.value = false;
    _state.value = OnboardEndCallState.loading;
    final token = AppSharedPreferences.getAccessToken();
    for (int i = 0; i < times; i++) {
      try {
        await Future.delayed(
          const Duration(seconds: 2),
          () async {
            final response = await http.get(
              Uri.parse(
                // "$alteaURL/appointment/detail/$orderId",
                "$alteaURL/appointment/v1/consultation/$orderId",
              ),
              headers: {"Authorization": "Bearer $token"},
            );
            if (response.statusCode == 200) {
              mcdmForCheck = mcdm.MyConsultationDetail.fromJson(jsonDecode(response.body)['data'] as Map<String, dynamic>);
              if (mcdmForCheck!.status == status) {
                _isMyConsultationStatusOK.value = true;
                _state.value = OnboardEndCallState.ok;
                // print("habis selesai call OKOKOKOKOK");
              } else {
                // print("habis selesai call belum waiting for payment ${mcdmForCheck!.status}");
              }
            } else {
              // print("habis selesai call nda 200");
              // print(response.body);
            }
          },
        );
      } catch (e) {
        _isMyConsultationStatusOK.value = false;
      }
    }
    _state.value = OnboardEndCallState.ok;
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

enum OnboardEndCallState { ok, loading, error }
