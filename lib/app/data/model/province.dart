class Province {
  Province({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<DatumProvince>? data;

  factory Province.fromJson(Map<String, dynamic> json) => Province(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: List<DatumProvince>.from((json["data"] as List)
            .map((x) => DatumProvince.fromJson(x as Map<String, dynamic>))),
      );

  factory Province.fromJsonError(Map<String, dynamic> json) {
    return Province(
      status: json["status"] as bool,
      message: json["message"] as String,
      data: List<DatumProvince>.from((json["data"] as List)
          .map((x) => DatumProvince.fromJson(x as Map<String, dynamic>))),
    );
  }

  factory Province.fromJsonErrorCatch(String json) {
    return Province(
      message: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DatumProvince {
  DatumProvince({
    this.provinceId,
    this.code,
    this.name,
  });

  String? provinceId;
  String? code;
  String? name;

  factory DatumProvince.fromJson(Map<String, dynamic> json) => DatumProvince(
        provinceId: json["province_id"] as String,
        code: json["code"] as String,
        name: json["name"] as String,
      );

  Map<String, dynamic> toJson() => {
        "province_id": provinceId,
        "code": code,
        "name": name,
      };
}
