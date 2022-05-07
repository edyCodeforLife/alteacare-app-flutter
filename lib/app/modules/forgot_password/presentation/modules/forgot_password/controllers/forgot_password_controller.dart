// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import '../../../../../../core/utils/settings.dart';
import '../../../../../../data/model/forgot_password_change_model.dart';
import '../../../../../../data/model/forgot_password_model.dart';
import '../../../../../../data/model/forgot_password_otp_model.dart';

class ForgotPasswordController extends GetxController {
  RxString phoneNum = ''.obs;
  RxString email = ''.obs;
  RxString otp = ''.obs;
  RxString password = ''.obs;
  RxString confirmPassword = ''.obs;
  RxBool isEmailRegistered = true.obs;
  RxBool isOtpCorrect = true.obs;

  RxString tokenOtp = ''.obs;
  RxString tokenChangePassword = ''.obs;

  final http.Client client = http.Client();

  Future<ForgotPassword> forgotPasswordAccount({required String email}) async {
    final ForgotPassword forgotPasswordModel = ForgotPassword(email: email);
    try {
      final response = await client.post(Uri.parse("$alteaURL/user/password/forgot"), body: forgotPasswordModel.toJson());

      if (response.statusCode == 200) {
        return ForgotPassword.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return ForgotPassword.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("error catch -> $e");
      return ForgotPassword.fromJsonError(e.toString());
    }
  }

  Future<ForgotPasswordOtp> forgotPasswordOtp({required String email, required String otp}) async {
    final ForgotPasswordOtp forgotPasswordOtpModel = ForgotPasswordOtp(email: email, otp: otp);
    try {
      final response = await client.post(Uri.parse("$alteaURL/user/password/verify"), body: forgotPasswordOtpModel.toJson());

      // print('statusCode => ${response.statusCode}');
      // print('body => ${response.body}');
      if (response.statusCode == 200) {
        return ForgotPasswordOtp.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return ForgotPasswordOtp.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      return ForgotPasswordOtp.fromJsonErrorCatch(e.toString());
    }
  }

  Future<ForgotPasswordChange> forgotPasswordChangeAccount({required String password, required String passwordConfirmation}) async {
    final ForgotPasswordChange forgotPasswordChangeModel = ForgotPasswordChange(password: password, passwordConfirmation: passwordConfirmation);
    try {
      final response = await client.post(
          Uri.parse(
            "$alteaURL/user/password/change",
          ),
          headers: {
            'Authorization': 'Bearer ${tokenChangePassword.value}',
          },
          body: forgotPasswordChangeModel.toJson());
      if (response.statusCode == 200) {
        return ForgotPasswordChange.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return ForgotPasswordChange.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      return ForgotPasswordChange.fromJsonError(e.toString());
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
  void onClose() {}
}
