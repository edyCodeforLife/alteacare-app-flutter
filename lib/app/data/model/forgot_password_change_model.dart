import 'package:equatable/equatable.dart';

class ForgotPasswordChange extends Equatable {
  final String? password;
  final String? passwordConfirmation;
  final String? message;
  final bool? status;
  final String? data;

  const ForgotPasswordChange({
    this.password,
    this.passwordConfirmation,
    this.message,
    this.status,
    this.data,
  });
  factory ForgotPasswordChange.fromJson(Map<String, dynamic> json) => ForgotPasswordChange(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: json["data"] as String,
      );

  factory ForgotPasswordChange.fromJsonError(String json) => ForgotPasswordChange(message: json);

  Map<String, dynamic> toJson() {
    return {
      "password": password,
      "password_confirmation": passwordConfirmation,
    };
  }

  @override
  List<Object?> get props => [password, passwordConfirmation, message, status, data];
}
