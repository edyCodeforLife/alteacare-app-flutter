// To parse this JSON data, do
//
//     final patientData = patientDataFromJson(jsonString);

// PatientData patientDataFromJson(String str) =>
//     PatientData.fromJson(jsonDecode(str));
//
// String patientDataToJson(PatientData data) => json.encode(data.toJson());

class PatientData {
  PatientData({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  Data? data;

  factory PatientData.fromJson(Map<String, dynamic> json) {
    // print('json patientData => $json');
    return PatientData(
      status: json["status"] as bool,
      message: json["message"].toString(),
      data: Data.fromJson(json["data"] as Map<String, dynamic>),
    );
  }

  factory PatientData.fromJsonError(Map<String, dynamic> json) => PatientData(
        status: json["status"] as bool,
        message: json["message"].toString(),
        data: Data.fromJson(json["data"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };

  factory PatientData.fromJsonErrorCatch(String json) {
    return PatientData(message: json, status: false);
  }
}

class Data {
  Data({
    this.meta,
    required this.patient,
  });

  Meta? meta;
  List<Patient> patient;

  factory Data.fromJson(Map<String, dynamic> json) {
    // print('jsonnn => ${json['patient']}');
    List patients = json['patient'] as List;
    // print('patients => $patients');
    return Data(
      meta: Meta.fromJson(json["meta"] as Map<String, dynamic>),
      patient: patients.map((a) {
        // print('a => $a');
        return Patient.fromJson(a as Map<String, dynamic>);
      }).toList(),
    );
  }
  Map<String, dynamic> toJson() => {
        "meta": meta!.toJson(),
        "patient": List<dynamic>.from(patient.map((x) => x.toJson())),
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

  factory Meta.fromJson(Map<String, dynamic> json) {
    // print('metaaa =>$json');
    return Meta(
      page: json["page"] as int,
      limit: json["limit"] as int,
      totalPage: json["total_page"] as int,
      totalData: json["total_data"] as int,
    );
  }
  Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
        "total_page": totalPage,
        "total_data": totalData,
      };
}

class Patient {
  Patient({
    this.id,
    this.refId,
    this.familyRelationType,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
    this.birthCountry,
    this.birthPlace,
    this.birthDate,
    this.age,
    this.nationality,
    this.street,
    this.rtRw,
    this.country,
    this.province,
    this.city,
    this.district,
    this.subDistrict,
    this.cardType,
    this.cardId,
    this.cardPhoto,
    this.addressId,
    this.externalPatientId,
    this.insurance,
    this.status,
    this.isValid,
  });

  String? id;
  String? refId;
  City? familyRelationType;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? gender;
  BirthCountry? birthCountry;
  String? birthPlace;
  DateTime? birthDate;
  Age? age;
  BirthCountry? nationality;
  String? street;
  String? rtRw;
  BirthCountry? country;
  BirthCountry? province;
  City? city;
  City? district;
  SubDistrict? subDistrict;
  String? cardType;
  String? cardId;
  String? cardPhoto;
  String? addressId;
  dynamic? externalPatientId;
  dynamic? insurance;
  String? status;
  bool? isValid;

  factory Patient.fromJson(Map<String, dynamic> json) {
    // print('patientttt =>$json');
    //   return Patient(
    //     id: json["id"] as String,
    //     refId: json["ref_id"] as String,
    //     familyRelationType:
    //         City.fromJson(json["family_relation_type"] as Map<String, dynamic>),
    //     firstName: json["first_name"] as String,
    //     lastName: json["last_name"] as String,
    //     email: json["email"] as String,
    //     phone: json["phone"] as String,
    //     gender: json["gender"] as String,
    //     birthCountry:
    //         BirthCountry.fromJson(json["birth_country"] as Map<String, dynamic>),
    //     birthPlace: json["birth_place"] as String,
    //     birthDate: DateTime.parse(json["birth_date"] as String),
    //     age: Age.fromJson(json["age"] as Map<String, dynamic>),
    //     nationality: json["nationality"] == null
    //         ? BirthCountry.fromJson({"": ""})
    //         : BirthCountry.fromJson(json["nationality"] as Map<String, dynamic>),
    //     street: json["street"] as String,
    //     rtRw: json["rt_rw"] as String,
    //     country: BirthCountry.fromJson(json["country"] as Map<String, dynamic>),
    //     province: BirthCountry.fromJson(json["province"] as Map<String, dynamic>),
    //     city: City.fromJson(json["city"] as Map<String, dynamic>),
    //     district: City.fromJson(json["district"] as Map<String, dynamic>),
    //     subDistrict:
    //         SubDistrict.fromJson(json["sub_district"] as Map<String, dynamic>),
    //     cardType: json["card_type"] as String,
    //     cardId: json["card_id"] as String,
    //     cardPhoto:
    //         json["card_photo"] == null ? ' ' : json["card_photo"].toString(),
    //     addressId: json["address_id"] as String,
    //     externalPatientId: json["external_patient_id"],
    //     insurance: json["insurance"],
    //     status: json["status"] as String,
    //     isValid: json["is_valid"] as bool,
    //   );
    // }
    //   try {
    //     return Patient(
    //       id: json["id"] as String,
    //       refId: json["ref_id"] as String,
    //       familyRelationType:
    //           City.fromJson(json["family_relation_type"] as Map<String, dynamic>),
    //       firstName: json["first_name"] as String,
    //       lastName: json["last_name"] as String,
    //       email: json["email"] as String,
    //       phone: json["phone"] as String,
    //       gender: json["gender"] as String,
    //       birthCountry: BirthCountry.fromJson(
    //           json["birth_country"] as Map<String, dynamic>),
    //       birthPlace: json["birth_place"] as String,
    //       birthDate: DateTime.parse(json["birth_date"] as String),
    //       age: Age.fromJson(json["age"] as Map<String, dynamic>),
    //       nationality:
    //           BirthCountry.fromJson(json["nationality"] as Map<String, dynamic>),
    //       street: json["street"] as String,
    //       rtRw: json["rt_rw"] as String,
    //       country: BirthCountry.fromJson(json["country"] as Map<String, dynamic>),
    //       province:
    //           BirthCountry.fromJson(json["province"] as Map<String, dynamic>),
    //       city: City.fromJson(json["city"] as Map<String, dynamic>),
    //       district: City.fromJson(json["district"] as Map<String, dynamic>),
    //       subDistrict:
    //           SubDistrict.fromJson(json["sub_district"] as Map<String, dynamic>),
    //       cardType: json["card_type"] as String,
    //       cardId: json["card_id"] as String,
    //       cardPhoto:
    //           json["card_photo"] == null ? ' ' : json["card_photo"].toString(),
    //       addressId: json["address_id"] as String,
    //       externalPatientId: json["external_patient_id"],
    //       insurance: json["insurance"],
    //       status: json["status"] as String,
    //       isValid: json["is_valid"] as bool,
    //     );
    //   } catch (e) {
    //     print('error patient => $e');
    //     return Patient(
    //       id: json["id"] as String,
    //       refId: json["ref_id"] as String,
    //       familyRelationType:
    //           City.fromJson(json["family_relation_type"] as Map<String, dynamic>),
    //       firstName: json["first_name"] as String,
    //       lastName: json["last_name"] as String,
    //       email: json["email"] as String,
    //       phone: json["phone"] as String,
    //       gender: json["gender"] as String,
    //       birthCountry: BirthCountry.fromJson(
    //           json["birth_country"] as Map<String, dynamic>),
    //       birthPlace: json["birth_place"] as String,
    //       birthDate: DateTime.parse(json["birth_date"] as String),
    //       age: Age.fromJson(json["age"] as Map<String, dynamic>),
    //       nationality:
    //           BirthCountry.fromJson(json["nationality"] as Map<String, dynamic>),
    //       street: json["street"] as String,
    //       rtRw: json["rt_rw"] as String,
    //       country: BirthCountry.fromJson(json["country"] as Map<String, dynamic>),
    //       province:
    //           BirthCountry.fromJson(json["province"] as Map<String, dynamic>),
    //       city: City.fromJson(json["city"] as Map<String, dynamic>),
    //       district: City.fromJson(json["district"] as Map<String, dynamic>),
    //       subDistrict:
    //           SubDistrict.fromJson(json["sub_district"] as Map<String, dynamic>),
    //       cardType: json["card_type"] as String,
    //       cardId: json["card_id"] as String,
    //       cardPhoto:
    //           json["card_photo"] == null ? null : json["card_photo"].toString(),
    //       addressId: json["address_id"] as String,
    //       externalPatientId: json["external_patient_id"],
    //       insurance: json["insurance"],
    //       status: json["status"] as String,
    //       isValid: json["is_valid"] as bool,
    //     );
    //   }
    // }

    // print('patientttt =>${json["first_name"]}');
    Patient patient = Patient();
    try {
      patient = Patient(
        id: json["id"] as String,
        refId: json["ref_id"] as String,
        familyRelationType:
            City.fromJson(json["family_relation_type"] == null ? {"id": " ", "name": " "} : json["family_relation_type"] as Map<String, dynamic>),
        firstName: json["first_name"] as String,
        lastName: json["last_name"] as String,
        email: json["email"] as String,
        phone: json["phone"] as String,
        gender: json["gender"] as String,
        birthCountry: BirthCountry.fromJson(
            json["birth_country"] == null ? {"id": " ", "name": "", "code": " "} : json["birth_country"] as Map<String, dynamic>),
        birthPlace: json["birth_place"] as String,
        birthDate: DateTime.parse(json["birth_date"] as String),
        age: Age.fromJson(json["age"] == null ? {"year": 0, "month": 0} : json["age"] as Map<String, dynamic>),
        nationality:
            BirthCountry.fromJson(json["nationality"] == null ? {"id": " ", "code": " ", "name": " "} : json['nationality'] as Map<String, dynamic>),
        street: json["street"] == null ? " " : json["street"] as String,
        rtRw: json["rt_rw"] == null ? " " : json["rt_rw"] as String,
        country: BirthCountry.fromJson(json["country"] == null ? {"id": " ", "code": " ", "name": " "} : json["country"] as Map<String, dynamic>),
        province: BirthCountry.fromJson(json["province"] == null ? {"id": " ", "code": " ", "name": " "} : json["province"] as Map<String, dynamic>),
        city: City.fromJson(json["city"] == null ? {"id": " ", "name": " "} : json["city"] as Map<String, dynamic>),
        district: City.fromJson(json["district"] == null ? {"id": " ", "name": " "} : json["district"] as Map<String, dynamic>),
        subDistrict: SubDistrict.fromJson(json["sub_district"] == null
            ? {"id": " ", "name": " ", "geo_area": " ", "postal_code": " "}
            : json["sub_district"] as Map<String, dynamic>),
        cardType: json["card_type"] == null ? " " : json["card_type"] as String,
        cardId: json["card_id"] == null ? " " : json["card_id"] as String,
        cardPhoto: json["card_photo"] == null ? " " : json["card_photo"].toString(),
        addressId: json["address_id"] == null ? " " : json["address_id"] as String,
        externalPatientId: json["external_patient_id"] == null ? " " : json["external_patient_id"] as Map<String, dynamic>,
        insurance: json["insurance"] == null ? " " : json["insurance"] as String,
        status: json["status"] as String,
        isValid: json["is_valid"] as bool,
      );
    } catch (e) {
      // print('error patient data => $e');
    }

    // print("patient => $patient");

    return patient;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "ref_id": refId,
        "family_relation_type": familyRelationType!.toJson(),
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "gender": gender,
        "birth_country": birthCountry != null ? birthCountry!.toJson() : null,
        "birth_place": birthPlace,
        "birth_date":
            "${birthDate!.year.toString().padLeft(4, '0')}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}",
        "age": age!.toJson(),
        "nationality": nationality!.toJson(),
        "street": street,
        "rt_rw": rtRw,
        "country": country!.toJson(),
        "province": province!.toJson(),
        "city": city!.toJson(),
        "district": district!.toJson(),
        "sub_district": subDistrict!.toJson(),
        "card_type": cardType,
        "card_id": cardId,
        "card_photo": cardPhoto,
        "address_id": addressId,
        "external_patient_id": externalPatientId,
        "insurance": insurance,
        "status": status,
        "is_valid": isValid,
      };
}

class Age {
  Age({
    this.year,
    this.month,
  });

  int? year;
  int? month;

  factory Age.fromJson(Map<String, dynamic> json) {
    // print('age => $json');
    return Age(
      year: json["year"] as int,
      month: json["month"] as int,
    );
  }

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

  factory BirthCountry.fromJson(Map<String, dynamic> json) {
    // print("birth country => $json");
    return BirthCountry(
      id: json["id"] as String,
      code: json["code"] as String,
      name: json["name"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
      };
}

class City {
  City({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory City.fromJson(Map<String, dynamic> json) {
    // print('city => $json');
    return City(
      id: json["id"] as String,
      name: json["name"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
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

  factory SubDistrict.fromJson(Map<String, dynamic> json) {
    // print("subdistrict =>$json");
    return SubDistrict(
      id: json["id"] as String,
      name: json["name"] as String,
      geoArea: json["geo_area"] as String,
      postalCode: json["postal_code"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "geo_area": geoArea,
        "postal_code": postalCode,
      };
}
