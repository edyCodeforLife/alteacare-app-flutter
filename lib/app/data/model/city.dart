class City {
  City({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<DatumCity>? data;

  factory City.fromJson(Map<String, dynamic> json) => City(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: List<DatumCity>.from((json["data"] as List)
            .map((x) => DatumCity.fromJson(x as Map<String, dynamic>))),
      );

  factory City.fromJsonError(Map<String, dynamic> json) {
    return City(
      status: json["status"] as bool,
      message: json["message"] as String,
      data: List<DatumCity>.from((json["data"] as List)
          .map((x) => DatumCity.fromJson(x as Map<String, dynamic>))),
    );
  }

  factory City.fromJsonErrorCatch(String json) {
    return City(
      message: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DatumCity {
  DatumCity({
    this.cityId,
    this.name,
    this.country,
    this.province,
  });

  String? cityId;
  String? name;
  Country? country;
  Country? province;

  factory DatumCity.fromJson(Map<String, dynamic> json) => DatumCity(
        cityId: json["city_id"] as String,
        name: json["name"] as String,
        country: Country.fromJson(json["country"] as Map<String, dynamic>),
        province: Country.fromJson(json["province"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "city_id": cityId,
        "name": name,
        "country": country!.toJson(),
        "province": province!.toJson(),
      };
}

class Country {
  Country({
    this.id,
    this.code,
    this.name,
  });

  String? id;
  String? code;
  String? name;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"] as String,
        code: json["code"] as String,
        name: json["name"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
      };
}
