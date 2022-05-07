/// This Model is FROM API [https://staging-services.alteacare.com/data/doctors]
class Doctors {
  Doctors({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<DatumDoctors>? data;

  factory Doctors.fromJson(Map<String, dynamic> json) {
    final List data = json["data"] as List;
    // print('json => $json');
    return Doctors(
      status: json["status"] as bool,
      message: json["message"] as String,
      data: (json["data"] as List).isNotEmpty ? List<DatumDoctors>.from(data.map((x) => DatumDoctors.fromJson(x as Map<String, dynamic>))) : [],
    );
  }

  factory Doctors.fromJsonError(Map<String, dynamic> json) {
    List data = json["data"] as List;

    return Doctors(
      status: json["status"] as bool,
      message: json["message"] as String,
      data: List<DatumDoctors>.from(data.map((x) => DatumDoctors.fromJson(x as Map<String, dynamic>))),
    );
  }

  factory Doctors.fromJsonErrorCatch(String json) {
    return Doctors(
      message: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DatumDoctors {
  DatumDoctors({
    this.doctorId,
    this.name,
    this.slug,
    this.isPopular,
    this.about,
    this.overview,
    this.photo,
    this.sip,
    this.experience,
    this.price,
    this.specialization,
    this.hospital,
    this.aboutPreview,
  });

  String? doctorId;
  String? name;
  String? slug;
  bool? isPopular;
  String? about;
  String? overview;
  Photo? photo;
  String? sip;
  String? experience;
  Price? price;
  Specialization? specialization;
  List<Hospital>? hospital;
  String? aboutPreview;

  factory DatumDoctors.fromJson(Map<String, dynamic> json) {
    // log('json 2 => $json');
    try {
      return DatumDoctors(
        doctorId: json["doctor_id"] as String,
        name: json["name"] as String,
        slug: json["slug"] == null ? null : json["slug"] as String,
        isPopular: json["is_popular"] as bool,
        about: json["about"] == null ? null : json["about"] as String,
        overview: json["overview"] == null ? null : json["overview"] as String,
        photo: json["photo"] == null ? null : Photo.fromJson(json["photo"] as Map<String, dynamic>),
        sip: json["sip"] == null ? null : json["sip"] as String,
        experience: json["experience"] as String,
        price: Price.fromJson(json["price"] as Map<String, dynamic>),
        specialization: Specialization.fromJson(json["specialization"] as Map<String, dynamic>),
        hospital: List<Hospital>.from((json["hospital"] as List).map((x) => Hospital.fromJson(x as Map<String, dynamic>))),
        aboutPreview: json["about_preview"] == null ? null : json["about_preview"] as String,
      );
    } catch (e) {
      // print('error doctors => $e');
    }
    return DatumDoctors(
      doctorId: json["doctor_id"] as String,
      name: json["name"] as String,
      slug: json["slug"] == null ? null : json["slug"] as String,
      isPopular: json["is_popular"] as bool,
      about: json["about"] == null ? null : json["about"] as String,
      overview: json["overview"] == null ? null : json["overview"] as String,
      photo: json["photo"] == null ? null : Photo.fromJson(json["photo"] == null ? {} : json["photo"] as Map<String, dynamic>),
      sip: json["sip"] == null ? null : json["sip"] as String,
      experience: json["experience"] as String,
      price: Price.fromJson(json["price"] == null ? {} : json["price"] as Map<String, dynamic>),
      specialization: Specialization.fromJson(json["specialization"] == null ? {} : json["specialization"] as Map<String, dynamic>),
      hospital: List<Hospital>.from((json["hospital"] as List).map((x) => Hospital.fromJson(x == null ? {} : x as Map<String, dynamic>))),
      aboutPreview: json["about_preview"] == null ? null : json["about_preview"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "doctor_id": doctorId,
        "name": name,
        "slug": slug,
        "is_popular": isPopular,
        "about": about == null ? null : about,
        "overview": overview == null ? null : overview,
        "photo": photo == null ? null : photo!.toJson(),
        "sip": sip == null ? null : sip,
        "experience": experience,
        "price": price!.toJson(),
        "specialization": specialization!.toJson(),
        "hospital": List<dynamic>.from(hospital!.map((x) => x.toJson())),
        "about_preview": aboutPreview == null ? null : aboutPreview,
      };
}

class Hospital {
  Hospital({
    this.id,
    this.name,
    this.image,
    this.icon,
  });

  String? id;
  String? name;
  Photo? image;
  Photo? icon;

  factory Hospital.fromJson(Map<String, dynamic> json) {
    // print('hospital => $json');
    return Hospital(
      id: json["id"] as String,
      name: json["name"] as String,
      image: json["image"] == null ? null : Photo.fromJson(json["image"] as Map<String, dynamic>),
      icon: json["icon"] == null ? null : Photo.fromJson(json["icon"] as Map<String, dynamic>),
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image == null ? null : image!.toJson(),
        "icon": icon?.toJson(),
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

  factory Photo.fromJson(Map<String, dynamic> json) {
    // print('photos => $json');
    return Photo(
      sizeFormatted: json["size_formatted"] as String,
      url: json["url"] as String,
      formats: Formats.fromJson(json["formats"] as Map<String, dynamic>),
    );
  }

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

class Price {
  Price({
    this.raw,
    this.formatted,
  });

  double? raw;
  String? formatted;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        raw: (json["raw"] as int).toDouble(),
        formatted: json["formatted"] as String,
      );

  Map<String, dynamic> toJson() => {
        "raw": raw,
        "formatted": formatted,
      };
}

class Specialization {
  Specialization({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Specialization.fromJson(Map<String, dynamic> json) => Specialization(
        id: json["id"] as String,
        name: json["name"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
