class SearchDoctor {
  SearchDoctor({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  SearchDoctorData? data;

  factory SearchDoctor.fromJson(Map<String, dynamic> json) => SearchDoctor(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: SearchDoctorData.fromJson(json["data"] as Map<String, dynamic>),
      );

  factory SearchDoctor.fromJsonError(Map<String, dynamic> json) {
    List data = json["data"] as List;

    return SearchDoctor(
      status: json["status"] as bool,
      message: json["message"] as String,
      data: SearchDoctorData.fromJson(json["data"] as Map<String, dynamic>),
    );
  }

  factory SearchDoctor.fromJsonErrorCatch(String json) {
    return SearchDoctor(
      message: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class SearchDoctorData {
  SearchDoctorData({
    this.doctor,
    // this.symtom,
    // this.specialization,
  });

  List<Doctor>? doctor;
  // List<Symtom>? symtom;
  // List<Specialization>? specialization;

  factory SearchDoctorData.fromJson(Map<String, dynamic> json) =>
      SearchDoctorData(
        doctor: List<Doctor>.from((json["doctor"] as List)
            .map((x) => Doctor.fromJson(x as Map<String, dynamic>))),
        // symtom: List<Symtom>.from((json["symtom"] as List)
        //     .map((x) => Symtom.fromJson(x as Map<String, dynamic>))),
        // specialization: List<Specialization>.from((json["specialization"]
        //         as List)
        //     .map((x) => Specialization.fromJson(x as Map<String, dynamic>))),
      );

  Map<String, dynamic> toJson() => {
        // "doctor": List<dynamic>.from(doctor!.map((x) => x.toJson())),
        // "symtom": List<dynamic>.from(symtom!.map((x) => x.toJson())),
        // "specialization":
        // List<dynamic>.from(specialization!.map((x) => x.toJson())),
      };
}

class Doctor {
  Doctor({
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
  IconPhotoDoctor? photo;
  String? sip;
  String? experience;
  PriceSearchDoctor? price;
  DoctorSpecialization? specialization;
  List<HospitalSearchDoctor>? hospital;
  String? aboutPreview;

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        doctorId: json["doctor_id"] as String,
        name: json["name"] as String,
        slug: json["slug"] == null ? null : json['slug'] as String,
        isPopular: json["is_popular"] as bool,
        about: json["about"] == null ? null : json["about"] as String,
        overview: json["overview"] == null ? null : json["overview"] as String,
        photo: json["photo"] == null
            ? null
            : IconPhotoDoctor.fromJson(json["photo"] as Map<String, dynamic>),
        sip: json["sip"] == null ? null : json["sip"] as String,
        experience: json["experience"] as String,
        price:
            PriceSearchDoctor.fromJson(json["price"] as Map<String, dynamic>),
        specialization: DoctorSpecialization.fromJson(
            json["specialization"] as Map<String, dynamic>),
        hospital: List<HospitalSearchDoctor>.from((json["hospital"] as List)
            .map((x) =>
                HospitalSearchDoctor.fromJson(x as Map<String, dynamic>))),
        aboutPreview: json["about_preview"] == null
            ? null
            : json["about_preview"] as String,
      );

  // Map<String, dynamic> toJson() => {
  //       "doctor_id": doctorId,
  //       "name": name,
  //       "slug": slug,
  //       "is_popular": isPopular,
  //       "about": about == null ? null : about,
  //       "overview": overview == null ? null : overview,
  //       "photo": photo == null ? null : photo!.toJson(),
  //       "sip": sip,
  //       "experience": experience,
  //       "price": price!.toJson(),
  //       "specialization": specialization!.toJson(),
  //       "hospital": List<dynamic>.from(hospital!.map((x) => x.toJson())),
  //       "about_preview": aboutPreview == null ? null : aboutPreview,
  //     };
}

class HospitalSearchDoctor {
  HospitalSearchDoctor({
    this.id,
    this.name,
    this.image,
    this.icon,
  });

  String? id;
  String? name;
  IconPhotoDoctor? image;
  IconPhotoDoctor? icon;

  factory HospitalSearchDoctor.fromJson(Map<String, dynamic> json) =>
      HospitalSearchDoctor(
        id: json["id"] as String,
        name: json["name"] as String,
        image: json["image"] == null
            ? null
            : IconPhotoDoctor.fromJson(json["image"] as Map<String, dynamic>),
        icon: json["icon"] == null
            ? null
            : IconPhotoDoctor.fromJson(json["icon"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image == null ? null : image!.toJson(),
        "icon": icon!.toJson(),
      };
}

class IconPhotoDoctor {
  IconPhotoDoctor({
    this.sizeFormatted,
    this.url,
    this.formats,
  });

  String? sizeFormatted;
  String? url;
  Formats? formats;

  factory IconPhotoDoctor.fromJson(Map<String, dynamic> json) =>
      IconPhotoDoctor(
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

class PriceSearchDoctor {
  PriceSearchDoctor({
    this.raw,
    this.formatted,
  });

  int? raw;
  String? formatted;

  factory PriceSearchDoctor.fromJson(Map<String, dynamic> json) =>
      PriceSearchDoctor(
        raw: json["raw"] as int,
        formatted: json["formatted"] as String,
      );

  Map<String, dynamic> toJson() => {
        "raw": raw,
        "formatted": formatted,
      };
}

class DoctorSpecialization {
  DoctorSpecialization({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory DoctorSpecialization.fromJson(Map<String, dynamic> json) =>
      DoctorSpecialization(
        id: json["id"] as String,
        name: json["name"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

// class Specialization {
//   Specialization({
//     this.specializationId,
//     this.name,
//     this.slug,
//     this.description,
//     this.isPopular,
//     this.icon,
//     this.subSpecialization,
//   });

//   String? specializationId;
//   String? name;
//   String? slug;
//   String? description;
//   bool? isPopular;
//   IconPhotoDoctor? icon;
//   List<Specialization>? subSpecialization;

//   factory Specialization.fromJson(Map<String, dynamic> json) => Specialization(
//         specializationId: json["specialization_id"] as String,
//         name: json["name"] as String,
//         slug: json["slug"] == null ? null : json["slug"] as String,
//         description:
//             json["description"] == null ? null : json["description"] as String,
//         isPopular: json["is_popular"] as bool,
//         icon: IconPhotoDoctor.fromJson(json["icon"] as Map<String, dynamic>),
//         subSpecialization: json["sub_specialization"] == null
//             ? null
//             : List<Specialization>.from((json["sub_specialization"] as List)
//                 .map(
//                     (x) => Specialization.fromJson(x as Map<String, dynamic>))),
//       );

//   Map<String, dynamic> toJson() => {
//         "specialization_id": specializationId,
//         "name": name,
//         "slug": slug == null ? null : slug,
//         "description": description == null ? null : description,
//         "is_popular": isPopular,
//         "icon": icon!.toJson(),
//         "sub_specialization": subSpecialization == null
//             ? null
//             : List<dynamic>.from(subSpecialization!.map((x) => x.toJson())),
//       };
// }

// class Symtom {
//   Symtom({
//     this.symtomId,
//     this.name,
//   });

//   String? symtomId;
//   String? name;

//   factory Symtom.fromJson(Map<String, dynamic> json) => Symtom(
//         symtomId: json["symtom_id"] as String,
//         name: json["name"] as String,
//       );

//   Map<String, dynamic> toJson() => {
//         "symtom_id": symtomId,
//         "name": name,
//       };
// }
