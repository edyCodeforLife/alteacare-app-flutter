class PaymentType {
  PaymentType({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<DatumPaymentType>? data;

  factory PaymentType.fromJson(Map<String, dynamic> json) => PaymentType(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: List<DatumPaymentType>.from((json["data"] as List)
            .map((x) => DatumPaymentType.fromJson(x as Map<String, dynamic>))),
      );

  factory PaymentType.fromJsonError(Map<String, dynamic> json) {
    return PaymentType(
      status: json["status"] as bool,
      message: json["message"] as String,
      data: List<DatumPaymentType>.from((json["data"] as List)
          .map((x) => DatumPaymentType.fromJson(x as Map<String, dynamic>))),
    );
  }

  factory PaymentType.fromJsonErrorCatch(String json) {
    return PaymentType(
      message: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DatumPaymentType {
  DatumPaymentType({
    this.type,
    this.paymentMethods,
  });

  String? type;
  List<PaymentMethod>? paymentMethods;

  factory DatumPaymentType.fromJson(Map<String, dynamic> json) =>
      DatumPaymentType(
        type: json["type"] as String,
        paymentMethods: List<PaymentMethod>.from(
            (json["payment_methods"] as List)
                .map((x) => PaymentMethod.fromJson(x as Map<String, dynamic>))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "payment_methods":
            List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
      };
}

class PaymentMethod {
  PaymentMethod({
    this.code,
    this.name,
    this.description,
    this.provider,
    this.icon,
    this.data,
  });

  String? code;
  String? name;
  String? description;
  String? provider;
  String? icon;
  dynamic data;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        code: json["code"] as String,
        name: json["name"] as String,
        description: json["description"] as String,
        provider: json["provider"] as String,
        icon: json["icon"] as String,
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "description": description,
        "provider": provider,
        "icon": icon,
        "data": data,
      };
}
