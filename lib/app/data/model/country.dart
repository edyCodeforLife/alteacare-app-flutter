class Country {
  Country({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<DatumCountry>? data;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: List<DatumCountry>.from((json["data"] as List)
            .map((x) => DatumCountry.fromJson(x as Map<String, dynamic>))),
      );

  factory Country.fromJsonError(Map<String, dynamic> json) {
    return Country(
      status: json["status"] as bool,
      message: json["message"] as String,
      data: List<DatumCountry>.from((json["data"] as List)
          .map((x) => DatumCountry.fromJson(x as Map<String, dynamic>))),
    );
  }

  factory Country.fromJsonErrorCatch(String json) {
    return Country(
      message: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DatumCountry {
  DatumCountry({
    this.countryId,
    this.name,
    this.code,
  });

  String? countryId;
  String? name;
  String? code;

  factory DatumCountry.fromJson(Map<String, dynamic> json) => DatumCountry(
        countryId: json["country_id"] as String,
        name: json["name"] as String,
        code: json["code"] as String,
      );

  Map<String, dynamic> toJson() => {
        "country_id": countryId,
        "name": name,
        "code": code,
      };
}
