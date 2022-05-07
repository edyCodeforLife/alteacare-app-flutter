class BannersAndPromo {
  BannersAndPromo({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<DatumBannerPromo>? data;

  factory BannersAndPromo.fromJson(Map<String, dynamic> json) =>
      BannersAndPromo(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: List<DatumBannerPromo>.from((json["data"] as List)
            .map((x) => DatumBannerPromo.fromJson(x as Map<String, dynamic>))),
      );

  factory BannersAndPromo.fromJsonError(Map<String, dynamic> json) {
    final List data = json["data"] as List;

    return BannersAndPromo(
      status: json["status"] as bool,
      message: json["message"] as String,
      data: List<DatumBannerPromo>.from(data
          .map((x) => DatumBannerPromo.fromJson(x as Map<String, dynamic>))),
    );
  }

  factory BannersAndPromo.fromJsonErrorCatch(String json) {
    return BannersAndPromo(
      message: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DatumBannerPromo {
  DatumBannerPromo({
    this.bannerId,
    this.title,
    this.type,
    this.description,
    this.needLogin,
    this.deeplinkTypeAndroid,
    this.deeplinkUrlAndroid,
    this.deeplinkTypeIos,
    this.deeplinkUrlIos,
    this.urlWeb,
    this.imageMobile,
    this.imageDesktop,
  });

  String? bannerId;
  String? title;
  String? type;
  String? description;
  bool? needLogin;
  String? deeplinkTypeAndroid;
  String? deeplinkUrlAndroid;
  String? deeplinkTypeIos;
  String? deeplinkUrlIos;
  String? urlWeb;
  String? imageMobile;
  String? imageDesktop;

  factory DatumBannerPromo.fromJson(Map<String, dynamic> json) =>
      DatumBannerPromo(
        bannerId: json["banner_id"] as String,
        title: json["title"] as String,
        type: json["type"] == null ? null : json['type'] as String,
        description: json["description"] as String,
        needLogin: json["need_login"] as bool,
        deeplinkTypeAndroid: json["deeplink_type_android"] == null
            ? null
            : json["deeplink_type_android"] as String,
        deeplinkUrlAndroid: json["deeplink_url_android"] == null
            ? null
            : json["deeplink_url_android"] as String,
        deeplinkTypeIos: json["deeplink_type_ios"] == null
            ? null
            : json["deeplink_type_ios"] as String,
        deeplinkUrlIos: json["deeplink_url_ios"] == null
            ? null
            : json["deeplink_url_ios"] as String,
        urlWeb: json["url_web"] == null ? null : json["url_web"] as String,
        imageMobile: json["image_mobile"] as String,
        imageDesktop: json["image_desktop"] as String,
      );

  Map<String, dynamic> toJson() => {
        "banner_id": bannerId,
        "title": title,
        "type": type,
        "description": description,
        "need_login": needLogin,
        "deeplink_type_android":
            deeplinkTypeAndroid == null ? null : deeplinkTypeAndroid,
        "deeplink_url_android":
            deeplinkUrlAndroid == null ? null : deeplinkUrlAndroid,
        "deeplink_type_ios": deeplinkTypeIos == null ? null : deeplinkTypeIos,
        "deeplink_url_ios": deeplinkUrlIos == null ? null : deeplinkUrlIos,
        "url_web": urlWeb == null ? null : urlWeb,
        "image_mobile": imageMobile,
        "image_desktop": imageDesktop,
      };
}
