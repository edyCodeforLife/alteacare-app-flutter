import 'package:equatable/equatable.dart';

class Register extends Equatable {
  final String? email;
  final String? phone;
  final String? password;
  final String? passwowrdConfirmation;
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? birthPlace;
  final String? birthCountry;
  final String? cardId;
  final String? gender;
  final bool? status;
  final String? message;
  final Data? data;
  const Register({
    this.phone,
    this.passwowrdConfirmation,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.birthPlace,
    this.birthCountry,
    this.gender,
    this.email,
    this.password,
    this.status,
    this.message,
    this.data,
    this.cardId,
  });

  factory Register.fromJson(Map<String, dynamic> json) => Register(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: Data.fromJson(json["data"] as Map<String, dynamic>),
      );

  factory Register.fromJsonError(Map<String, dynamic> json) => Register(
        status: json["status"] as bool,
        message: json["message"] as String,
      );

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "phone": phone,
      "password": password,
      "password_confirmation": passwowrdConfirmation,
      "first_name": firstName ?? "",
      "last_name": lastName ?? "",
      "birth_date": birthDate ?? "",
      "birth_place": birthPlace ?? "",
      "birth_country": birthCountry ?? "",
      "gender": gender ?? "",
      // "card_id": cardId ?? "",
    };
  }

  @override
  List<Object?> get props =>
      [email, phone, firstName, lastName, passwowrdConfirmation, birthDate, birthPlace, birthCountry, gender, password, status, message, data];
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
