// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:altea/app/core/utils/use_shared_pref.dart';
import 'package:altea/app/data/model/notification_model.dart';
import 'package:altea/app/core/utils/settings.dart' as settings;

class NotificationsController extends GetxController {
  //TODO: Implement NotificationsController
  final http.Client client = http.Client();

  Future getNotif() async {
    var token = await AppSharedPreferences.getAccessToken();
    try {
      final response = await client.post(
        Uri.parse("${settings.alteaURL}/sender/notification/list"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  RxList<NotificationModel> _notifications = <NotificationModel>[].obs;
  List<NotificationModel> get notifications => _notifications.toList();
  Future getNotifWeb() async {
    var token = await AppSharedPreferences.getAccessToken();
    try {
      final response = await client.post(
        Uri.parse("${settings.alteaURL}/sender/notification/list"),
        headers: {"Authorization": "Bearer $token"},
      );
      log(response.body);

      if (response.statusCode == 200) {
        _notifications.value = (jsonDecode(response.body)["data"] as List).map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
        _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        for (NotificationModel nm in _notifications) {
          final List<String> ss = nm.message.split(" ");
          final int indexWhereIDIs = ss.indexOf("ID:");
          if (indexWhereIDIs != -1) {
            final String idTry = ss[indexWhereIDIs + 1];
            nm.orderId = idTry;
          }
        }
        // return jsonDecode(response.body);
        return jsonDecode(response.body)['data'];
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
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
