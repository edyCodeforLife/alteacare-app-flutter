class MyProfile {
  MyProfile({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  DataMyProfile? data;

  factory MyProfile.fromJson(Map<String, dynamic> json) => MyProfile(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: DataMyProfile.fromJson(json["data"] as Map<String, dynamic>),
      );

  factory MyProfile.fromJsonError(Map<String, dynamic> json) => MyProfile(
        status: json["status"] as bool,
        message: json["message"] as String,
      );

  factory MyProfile.fromJsonErrorCatch(String json) => MyProfile(
        message: json,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class DataMyProfile {
  DataMyProfile({
    this.id,
    this.refId,
    this.email,
    this.phone,
    this.firstName,
    this.lastName,
    this.isVerifiedEmail,
    this.isVerifiedPhone,
    this.userRole,
    this.userDetails,
    this.userAddresses,
    this.status,
    this.registeredAt,
    this.unread,
  });

  String? id;
  String? refId;
  String? email;
  String? phone;
  String? firstName;
  String? lastName;
  bool? isVerifiedEmail;
  bool? isVerifiedPhone;
  List<String>? userRole;
  UserDetails? userDetails;
  List<UserAddress>? userAddresses;
  String? status;
  DateTime? registeredAt;
  int? unread;

  factory DataMyProfile.fromJson(Map<String, dynamic> json) => DataMyProfile(
        id: json["id"] as String,
        refId: json["ref_id"] as String,
        email: json["email"] as String,
        phone: json["phone"] as String,
        firstName: json["first_name"] as String,
        lastName: json["last_name"] as String,
        isVerifiedEmail: json["is_verified_email"] as bool,
        isVerifiedPhone: json["is_verified_phone"] as bool,
        userRole: List<String>.from((json["user_role"] as List).map((x) => x)),
        userDetails: UserDetails.fromJson(json["user_details"] as Map<String, dynamic>),
        userAddresses: List<UserAddress>.from((json["user_addresses"] as List).map((x) => UserAddress.fromJson(x as Map<String, dynamic>))),
        status: json["status"] as String,
        registeredAt: DateTime.parse(json["registered_at"] as String),
        unread: json["unread"] as int,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ref_id": refId,
        "email": email,
        "phone": phone,
        "first_name": firstName,
        "last_name": lastName,
        "is_verified_email": isVerifiedEmail,
        "is_verified_phone": isVerifiedPhone,
        "user_role": List<dynamic>.from(userRole!.map((x) => x)),
        "user_details": userDetails!.toJson(),
        "user_addresses": List<dynamic>.from(userAddresses!.map((x) => x.toJson())),
        "status": status,
        "registered_at": registeredAt!.toIso8601String(),
        "unread": unread,
      };
}

class UserAddress {
  UserAddress({
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

  String? type;
  String? street;
  String? rtRw;
  BirthCountry? country;
  BirthCountry? province;
  City? city;
  City? district;
  SubDistrict? subDistrict;
  dynamic latitude;
  dynamic longitude;

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        type: json["type"] as String,
        street: json["street"] as String,
        rtRw: json["rt_rw"] as String,
        country: BirthCountry.fromJson(json["country"] as Map<String, dynamic>),
        province: BirthCountry.fromJson(json["province"] as Map<String, dynamic>),
        city: City.fromJson(json["city"] as Map<String, dynamic>),
        district: City.fromJson(json["district"] as Map<String, dynamic>),
        subDistrict: SubDistrict.fromJson(json["sub_district"] as Map<String, dynamic>),
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
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

class BirthCountry {
  BirthCountry({
    this.id,
    this.code,
    this.name,
  });

  String? id;
  String? code;
  String? name;

  factory BirthCountry.fromJson(Map<String, dynamic> json) => BirthCountry(
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

class UserDetails {
  UserDetails({
    this.idCard,
    this.sapPatientId,
    this.gender,
    this.birthDate,
    this.birthPlace,
    this.birthCountry,
    this.nationality,
    this.photoIdCard,
    this.avatar,
    this.age,
    this.insurance,
  });

  String? idCard;
  dynamic sapPatientId;
  String? gender;
  DateTime? birthDate;
  String? birthPlace;
  BirthCountry? birthCountry;
  dynamic nationality;
  dynamic photoIdCard;
  dynamic avatar;
  Age? age;
  dynamic insurance;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        idCard: json["id_card"] as String,
        sapPatientId: json["sap_patient_id"],
        gender: json["gender"] as String,
        birthDate: DateTime.parse(json["birth_date"] as String),
        birthPlace: json["birth_place"] as String,
        birthCountry: BirthCountry.fromJson(json["birth_country"] as Map<String, dynamic>),
        nationality: json["nationality"],
        photoIdCard: json["photo_id_card"],
        avatar: json["avatar"],
        age: Age.fromJson(json["age"] as Map<String, dynamic>),
        insurance: json["insurance"],
      );

  Map<String, dynamic> toJson() => {
        "id_card": idCard,
        "sap_patient_id": sapPatientId,
        "gender": gender,
        "birth_date":
            "${birthDate!.year.toString().padLeft(4, '0')}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}",
        "birth_place": birthPlace,
        "birth_country": birthCountry != null ? birthCountry!.toJson() : null,
        "nationality": nationality,
        "photo_id_card": photoIdCard,
        "avatar": avatar,
        "age": age!.toJson(),
        "insurance": insurance,
      };
}

class Age {
  Age({
    this.year,
    this.month,
  });

  int? year;
  int? month;

  factory Age.fromJson(Map<String, dynamic> json) => Age(
        year: json["year"] as int,
        month: json["month"] as int,
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "month": month,
      };
}
