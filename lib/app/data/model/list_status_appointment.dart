class ListStatusAppointment {
  ListStatusAppointment({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<Datum>? data;

  factory ListStatusAppointment.fromJson(Map<String, dynamic> json) =>
      ListStatusAppointment(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: List<Datum>.from((json["data"] as List)
            .map((x) => Datum.fromJson(x as Map<String, dynamic>))),
      );

  factory ListStatusAppointment.fromJsonError(Map<String, dynamic> json) =>
      ListStatusAppointment(
        status: json["status"] as bool,
        message: json["message"] as String,
      );

  factory ListStatusAppointment.fromJsonErrorCatch(String json) =>
      ListStatusAppointment(
        message: json,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.parent,
    this.child,
  });

  String? parent;
  List<Child>? child;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        parent: json["parent"] as String,
        child: List<Child>.from((json["child"] as List)
            .map((x) => Child.fromJson(x as Map<String, dynamic>))),
      );

  Map<String, dynamic> toJson() => {
        "parent": parent,
        "child": List<dynamic>.from(child!.map((x) => x.toJson())),
      };
}

class Child {
  Child({
    this.code,
    this.detail,
  });

  String? code;
  Detail? detail;

  factory Child.fromJson(Map<String, dynamic> json) => Child(
        code: json["code"] as String,
        detail: Detail.fromJson(json["detail"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "detail": detail!.toJson(),
      };
}

class Detail {
  Detail({
    this.label,
    this.textColor,
    this.bgColor,
  });

  String? label;
  String? textColor;
  String? bgColor;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        label: json["label"] as String,
        textColor: json["textColor"] as String,
        bgColor: json["bgColor"] as String,
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "textColor": textColor,
        "bgColor": bgColor,
      };
}
