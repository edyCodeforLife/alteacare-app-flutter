class AddAddressUser {
  AddAddressUser({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  DataAddress? data;

  factory AddAddressUser.fromJson(Map<String, dynamic> json) => AddAddressUser(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: DataAddress.fromJson(json["data"] as Map<String, dynamic>),
      );

  factory AddAddressUser.fromJsonError(Map<String, dynamic> json) {
    return AddAddressUser(
      status: json["status"] as bool,
      message: json["message"] as String,
      data: DataAddress.fromJson(json["data"] as Map<String, dynamic>),
    );
  }

  factory AddAddressUser.fromJsonErrorCatch(String json) {
    return AddAddressUser(
      message: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class DataAddress {
  DataAddress({
    this.id,
    this.type,
    this.street,
    this.rtRw,
    this.country,
    this.province,
    this.city,
    this.district,
    this.subDistrict,
  });

  String? id;
  String? type;
  String? street;
  String? rtRw;
  Country? country;
  Country? province;
  City? city;
  City? district;
  SubDistrict? subDistrict;

  factory DataAddress.fromJson(Map<String, dynamic> json) => DataAddress(
        id: json["id"] as String,
        type: json["type"] as String,
        street: json["street"] as String,
        rtRw: json["rt_rw"] as String,
        country: Country.fromJson(json["country"] as Map<String, dynamic>),
        province: Country.fromJson(json["province"] as Map<String, dynamic>),
        city: City.fromJson(json["city"] as Map<String, dynamic>),
        district: City.fromJson(json["district"] as Map<String, dynamic>),
        subDistrict:
            SubDistrict.fromJson(json["sub_district"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "street": street,
        "rt_rw": rtRw,
        "country": country!.toJson(),
        "province": province!.toJson(),
        "city": city!.toJson(),
        "district": district!.toJson(),
        "sub_district": subDistrict!.toJson(),
      };
}

class City {
  City({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"] as String,
        name: json["name"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
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

class SubDistrict {
  SubDistrict({
    this.id,
    this.name,
    this.geoArea,
    this.postalCode,
  });

  String? id;
  String? name;
  String? geoArea;
  String? postalCode;

  factory SubDistrict.fromJson(Map<String, dynamic> json) => SubDistrict(
        id: json["id"] as String,
        name: json["name"] as String,
        geoArea: json["geo_area"] as String,
        postalCode: json["postal_code"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "geo_area": geoArea,
        "postal_code": postalCode,
      };
}
