class MyConsultation {
  MyConsultation({
    this.status,
    this.message,
    this.meta,
    this.data,
  });

  bool? status;
  String? message;
  Meta? meta;
  List<DatumMyConsultation>? data;

  factory MyConsultation.fromJson(Map<String, dynamic> json) => MyConsultation(
        status: json["status"] as bool,
        message: json["message"] == null ? null : json["message"] as String,
        meta: Meta.fromJson(json["meta"] as Map<String, dynamic>),
        data: List<DatumMyConsultation>.from((json["data"] as List).map(
            (x) => DatumMyConsultation.fromJson(x as Map<String, dynamic>))),
      );

  factory MyConsultation.fromJsonError(Map<String, dynamic> json) {
    return MyConsultation(
      status: json["status"] as bool,
      message: json["message"] == null ? null : json['message'] as String,
    );
  }

  factory MyConsultation.fromJsonErrorCatch(String json) {
    return MyConsultation(
      message: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "meta": meta!.toJson(),
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DatumMyConsultation {
  DatumMyConsultation({
    this.id,
    this.orderCode,
    this.userId,
    this.patientId,
    this.consultationMethod,
    this.status,
    this.statusDetail,
    this.schedule,
    this.doctor,
    this.user,
    this.patient,
    this.totalPrice,
    this.transaction,
    this.created,
    this.canceledAt,
  });

  int? id;
  String? orderCode;
  String? userId;
  String? patientId;
  String? consultationMethod;
  String? status;
  StatusDetail? statusDetail;
  Schedule? schedule;
  Doctor? doctor;
  Patient? user;
  Patient? patient;
  int? totalPrice;
  Transaction? transaction;
  String? created;
  String? canceledAt;

  factory DatumMyConsultation.fromJson(Map<String, dynamic> json) {
    return DatumMyConsultation(
      id: json["id"] as int,
      orderCode: json["order_code"] == null ? null : json["order_code"] as String,
      userId: json["user_id"] == null ? null : json["user_id"] as String,
      patientId:
          json["patient_id"] == null ? null : json["patient_id"] as String,
      consultationMethod: json["consultation_method"] ==null ? null : json["consultation_method"] as String,
      status: json["status"] == null ? null : json["status"] as String,
      statusDetail: json["status_detail"] == null
          ? null
          : StatusDetail.fromJson(
              json["status_detail"] as Map<String, dynamic>),
      schedule: json["schedule"] == null
          ? null
          : Schedule.fromJson(json["schedule"] as Map<String, dynamic>),
      doctor: json["doctor"] == null
          ? null
          : Doctor.fromJson(json["doctor"] as Map<String, dynamic>),
      user: json["user"] == null
          ? null
          : Patient.fromJson(json["user"] as Map<String, dynamic>),
      patient: json["patient"] == null
          ? null
          : Patient.fromJson(json["patient"] as Map<String, dynamic>),
      totalPrice: json["total_price"] as int,
      transaction: json["transaction"] == null
          ? null
          : Transaction.fromJson(json["transaction"] as Map<String, dynamic>),
      created: json['created'] == null ? null : json['created'] as String,
      canceledAt:  json['canceled_at'] == null ? null : json['canceled_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_code": orderCode,
        "user_id": userId,
        "patient_id": patientId,
        "consultation_method": consultationMethod,
        "status": status,
        "status_detail": statusDetail!.toJson(),
        "schedule": schedule!.toJson(),
        "doctor": doctor!.toJson(),
        "user": user!.toJson(),
        "patient": patient!.toJson(),
        "total_price": totalPrice,
        "transaction": transaction == null ? null : transaction!.toJson(),
        "created": created,
        "canceled_at": canceledAt,
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
        id: json["id"] == null ? null : json['id']as String,
        name: json["name"] == null ? null : json["name"] as String,
        photo: json["photo"] == null
            ? null
            : Photo.fromJson(json["photo"] as Map<String, dynamic>),
        specialist: json["specialist"] == null
            ? null
            : Specialist.fromJson(json["specialist"] as Map<String, dynamic>),
        hospital: json["hospital"] == null
            ? null
            : Hospital.fromJson(json["hospital"] as Map<String, dynamic>),
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
        id: json["id"] == null ? null : json['id'] as String,
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
        sizeFormatted: json["size_formatted"] as String,
        url: json["url"] as String,
        formats: json["formats"] == null
            ? null
            : Formats.fromJson(json["formats"] as Map<String, dynamic>),
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
        thumbnail: json["thumbnail"] as String,
        large: json["large"] as String,
        medium: json["medium"] as String,
        small: json["small"] as String,
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
        id: json["id"] as String,
        name: json["name"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
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
  });

  String? id;
  String? type;
  Specialist? familyRelationType;
  String? name;
  String? firstName;
  String? lastName;

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json["id"] == null ? null : json["id"] as String,
        type: json["type"] == null ? null : json["type"] as String,
        familyRelationType: json["family_relation_type"] == null
            ? null
            : Specialist.fromJson(
                json["family_relation_type"] as Map<String, dynamic>),
        name: json["name"] == null ? null : json["name"] as String,
        firstName: json["first_name"] == null ? null : json["first_name"] as String,
        lastName: json["last_name"] == null ? null : json["last_name"]  as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "family_relation_type": familyRelationType!.toJson(),
        "name": name,
        "first_name": firstName,
        "last_name": lastName,
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
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
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
    this.bank,
    this.vaNumber,
    this.refId,
    this.provider,
    this.total,
    this.expiredAt,
    this.paymentUrl,
    this.detail,
    this.token,
    this.redirectUrl,
  });

  String? type;
  String? bank;
  String? vaNumber;
  String? refId;
  String? provider;
  int? total;
  DateTime? expiredAt;
  String? paymentUrl;
  Detail? detail;
  String? token;
  String? redirectUrl;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        type: json["type"] == null ? null : json["type"] as String,
        bank: json["bank"] == null ? null : json["bank"] as String,
        vaNumber:
            json["va_number"] == null ? null : json["va_number"] as String,
        refId: json["ref_id"] == null ? null : json["ref_id"] as String,
        provider: json["provider"] == null ? null : json["provider"]  as String,
        total: json["total"] as int,
        expiredAt: json["expiredAt"] == null ? null : DateTime.parse(json["expiredAt"] as String),
        paymentUrl:
            json["payment_url"] == null ? null : json["payment_url"] as String,
        detail: json["detail"] == null
            ? null
            : Detail.fromJson(json["detail"] as Map<String, dynamic>),
        token: json["token"] == null ? null : json["token"] as String,
        redirectUrl: json["redirect_url"] == null
            ? null
            : json["redirect_url"] as String,
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "bank": bank,
        "va_number": vaNumber,
        "ref_id": refId,
        "provider": provider,
        "total": total,
        "expiredAt": expiredAt!.toIso8601String(),
        "payment_url": paymentUrl,
        "detail": detail!.toJson(),
        "token": token,
        "redirect_url": redirectUrl,
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
    // this.data,
  });

  String? code;
  String? name;
  String? description;
  String? provider;
  String? icon;
  String? type;
  // List<dynamic>? data;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        code: json["code"] == null ? null : json["code"] as String,
        name: json["name"] == null ? null : json["name"] as String,
        description: json["description"] == null ? null : json["description"]  as String,
        provider: json["provider"] == null ? null : json["provider"] as String,
        icon: json["icon"] == null ? null : json["icon"] as String,
        type: json["type"] == null ? null : json["type"]  as String,
        // data: json["data"] == null ? [] : json["data"] as List,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "description": description,
        "provider": provider,
        "icon": icon,
        "type": type,
        // "data": data,
      };
}

class Meta {
  Meta({
    this.page,
    this.perPage,
    this.total,
    this.totalPage,
  });

  int? page;
  int? perPage;
  int? total;
  int? totalPage;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        page: json["page"] as int,
        perPage: json["per_page"] as int,
        total: json["total"] as int,
        totalPage: json["total_page"] as int,
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "per_page": perPage,
        "total": total,
        "total_page": totalPage,
      };
}
