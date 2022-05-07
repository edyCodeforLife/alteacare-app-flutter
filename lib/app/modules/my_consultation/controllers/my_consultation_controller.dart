import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';

import '../../../core/utils/settings.dart';
import '../../../core/utils/use_shared_pref.dart';
import '../../../data/model/list_status_appointment.dart';
import '../../../data/model/my_consultation.dart';

class MyConsultationController extends GetxController with GetSingleTickerProviderStateMixin {
  final HomeController homeController = Get.find<HomeController>();

  late TabController tabController;
  final http.Client client = http.Client();

  List<String> listConsultationStatus = <String>[
    "Berjalan",
    "Riwayat",
    "Dibatalkan",
    "Percakapan",
  ];

  List<String> listConsultationStatusEndpoint = <String>[
    "on-going",
    "history",
    "cancel",
    "Percakapan",
  ];

  RxString searchText = "".obs;
  final myConsultation = Rxn<MyConsultation>();
  RxBool isDescending = true.obs;
  RxBool isLoading = false.obs;

  Future<MyConsultation> getDataConsultationWeb(
    String status, {
    Map<String, dynamic>? body,
  }) async {
    final token = AppSharedPreferences.getAccessToken();
    try {
      final response = await client.post(
          Uri.parse(
            "$alteaURL/appointment/$status",
          ),
          body: jsonEncode(body ?? {}),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          });

      log(response.body.toString());
      print("$alteaURL/appointment/$status");

      if (response.statusCode == 200) {
        myConsultation.value = MyConsultation.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        _myConsultationList.value = myConsultation.value!.data!;
        webSortByDate();

        return MyConsultation.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        print('lho kok');
        print(response.body);
        myConsultation.value = MyConsultation.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
        _myConsultationList.value = [];
        return MyConsultation.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      print(e.toString());
      myConsultation.value = MyConsultation.fromJsonErrorCatch(e.toString());
      return MyConsultation.fromJsonErrorCatch(e.toString());
    }
  }

  final RxList<DatumMyConsultation> _myConsultationList = <DatumMyConsultation>[].obs;
  List<DatumMyConsultation> get myConsultationList => _myConsultationList.toList();

  void webSortByDate() {
    if (myConsultation.value != null) {
      if (myConsultation.value!.data != null) {
        if (isDescending.value) {
          _myConsultationList.sort((a, b) => b.created!.compareTo(a.created!));
        } else {
          myConsultation.value!.data!.sort((a, b) => a.created!.compareTo(b.created!));
        }
      }
    }
  }

  void webSortByDateWithBool(bool isDescending) {
    if (myConsultation.value != null) {
      if (myConsultation.value!.data != null) {
        if (isDescending) {
          _myConsultationList.sort((a, b) => b.created!.compareTo(a.created!));
        } else {
          _myConsultationList.sort((a, b) => a.created!.compareTo(b.created!));
        }
      }
    }
  }

  MetaGetConsultation metaGetConsultation = MetaGetConsultation(page: 0, perPage: 0, total: 0, totalPage: 0);

  Future getConsultation(String url, Map<String, dynamic> body) async {
    // print('tes ${body['page']}');

    // print('body dari future => $body');
    // print('url => "$alteaURL/$url');
    var token = AppSharedPreferences.getAccessToken();
    try {
      if (int.parse(body['page'].toString()) == 1) {
        isLoading.value = true;
      }
      // print("body untuk getConsultation : $body");
      final response = await client.post(Uri.parse("$alteaURL/$url"), body: jsonEncode(body), headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });
      if (int.parse(body['page'].toString()) == 1) {
        isLoading.value = false;
      }
      // print('body => ${jsonDecode(response.body)}');
      // if(response.statusCode == 200 && int.parse(body['page'].toString()) == 1){
      //   metaGetConsultation = MetaGetConsultation.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      // }
      return jsonDecode(response.body);
    } catch (e) {
      // print('errornya ? => $e');
      isLoading.value = false;
      return {"status": false, "message": e.toString()};
    }
  }

  Future getStatus() async {
    var token = AppSharedPreferences.getAccessToken();
    try {
      final response = await client.get(Uri.parse("$alteaURL/appointment/status,"), headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });

      // print('json dataaa => ${jsonDecode(response.body)}');
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  RxString selectMyConsultationStatus = 'ON_GOING'.obs;

  UniqueKey keyTile = UniqueKey();

  RxBool isFilterExpanded = true.obs;

  void expandTile() {
    isFilterExpanded.value = true;
    keyTile = UniqueKey();
    update();
  }

  void shrinkTile() {
    isFilterExpanded.value = false;
    keyTile = UniqueKey();
    update();
  }

  RxList<String> filterList = [
    "Tampilkan Semua",
  ].obs;

  RxList<Datum> filterListFromApi = <Datum>[].obs;

  RxString selectedFilter = "Tampilkan Semua".obs;

  Future<ListStatusAppointment> getListStatusAppointment() async {
    final token = AppSharedPreferences.getAccessToken();

    try {
      final response = await client.get(
          Uri.parse(
            "$alteaURL/appointment/status",
          ),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          });

      if (response.statusCode == 200) {
        return ListStatusAppointment.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return ListStatusAppointment.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return ListStatusAppointment.fromJsonErrorCatch(e.toString());
    }
  }

  void addToFilterListFromApi(ListStatusAppointment lsa) {
    filterListFromApi.value = lsa.data!;
    // print("${selectMyConsultationStatus.value} list status appoint");
    filterList.value = ["Tampilkan Semua"];
    for (final item in filterListFromApi) {
      if (selectMyConsultationStatus.value == item.parent) {
        for (final data in item.child!) {
          filterList.add(data.detail!.label!);
        }
      }
    }
  }

  void addToFilterListFromApiNoAPI() {
    String cekValue = "";
    if (selectMyConsultationStatus.value == "cancel") {
      cekValue = "CANCELED";
    } else if (selectMyConsultationStatus.value == "on-going") {
      cekValue = "ON_GOING";
    } else {
      cekValue = selectMyConsultationStatus.value;
    }
    // print("${cekValue} list status appoint");
    filterList.value = ["Tampilkan Semua"];
    for (final item in filterListFromApi) {
      // print(item.parent);
      // print(item.child);
      if (cekValue == item.parent) {
        for (final data in item.child!) {
          filterList.add(data.detail!.label!);
        }
      }
    }
  }

  Future<ListStatusAppointment> getListStatusAppointmentWeb() async {
    loadingState.value = MCCLoadingState.loading;
    final token = AppSharedPreferences.getAccessToken();

    try {
      final response = await client.get(
          Uri.parse(
            "$alteaURL/appointment/status",
          ),
          headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"});
      print("list status appointment : ${response.statusCode} :: ${response.body}");

      if (response.statusCode == 200) {
        addToFilterListFromApi(ListStatusAppointment.fromJson(jsonDecode(response.body) as Map<String, dynamic>));
        // print(response.body);
        loadingState.value = MCCLoadingState.none;

        return ListStatusAppointment.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        loadingState.value = MCCLoadingState.none;

        return ListStatusAppointment.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      loadingState.value = MCCLoadingState.error;
      return ListStatusAppointment.fromJsonErrorCatch(e.toString());
    }
  }

  void appointmentSearchWeb(String s) {}

  @override
  void onInit() {
    initializeDateFormatting();

    tabController = TabController(vsync: this, length: listConsultationStatus.length);
    homeController.isSelectedTabBeranda.value = false;
    homeController.isSelectedTabDokter.value = false;
    homeController.isSelectedTabKonsultasi.value = true;
    super.onInit();
  }

  @override
  void onReady() {
    if (GetPlatform.isWeb) {
      getListStatusAppointmentWeb();
      // getDataConsultationWeb("on-going");
    }
    super.onReady();
  }

  @override
  void onClose() {}

  Rx<MCCLoadingState> loadingState = MCCLoadingState.none.obs;
}

enum MCCLoadingState { none, error, loading }

class MetaGetConsultation {
  int page;
  int perPage;
  int total;
  int totalPage;

  MetaGetConsultation({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPage,
  });

  factory MetaGetConsultation.fromJson(Map<String, dynamic> json) {
    return MetaGetConsultation(
      page: (json['page'] is int) ? json['page'] as int : 0,
      perPage: (json['per_page'] is int) ? json['per_page'] as int : 0,
      total: (json['total'] is int) ? json['total'] as int : 0,
      totalPage: (json['total_page'] is int) ? json['total_page'] as int : 0,
    );
  }
}
