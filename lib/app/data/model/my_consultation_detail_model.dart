class MyConsultationDetailmodel {
  MyConsultationDetailmodel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  DataMyConsultationDetail? data;

  factory MyConsultationDetailmodel.fromJson(Map<String, dynamic> json) => MyConsultationDetailmodel(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: DataMyConsultationDetail.fromJson(json["data"] as Map<String, dynamic>),
      );

  factory MyConsultationDetailmodel.fromJsonError(Map<String, dynamic> json) {
    return MyConsultationDetailmodel(
      status: json["status"] as bool,
      message: json["message"] as String,
    );
  }

  factory MyConsultationDetailmodel.fromJsonErrorCatch(String json) {
    return MyConsultationDetailmodel(
      message: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class DataMyConsultationDetail {
  DataMyConsultationDetail({
    this.id,
    this.orderCode,
    this.userId,
    this.patientId,
    this.refferenceAppointmentId,
    this.consultationMethod,
    this.status,
    this.statusDetail,
    this.symptomNote,
    this.externalAppointmentId,
    this.externalCaseNo,
    this.externalAppointmentError,
    this.externalCaseError,
    this.insName,
    this.insNo,
    this.schedule,
    this.doctor,
    this.user,
    this.patient,
    this.totalPrice,
    this.transaction,
    this.medicalResume,
    this.medicalDocument,
    this.fees,
    this.history,
    this.notes,
    this.notesAt,
    this.notesBy,
    this.canceledNotes,
    this.canceledAt,
    this.canceledBy,
    this.created,
  });

  int? id;
  String? orderCode;
  String? userId;
  String? patientId;
  dynamic refferenceAppointmentId;
  String? consultationMethod;
  String? status;
  StatusDetail? statusDetail;
  dynamic symptomNote;
  String? externalAppointmentId;
  String? externalCaseNo;
  String? externalAppointmentError;
  String? externalCaseError;
  String? insName;
  String? insNo;
  Schedule? schedule;
  Doctor? doctor;
  Patient? user;
  Patient? patient;
  int? totalPrice;
  Transaction? transaction;
  MedicalResume? medicalResume;
  List<MedicalDocument>? medicalDocument;
  List<Fee>? fees;
  List<History>? history;
  dynamic notes;
  dynamic notesAt;
  dynamic notesBy;
  dynamic canceledNotes;
  dynamic canceledAt;
  dynamic canceledBy;
  String? created;

  factory DataMyConsultationDetail.fromJson(Map<String, dynamic> json) {
    // print("dataMyconsultationDetail -> ${json}");
    return DataMyConsultationDetail(
      id: json["id"] == null ? null : json["id"] as int,
      orderCode: json["order_code"] == null ? null : json["order_code"] as String,
      userId: json["user_id"] == null ? null : json["user_id"] as String,
      patientId: json["patient_id"] == null ? null : json["patient_id"] as String,
      refferenceAppointmentId: json["refference_appointment_id"],
      consultationMethod: json["consultation_method"] == null ? null : json["consultation_method"] as String,
      status: json["status"] == null ? null : json["status"] as String,
      statusDetail: StatusDetail.fromJson(json["status_detail"] as Map<String, dynamic>),
      symptomNote: json["symptom_note"],
      externalAppointmentId: json["external_appointment_id"] == null ? null : json["external_appointment_id"] as String,
      externalCaseNo: json["external_case_no"] == null ? null : json["external_case_no"] as String,
      externalAppointmentError: json["external_appointment_error"] == null ? null : json["external_appointment_error"] as String,
      externalCaseError: json["external_case_error"] == null ? null : json["external_case_error"] as String,
      insName: json["ins_name"] == null ? null : json["ins_name"] as String,
      insNo: json["ins_no"] == null ? null : json["ins_no"] as String,
      schedule: Schedule.fromJson(json["schedule"] as Map<String, dynamic>),
      doctor: Doctor.fromJson(json["doctor"] as Map<String, dynamic>),
      user: Patient.fromJson(json["user"] as Map<String, dynamic>),
      patient: Patient.fromJson(json["patient"] as Map<String, dynamic>),
      totalPrice: json["total_price"] as int,
      transaction: Transaction.fromJson(json["transaction"] as Map<String, dynamic>),
      medicalResume: MedicalResume.fromJson(json["medical_resume"] as Map<String, dynamic>),
      medicalDocument: List<MedicalDocument>.from((json["medical_document"] as List).map((x) => MedicalDocument.fromJson(x as Map<String, dynamic>))),
      fees: List<Fee>.from((json["fees"] as List).map((x) => Fee.fromJson(x as Map<String, dynamic>))),
      history: List<History>.from((json["history"] as List).map((x) => History.fromJson(x as Map<String, dynamic>))),
      notes: json["notes"],
      notesAt: json["notes_at"],
      notesBy: json["notes_by"],
      canceledNotes: json["canceled_notes"],
      canceledAt: json["canceled_at"],
      canceledBy: json["canceled_by"],
      created: json["created"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_code": orderCode,
        "user_id": userId,
        "patient_id": patientId,
        "refference_appointment_id": refferenceAppointmentId,
        "consultation_method": consultationMethod,
        "status": status,
        "status_detail": statusDetail!.toJson(),
        "symptom_note": symptomNote,
        "external_appointment_id": externalAppointmentId,
        "external_case_no": externalCaseNo,
        "external_appointment_error": externalAppointmentError,
        "external_case_error": externalCaseError,
        "ins_name": insName,
        "ins_no": insNo,
        "schedule": schedule!.toJson(),
        "doctor": doctor!.toJson(),
        "user": user!.toJson(),
        "patient": patient!.toJson(),
        "total_price": totalPrice,
        "transaction": transaction!.toJson(),
        "medical_resume": medicalResume!.toJson(),
        "medical_document": List<dynamic>.from(medicalDocument!.map((x) => x.toJson())),
        "fees": List<dynamic>.from(fees!.map((x) => x.toJson())),
        "history": List<dynamic>.from(history!.map((x) => x.toJson())),
        "notes": notes,
        "notes_at": notesAt,
        "notes_by": notesBy,
        "canceled_notes": canceledNotes,
        "canceled_at": canceledAt,
        "canceled_by": canceledBy,
        "created": created,
      };
}

class Doctor {
  Doctor({
    this.id,
    this.name,
    this.photo,
    this.specialist,
    this.hospital,
  });

  String? id;
  String? name;
  Photo? photo;
  Specialist? specialist;
  Hospital? hospital;

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json["id"] == null ? null : json["id"] as String,
        name: json["name"] == null ? null : json["name"] as String,
        photo: Photo.fromJson(json["photo"] as Map<String, dynamic>),
        specialist: Specialist.fromJson(json["specialist"] as Map<String, dynamic>),
        hospital: Hospital.fromJson(json["hospital"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photo": photo!.toJson(),
        "specialist": specialist!.toJson(),
        "hospital": hospital!.toJson(),
      };
}

class Hospital {
  Hospital({
    this.id,
    this.name,
    this.logo,
  });

  String? id;
  String? name;
  String? logo;

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
        id: json["id"] == null ? null : json["id"] as String,
        name: json["name"] == null ? null : json["name"] as String,
        logo: json["logo"] == null ? null : json["logo"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo": logo,
      };
}

class Photo {
  Photo({
    this.sizeFormatted,
    this.url,
    this.formats,
  });

  String? sizeFormatted;
  String? url;
  Formats? formats;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        sizeFormatted: json["size_formatted"] == null ? null : json["size_formatted"] as String,
        url: json["url"] == null ? null : json["url"] as String,
        formats: Formats.fromJson(json["formats"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "size_formatted": sizeFormatted,
        "url": url,
        "formats": formats!.toJson(),
      };
}

class Formats {
  Formats({
    this.thumbnail,
    this.large,
    this.medium,
    this.small,
  });

  String? thumbnail;
  String? large;
  String? medium;
  String? small;

  factory Formats.fromJson(Map<String, dynamic> json) => Formats(
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"] as String,
        large: json["large"] == null ? null : json["large"] as String,
        medium: json["medium"] == null ? null : json["medium"] as String,
        small: json["small"] == null ? null : json["small"] as String,
      );

  Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail,
        "large": large,
        "medium": medium,
        "small": small,
      };
}

class Specialist {
  Specialist({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Specialist.fromJson(Map<String, dynamic> json) => Specialist(
        id: json["id"] == null ? null : json["id"] as String,
        name: json["name"] == null ? null : json["name"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Fee {
  Fee({
    this.id,
    this.type,
    this.label,
    this.amount,
    this.status,
    this.createdAt,
  });

  int? id;
  String? type;
  String? label;
  int? amount;
  String? status;
  DateTime? createdAt;

  factory Fee.fromJson(Map<String, dynamic> json) => Fee(
        id: json["id"] as int,
        type: json["type"] == null ? null : json["type"] as String,
        label: json["label"] == null ? null : json["label"] as String,
        amount: json["amount"] as int,
        status: json["status"] == null ? null : json["status"] as String,
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"] as String),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "label": label,
        "amount": amount,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
      };
}

class History {
  History({
    this.id,
    this.status,
    this.label,
    this.description,
    this.icon,
    this.created,
  });

  int? id;
  String? status;
  String? label;
  String? description;
  String? icon;
  String? created;

  factory History.fromJson(Map<String, dynamic> json) => History(
        id: json["id"] as int,
        status: json["status"] == null ? null : json["status"] as String,
        label: json["label"] == null ? null : json["label"] as String,
        description: json["description"] == null ? null : json["description"] as String,
        icon: json["icon"] == null ? null : json["icon"] as String,
        created: json["created"] == null ? null : json["created"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "label": label,
        "description": description,
        "icon": icon,
        "created": created,
      };
}

class MedicalDocument {
  MedicalDocument({
    this.id,
    this.fileId,
    this.url,
    this.originalName,
    this.size,
    this.dateRaw,
    this.date,
    this.uploadByUser,
  });

  int? id;
  String? fileId;
  String? url;
  String? originalName;
  String? size;
  DateTime? dateRaw;
  String? date;
  int? uploadByUser;

  factory MedicalDocument.fromJson(Map<String, dynamic> json) => MedicalDocument(
        id: json["id"] as int,
        fileId: json["file_id"] == null ? null : json["file_id"] as String,
        url: json["url"] == null ? null : json["url"] as String,
        originalName: json["original_name"] == null ? null : json["original_name"] as String,
        size: json["size"] == null ? null : json["size"] as String,
        dateRaw: json["date_raw"] == null ? null : DateTime.parse(json["date_raw"] as String),
        date: json["date"] == null ? null : json["date"] as String,
        uploadByUser: json["upload_by_user"] as int,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "file_id": fileId,
        "url": url,
        "original_name": originalName,
        "size": size,
        "date_raw": dateRaw!.toIso8601String(),
        "date": date,
        "upload_by_user": uploadByUser,
      };
}

class MedicalResume {
  MedicalResume({
    this.id,
    this.symptom,
    this.diagnosis,
    this.drugResume,
    this.additionalResume,
    this.consultation,
    this.notes,
    this.files,
  });

  int? id;
  String? symptom;
  String? diagnosis;
  String? drugResume;
  String? additionalResume;
  String? consultation;
  String? notes;
  List<FileElement>? files;

  factory MedicalResume.fromJson(Map<String, dynamic> json) => MedicalResume(
        id: json["id"] == null ? null : json["id"] as int,
        symptom: json["symptom"] == null ? null : json["symptom"] as String,
        diagnosis: json["diagnosis"] == null ? null : json["diagnosis"] as String,
        drugResume: json["drug_resume"] == null ? null : json["drug_resume"] as String,
        additionalResume: json["additional_resume"] == null ? null : json["additional_resume"] as String,
        consultation: json["consultation"] == null ? null : json["consultation"] as String,
        notes: json["notes"] == null ? null : json["notes"] as String,
        files: List<FileElement>.from((json["files"] as List).map((x) => FileElement.fromJson(x as Map<String, dynamic>))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "symptom": symptom,
        "diagnosis": diagnosis,
        "drug_resume": drugResume,
        "additional_resume": additionalResume,
        "consultation": consultation,
        "notes": notes,
        "files": List<dynamic>.from(files!.map((x) => x.toJson())),
      };
}

class FileElement {
  FileElement({
    this.id,
    this.name,
    this.size,
    this.sizeFormatted,
    this.url,
    this.formats,
  });

  String? id;
  String? name;
  double? size;
  String? sizeFormatted;
  String? url;
  Formats? formats;

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        id: json["id"] == null ? null : json["id"] as String,
        name: json["name"] == null ? null : json["name"] as String,
        size: json["size"] as double,
        sizeFormatted: json["size_formatted"] == null ? null : json["size_formatted"] as String,
        url: json["url"] == null ? null : json["url"] as String,
        formats: Formats.fromJson(json["formats"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "size": size,
        "size_formatted": sizeFormatted,
        "url": url,
        "formats": formats!.toJson(),
      };
}

class Patient {
  Patient({
    this.id,
    this.type,
    this.familyRelationType,
    this.name,
    this.firstName,
    this.lastName,
    this.birthdate,
    this.gender,
    this.phoneNumber,
    this.email,
    this.address,
    this.addressRaw,
    this.cardPhoto,
    this.cardType,
    this.cardId,
    this.age,
    this.avatar,
    this.insurance,
  });

  String? id;
  String? type;
  Specialist? familyRelationType;
  String? name;
  String? firstName;
  String? lastName;
  DateTime? birthdate;
  String? gender;
  String? phoneNumber;
  String? email;
  String? address;
  List<AddressRaw>? addressRaw;
  dynamic cardPhoto;
  String? cardType;
  dynamic cardId;
  Age? age;
  dynamic avatar;
  dynamic insurance;

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json["id"] == null ? null : json["id"] as String,
        type: json["type"] == null ? null : json["type"] as String,
        familyRelationType: Specialist.fromJson(json["family_relation_type"] as Map<String, dynamic>),
        name: json["name"] == null ? null : json["name"] as String,
        firstName: json["first_name"] == null ? null : json["first_name"] as String,
        lastName: json["last_name"] == null ? null : json["last_name"] as String,
        birthdate: json["birthdate"] == null ? null : DateTime.parse(json["birthdate"] as String),
        gender: json["gender"] == null ? null : json["gender"] as String,
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"] as String,
        email: json["email"] == null ? null : json["email"] as String,
        address: json["address"] == null ? null : json["address"] as String,
        addressRaw: List<AddressRaw>.from((json["address_raw"] as List).map((x) => AddressRaw.fromJson(x as Map<String, dynamic>))),
        cardPhoto: json["card_photo"],
        cardType: json["card_type"] == null ? null : json["card_type"] as String,
        cardId: json["card_id"],
        age: Age.fromJson(json["age"] as Map<String, dynamic>),
        avatar: json["avatar"],
        insurance: json["insurance"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "family_relation_type": familyRelationType!.toJson(),
        "name": name,
        "first_name": firstName,
        "last_name": lastName,
        "birthdate":
            "${birthdate!.year.toString().padLeft(4, '0')}-${birthdate!.month.toString().padLeft(2, '0')}-${birthdate!.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "phone_number": phoneNumber,
        "email": email,
        "address": address,
        "address_raw": List<dynamic>.from(addressRaw!.map((x) => x.toJson())),
        "card_photo": cardPhoto,
        "card_type": cardType,
        "card_id": cardId,
        "age": age!.toJson(),
        "avatar": avatar,
        "insurance": insurance,
      };
}

class AddressRaw {
  AddressRaw({
    this.addressId,
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

  String? addressId;
  String? street;
  String? rtRw;
  Country? country;
  Country? province;
  Specialist? city;
  Specialist? district;
  SubDistrict? subDistrict;
  dynamic latitude;
  dynamic longitude;

  factory AddressRaw.fromJson(Map<String, dynamic> json) => AddressRaw(
        addressId: json["address_id"] == null ? null : json["address_id"] as String,
        street: json["street"] == null ? null : json["street"] as String,
        rtRw: json["rt_rw"] == null ? null : json["rt_rw"] as String,
        country: Country.fromJson(json["country"] as Map<String, dynamic>),
        province: Country.fromJson(json["province"] as Map<String, dynamic>),
        city: Specialist.fromJson(json["city"] as Map<String, dynamic>),
        district: Specialist.fromJson(json["district"] as Map<String, dynamic>),
        subDistrict: SubDistrict.fromJson(json["sub_district"] as Map<String, dynamic>),
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "address_id": addressId,
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
        id: json["id"] == null ? null : json["id"] as String,
        code: json["code"] == null ? null : json["code"] as String,
        name: json["name"] == null ? null : json["name"] as String,
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
        id: json["id"] == null ? null : json["id"] as String,
        name: json["name"] == null ? null : json["name"] as String,
        geoArea: json["geo_area"] == null ? null : json["geo_area"] as String,
        postalCode: json["postal_code"] == null ? null : json["postal_code"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "geo_area": geoArea,
        "postal_code": postalCode,
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

class Schedule {
  Schedule({
    this.id,
    this.code,
    this.date,
    this.timeStart,
    this.timeEnd,
    this.scheduleProvider,
  });

  int? id;
  String? code;
  DateTime? date;
  String? timeStart;
  String? timeEnd;
  String? scheduleProvider;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"] as int,
        code: json["code"] == null ? null : json["code"] as String,
        date: json["date"] == null ? null : DateTime.parse(json["date"] as String),
        timeStart: json["time_start"] == null ? null : json["time_start"] as String,
        timeEnd: json["time_end"] == null ? null : json["time_end"] as String,
        scheduleProvider: json["schedule_provider"] == null ? null : json["schedule_provider"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time_start": timeStart,
        "time_end": timeEnd,
        "schedule_provider": scheduleProvider,
      };
}

class StatusDetail {
  StatusDetail({
    this.label,
    this.textColor,
    this.bgColor,
  });

  String? label;
  String? textColor;
  String? bgColor;

  factory StatusDetail.fromJson(Map<String, dynamic> json) => StatusDetail(
        label: json["label"] == null ? null : json["label"] as String,
        textColor: json["text_color"] == null ? null : json["text_color"] as String,
        bgColor: json["bg_color"] == null ? null : json["bg_color"] as String,
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "text_color": textColor,
        "bg_color": bgColor,
      };
}

class Transaction {
  Transaction({
    this.type,
    this.token,
    this.redirectUrl,
    this.refId,
    this.provider,
    this.total,
    this.expiredAt,
    this.detail,
  });

  String? type;
  String? token;
  String? redirectUrl;
  String? refId;
  String? provider;
  int? total;
  DateTime? expiredAt;
  Detail? detail;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        type: json["type"] == null ? null : json["type"] as String,
        token: json["token"] == null ? null : json["token"] as String,
        redirectUrl: json["redirect_url"] == null ? null : json["redirect_url"] as String,
        refId: json["ref_id"] == null ? null : json["ref_id"] as String,
        provider: json["provider"] == null ? null : json["provider"] as String,
        total: json["total"] as int,
        expiredAt: json["expiredAt"] == null ? null : DateTime.parse(json["expiredAt"] as String),
        detail: Detail.fromJson(json["detail"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "token": token,
        "redirect_url": redirectUrl,
        "ref_id": refId,
        "provider": provider,
        "total": total,
        "expiredAt": expiredAt!.toIso8601String(),
        "detail": detail!.toJson(),
      };
}

class Detail {
  Detail({
    this.code,
    this.name,
    this.description,
    this.provider,
    this.icon,
    this.type,
    this.data,
  });

  String? code;
  String? name;
  String? description;
  String? provider;
  String? icon;
  String? type;
  dynamic data;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        code: json["code"] == null ? null : json["code"] as String,
        name: json["name"] == null ? null : json["name"] as String,
        description: json["description"] == null ? null : json["description"] as String,
        provider: json["provider"] == null ? null : json["provider"] as String,
        icon: json["icon"] == null ? null : json["icon"] as String,
        type: json["type"] == null ? null : json["type"] as String,
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "description": description,
        "provider": provider,
        "icon": icon,
        "type": type,
        "data": data,
      };
}
