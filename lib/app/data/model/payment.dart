class Payment {
  Payment({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  DataPayment? data;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: DataPayment.fromJson(json["data"] as Map<String, dynamic>),
      );

  factory Payment.fromJsonError(Map<String, dynamic> json) {
    return Payment(
      status: json["status"] as bool,
      message: json["message"] as String,
    );
  }

  factory Payment.fromJsonErrorCatch(String json) {
    return Payment(
      message: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class DataPayment {
  DataPayment({
    this.type,
    this.bank,
    this.vaNumber,
    this.token,
    this.redirectUrl,
    this.refId,
    this.provider,
    this.total,
    this.expiredAt,
    this.paymentUrl,
  });

  String? type;
  String? bank;
  String? vaNumber;
  String? token;
  String? redirectUrl;
  String? refId;
  String? provider;
  int? total;
  DateTime? expiredAt;
  String? paymentUrl;

  factory DataPayment.fromJson(Map<String, dynamic> json) => DataPayment(
        type: json["type"] as String,
        token: json["token"] == null ? null : json["token"] as String,
        redirectUrl: json["redirect_url"] == null
            ? null
            : json["redirect_url"] as String,
        bank: json["bank"] == null ? null : json["bank"] as String,
        vaNumber:
            json["va_number"] == null ? null : json["va_number"] as String,
        refId: json["ref_id"] as String,
        provider: json["provider"] as String,
        total: json["total"] as int,
        expiredAt: DateTime.parse(json["expiredAt"] as String),
        paymentUrl:
            json["payment_url"] == null ? null : json["payment_url"] as String,
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "bank": bank,
        "va_number": vaNumber,
        "ref_id": refId,
        "provider": provider,
        "total": total,
        "expiredAt": expiredAt!.toIso8601String(),
        "payment_url": paymentUrl,
      };
}
