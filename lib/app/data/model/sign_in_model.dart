import 'package:equatable/equatable.dart';

class SignIn extends Equatable {
  final String? email;
  final String? password;
  final bool? status;
  final String? message;
  final Data? data;
  const SignIn({
    this.email,
    this.password,
    this.status,
    this.message,
    this.data,
  });

  factory SignIn.fromJson(Map<String, dynamic> json) => SignIn(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: Data.fromJson(json["data"] as Map<String, dynamic>),
      );
  factory SignIn.fromJsonError(Map<String, dynamic> json) => SignIn(
        status: json["status"] as bool,
        message: json["message"] as String,
      );

  factory SignIn.fromJsonErrorCatch(String json) => SignIn(
        message: json,
      );

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
    };
  }

  @override
  List<Object?> get props => [email, password, status, message, data];
}

class Data extends Equatable {
  const Data({
    this.isRegistered,
    this.isVerified,
    this.accessToken,
    this.refreshToken,
    this.isEmailVerified,
    this.isPhoneVerified,
    this.deviceId,
  });

  final bool? isRegistered;
  final bool? isVerified;
  final String? accessToken;
  final String? refreshToken;
  final bool? isEmailVerified;
  final bool? isPhoneVerified;
  final String? deviceId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isRegistered: json["is_registered"] as bool,
        isVerified: json["is_verified"] as bool,
        accessToken: json["access_token"] as String,
        refreshToken: json["refresh_token"] as String,
        isEmailVerified: json["is_email_verified"] as bool,
        isPhoneVerified: json["is_phone_verified"] as bool,
        deviceId: json["device_id"] as String,
      );

  @override
  List<Object?> get props => [isRegistered, isVerified, accessToken, refreshToken, isEmailVerified, isPhoneVerified, deviceId];
}
