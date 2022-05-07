import 'package:equatable/equatable.dart';

class ForgotPassword extends Equatable {
  final String? email;
  final bool? status;
  final String? message;

  const ForgotPassword({this.status, this.message, this.email});

  factory ForgotPassword.fromJson(Map<String, dynamic> json) {
    return ForgotPassword(
      message: json['message'] as String,
      status: json['status'] as bool,
    );
  }

  factory ForgotPassword.fromJsonError(String json) {
    return ForgotPassword(
      message: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {"email": email};
  }

  @override
  List<Object?> get props => [
        email,
        status,
        message,
      ];
}
