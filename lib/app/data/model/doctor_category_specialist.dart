/// This Model is FROM API [https://staging-services.alteacare.com/data/specializations]
class DoctorSpecialistCategory {
  DoctorSpecialistCategory({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<Datum>? data;

  factory DoctorSpecialistCategory.fromJson(Map<String, dynamic> json) {
    List data = json["data"] as List;

    return DoctorSpecialistCategory(
      status: json["status"] as bool,
      message: json["message"] as String,
      data: List<Datum>.from(data.map((x) => Datum.fromJson(x as Map<String, dynamic>))),
    );
  }

  factory DoctorSpecialistCategory.fromJsonError(Map<String, dynamic> json) {
    List data = json["data"] as List;

    return DoctorSpecialistCategory(
      status: json["status"] as bool,
      message: json["message"] as String,
      data: List<Datum>.from(data.map((x) => Datum.fromJson(x as Map<String, dynamic>))),
    );
  }

  factory DoctorSpecialistCategory.fromJsonErrorCatch(String json) {
    return DoctorSpecialistCategory(
      message: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.specializationId,
    this.name,
    this.slug,
    this.description,
    this.isPopular,
    this.icon,
    this.subSpecialization,
  });

  String? specializationId;
  String? name;
  dynamic slug;
  String? description;
  bool? isPopular;
  Iconss? icon;
  List<Datum>? subSpecialization;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        specializationId: json["specialization_id"] as String,
        name: json["name"] as String,
        slug: json["slug"],
        description: json["description"] == null ? null : json["description"] as String,
        isPopular: json["is_popular"] as bool,
        icon: Iconss.fromJson(json["icon"] as Map<String, dynamic>),
        subSpecialization: json["sub_specialization"] == null
            ? null
            : List<Datum>.from((json["sub_specialization"] as List).map((x) => Datum.fromJson(x as Map<String, dynamic>))),
      );

  Map<String, dynamic> toJson() => {
        "specialization_id": specializationId,
        "name": name,
        "slug": slug,
        "description": description == null ? null : description,
        "is_popular": isPopular,
        "icon": icon!.toJson(),
        "sub_specialization": subSpecialization == null ? null : List<dynamic>.from(subSpecialization!.map((x) => x.toJson())),
      };
}

class Iconss {
  Iconss({
    this.sizeFormatted,
    this.url,
    this.formats,
  });

  String? sizeFormatted;
  String? url;
  Formats? formats;

  factory Iconss.fromJson(Map<String, dynamic> json) => Iconss(
        sizeFormatted: json["size_formatted"] as String,
        url: json["url"] as String,
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
