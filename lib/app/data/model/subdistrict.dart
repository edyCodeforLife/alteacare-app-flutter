class SubDistrict {
  SubDistrict({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<DatumSubDistrict>? data;

  factory SubDistrict.fromJson(Map<String, dynamic> json) => SubDistrict(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: List<DatumSubDistrict>.from((json["data"] as List)
            .map((x) => DatumSubDistrict.fromJson(x as Map<String, dynamic>))),
      );

  factory SubDistrict.fromJsonError(Map<String, dynamic> json) {
    return SubDistrict(
      status: json["status"] as bool,
      message: json["message"] as String,
      data: List<DatumSubDistrict>.from((json["data"] as List)
          .map((x) => DatumSubDistrict.fromJson(x as Map<String, dynamic>))),
    );
  }

  factory SubDistrict.fromJsonErrorCatch(String json) {
    return SubDistrict(
      message: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DatumSubDistrict {
  DatumSubDistrict({
    this.subDistrictId,
    this.name,
    this.postalCode,
    this.geoArea,
    this.district,
    this.city,
    this.country,
  });

  String? subDistrictId;
  String? name;
  String? postalCode;
  String? geoArea;
  District? district;
  City? city;
  Country? country;

  factory DatumSubDistrict.fromJson(Map<String, dynamic> json) =>
      DatumSubDistrict(
        subDistrictId: json["sub_district_id"] as String,
        name: json["name"] as String,
        postalCode: json["postal_code"] as String,
        geoArea: json["geo_area"] as String,
        district: District.fromJson(json["district"] as Map<String, dynamic>),
        city: City.fromJson(json["city"] as Map<String, dynamic>),
        country: Country.fromJson(json["country"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "sub_district_id": subDistrictId,
        "name": name,
        "postal_code": postalCode,
        "geo_area": geoArea,
        "district": district!.toJson(),
        "city": city!.toJson(),
        "country": country!.toJson(),
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

class Country {
  Country({
    this.countryId,
    this.name,
    this.code,
  });

  String? countryId;
  String? name;
  String? code;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
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

class District {
  District({
    this.districtId,
    this.name,
  });

  String? districtId;
  String? name;

  factory District.fromJson(Map<String, dynamic> json) => District(
        districtId: json["district_id"] as String,
        name: json["name"] as String,
      );

  Map<String, dynamic> toJson() => {
        "district_id": districtId,
        "name": name,
      };
}
