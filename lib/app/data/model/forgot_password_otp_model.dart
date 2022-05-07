import 'package:equatable/equatable.dart';

class ForgotPasswordOtp extends Equatable {
  final String? email;
  final String? otp;
  final bool? status;
  final String? message;
  final Data? data;
  const ForgotPasswordOtp({
    this.email,
    this.otp,
    this.status,
    this.message,
    this.data,
  });

  factory ForgotPasswordOtp.fromJson(Map<String, dynamic> json) => ForgotPasswordOtp(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: Data.fromJson(json["data"] as Map<String, dynamic>),
      );
  factory ForgotPasswordOtp.fromJsonError(Map<String, dynamic> json) => ForgotPasswordOtp(
        status: json["status"] as bool,
        message: json["message"] as String,
      );

  factory ForgotPasswordOtp.fromJsonErrorCatch(String json) => ForgotPasswordOtp(
        message: json,
      );

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "otp": otp,
    };
  }

  @override
  List<Object?> get props => [status, message, data, email, otp];
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
