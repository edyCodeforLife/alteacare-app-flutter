class District {
  District({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<DatumDistrict>? data;

  factory District.fromJson(Map<String, dynamic> json) => District(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: List<DatumDistrict>.from(
            (json["data"] as List).map((x) => DatumDistrict.fromJson(x as Map<String, dynamic>))),
      );

  factory District.fromJsonError(Map<String, dynamic> json) {
    return District(
      status: json["status"] as bool,
      message: json["message"] as String,
      data: List<DatumDistrict>.from(
          (json["data"] as List).map((x) => DatumDistrict.fromJson(x as Map<String, dynamic>))),
    );
  }

  factory District.fromJsonErrorCatch(String json) {
    return District(
      message: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DatumDistrict {
  DatumDistrict({
    this.districtId,
    this.name,
    this.city,
  });

  String? districtId;
  String? name;
  City? city;

  factory DatumDistrict.fromJson(Map<String, dynamic> json) => DatumDistrict(
        districtId: json["district_id"] as String,
        name: json["name"] as String,
        city: City.fromJson(json["city"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "district_id": districtId,
        "name": name,
        "city": city!.toJson(),
      };
}

class City {
  City({
    this.cityId,
    this.name,
  });

  String? cityId;
  String? name;

  factory City.fromJson(Map<String, dynamic> json) => City(
        cityId: json["city_id"] as String,
        name: json["name"] as String,
      );

  Map<String, dynamic> toJson() => {
        "city_id": cityId,
        "name": name,
      };
}
