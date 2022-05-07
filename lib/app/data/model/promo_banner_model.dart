class PromoBanner {
  final bool? status;
  final String message;
  final List<PromoData>? data;

  PromoBanner({
    this.status,
    required this.message,
    this.data,
  });

  factory PromoBanner.fromJson(Map<String, dynamic> json) {
    List data = json['data'] as List;
    // print('promo banner promo data list => ${json['data']}');
    List<PromoData> promo = [];
    for (int i = 0; i < data.length + 1; i += 1) {
      // print('data per satu => ${data[i]}');
      promo.add(PromoData.fromJson(data[i] as Map<String, dynamic>));
      // print('promo => $promo');
    }
    // print('dataaa promooo => $promo');
    return PromoBanner(status: json['status'] as bool, message: json['message'] as String, data: promo);
  }

  factory PromoBanner.fromJsonErrorCatch(Map<String, dynamic> json) => PromoBanner(
        message: json['message'] as String,
      );
}

class PromoData {
  final String bannerId;
  final String title;
  final String desc;
  final bool needLogin;
  final String androidDeepLinkType;
  final String androidDeepLinkURL;
  final String iosDeepLinkType;
  final String iosDeepLinkURL;
  final String urlWeb;
  final String mobileImg;
  final String webImg;

  PromoData(
      {required this.bannerId,
      required this.title,
      required this.desc,
      required this.needLogin,
      required this.androidDeepLinkType,
      required this.androidDeepLinkURL,
      required this.iosDeepLinkType,
      required this.iosDeepLinkURL,
      required this.urlWeb,
      required this.mobileImg,
      required this.webImg});

  factory PromoData.fromJson(Map<String, dynamic> json) {
    // print('masuk promo dataaaaaaaa');
    // print('data 2 => $json');
    return PromoData(
        bannerId: json['banner_id'] as String,
        title: json['title'] as String,
        desc: json['description'] as String,
        needLogin: json['need_login'] as bool,
        androidDeepLinkType: json['deeplink_type_android'] as String,
        androidDeepLinkURL: json['deeplink_url_android'] as String,
        iosDeepLinkType: json['deeplink_type_ios'] as String,
        iosDeepLinkURL: json['deeplink_url_ios'] as String,
        urlWeb: json["url_web"] as String,
        mobileImg: json['image_mobile'] as String,
        webImg: json['image_desktop'] as String);
  }

  Map<String, dynamic> toJson() => {
        "banner_id": bannerId,
        "title": title,
        "description": desc,
        "need_login": needLogin,
        "deeplink_type_android": androidDeepLinkType,
        "deeplink_url_android": androidDeepLinkURL,
        "deeplink_type_ios": iosDeepLinkType,
        "deeplink_url_ios": iosDeepLinkURL,
        "url_web": urlWeb,
        "image_mobile": mobileImg,
        "image_desktop": webImg,
      };
}
