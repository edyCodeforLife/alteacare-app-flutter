class PaymentByCc {
  PaymentByCc({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  DataPaymentByCc? data;

  factory PaymentByCc.fromJson(Map<String, dynamic> json) => PaymentByCc(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: DataPaymentByCc.fromJson(json["data"] as Map<String, dynamic>),
      );

  factory PaymentByCc.fromJsonError(Map<String, dynamic> json) {
    return PaymentByCc(
      status: json["status"] as bool,
      message: json["message"] as String,
    );
  }

  factory PaymentByCc.fromJsonErrorCatch(String json) {
    return PaymentByCc(
      message: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class DataPaymentByCc {
  DataPaymentByCc({
    this.type,
    this.token,
    this.redirectUrl,
    this.refId,
    this.provider,
    this.total,
    this.expiredAt,
  });

  String? type;
  String? token;
  String? redirectUrl;
  String? refId;
  String? provider;
  int? total;
  DateTime? expiredAt;

  factory DataPaymentByCc.fromJson(Map<String, dynamic> json) =>
      DataPaymentByCc(
        type: json["type"] as String,
        token: json["token"] as String,
        redirectUrl: json["redirect_url"] as String,
        refId: json["ref_id"] as String,
        provider: json["provider"] as String,
        total: json["total"] as int,
        expiredAt: DateTime.parse(json["expiredAt"] as String),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "token": token,
        "redirect_url": redirectUrl,
        "ref_id": refId,
        "provider": provider,
        "total": total,
        "expiredAt": expiredAt!.toIso8601String(),
      };
}
