// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/data/model/sign_in_model.dart';

class LoginController extends GetxController {
  RxString email = "".obs;
  RxString phone = "".obs;

  RxString password = "".obs;
  // RxString ygDipakai = "email".obs;
  RxBool isEmailRegistered = true.obs;
  RxBool isPasswordRegistered = true.obs;
  final http.Client client = http.Client();

  RxBool isLoading = false.obs;

  Future<SignIn> signInToUserAccount({required String email, required String password}) async {
    isLoading.value = true;
    // String input = "";
    if(email.isPhoneNumber){

    }else if(email.isEmail){
      print("$email is an email addresss");
    }else{
      print("$email is unknown");
    }
    // final SignIn signInModel = SignIn(email: email, password: password);

    try {
      final response = await client.post(Uri.parse("$alteaURL/user/auth/login"),
          headers: {"Content-Type": "application/json"}, body: jsonEncode({"username" : email, "password" : password}));

      if (response.statusCode == 200) {
        isLoading.value = false;

        return SignIn.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        isLoading.value = false;

        // print(response.body);
        return SignIn.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      isLoading.value = false;

      // print("masuk catch $e");
      return SignIn.fromJsonErrorCatch(e.toString());
    }
  }

  Future<SignIn> signInToUserAccountWithPhone({required String phone, required String password}) async {
    isLoading.value = true;
    // final SignIn signInModel = SignIn(email: phone, password: password);

    try {
      final response = await client.post(Uri.parse("$alteaURL/user/auth/login"),
          headers: {"Content-Type": "application/json"}, body: jsonEncode({"username" : phone, "password" : password}));

      if (response.statusCode == 200) {
        isLoading.value = false;

        return SignIn.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        isLoading.value = false;

        // print(response.body);
        return SignIn.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      isLoading.value = false;

      // print("masuk catch $e");
      return SignIn.fromJsonErrorCatch(e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.dispose();
  }
}
