class Address {
  Address({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  DataAddress? data;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: DataAddress.fromJson(json["data"] as Map<String, dynamic>),
      );
  factory Address.fromJsonError(Map<String, dynamic> json) => Address(
        status: json["status"] as bool,
        message: json["message"].toString(),
        data: DataAddress.fromJson(json["data"] as Map<String, dynamic>),
      );

  factory Address.fromJsonErrorCatch(String json) {
    return Address(message: json, status: false);
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class DataAddress {
  DataAddress({
    this.meta,
    this.address,
  });

  Meta? meta;
  List<AddressElement>? address;

  factory DataAddress.fromJson(Map<String, dynamic> json) => DataAddress(
        meta: Meta.fromJson(json["meta"] as Map<String, dynamic>),
        address: List<AddressElement>.from((json["address"] as List)
            .map((x) => AddressElement.fromJson(x as Map<String, dynamic>))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta!.toJson(),
        "address": List<dynamic>.from(address!.map((x) => x.toJson())),
      };
}

class AddressElement {
  AddressElement({
    this.id,
    this.type,
    this.street,
    this.rtRw,
    this.country,
    this.province,
    this.city,
    this.district,
    this.subDistrict,
    this.latitude,
    this.longitude,
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
  dynamic latitude;
  dynamic longitude;

  factory AddressElement.fromJson(Map<String, dynamic> json) => AddressElement(
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
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "street": street,
        "rt_rw": rtRw,
        "country": country!.toJson(),
        "province": province!.toJson(),
        "city": city!.toJson(),
        "district": district!.toJson(),
        "sub_district": subDistrict!.toJson(),
        "latitude": latitude,
        "longitude": longitude,
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

class Meta {
  Meta({
    this.page,
    this.limit,
    this.totalPage,
    this.totalData,
  });

  int? page;
  int? limit;
  int? totalPage;
  int? totalData;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        page: json["page"] as int,
        limit: json["limit"] as int,
        totalPage: json["total_page"] as int,
        totalData: json["total_data"] as int,
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
        "total_page": totalPage,
        "total_data": totalData,
      };
}
