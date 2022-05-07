// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str) as Map<String, dynamic>);

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  DataUser? data;

  factory User.fromJson(Map<String, dynamic> json) => User(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: DataUser.fromJson(json["data"] as Map<String, dynamic>),
      );
  factory User.fromJsonError(Map<String, dynamic> json) {
    return User(
      status: json["status"] as bool,
      message: json["message"] as String,
    );
  }

  factory User.fromJsonErrorCatch(String json) {
    return User(
      message: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class DataUser {
  DataUser({
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
  List<dynamic>? userAddresses;
  String? status;
  DateTime? registeredAt;
  int? unread;

  factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
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
        userAddresses: List<dynamic>.from((json["user_addresses"] as List).map((x) => x)),
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
        "user_addresses": List<dynamic>.from(userAddresses!.map((x) => x)),
        "status": status,
        "registered_at": registeredAt!.toIso8601String(),
        "unread": unread,
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
  String? sapPatientId;
  String? gender;
  DateTime? birthDate;
  String? birthPlace;
  BirthCountry? birthCountry;
  dynamic? nationality;
  dynamic? photoIdCard;
  dynamic? avatar;
  Age? age;
  dynamic insurance;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        idCard: json["id_card"] as String,
        // sapPatientId: json["sap_patient_id"] == null
        //     ? null
        //     : json["sap_patient_id"] as String,
        gender: json["gender"].toString(),
        birthDate: DateTime.parse(json["birth_date"].toString()),
        birthPlace: json["birth_place"].toString(),
        birthCountry: json['birth_country'] != null ? BirthCountry.fromJson(json["birth_country"] as Map<String, dynamic>) : null,
        nationality: json["nationality"].toString(),
        photoIdCard: json["photo_id_card"],
        avatar: json["avatar"],
        age: Age.fromJson(json["age"] as Map<String, dynamic>),
        // insurance: json["insurance"] == null ? null : json["insurance"],
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
