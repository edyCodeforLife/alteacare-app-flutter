// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:another_flushbar/flushbar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/data/model/article.dart';
import 'package:altea/app/data/model/banners_and_promo.dart';
import 'package:altea/app/data/model/my_profile.dart';
import 'package:altea/app/data/model/user.dart';
import 'package:altea/app/modules/notifications/controllers/notifications_controller.dart';
import '../../../core/utils/use_shared_pref.dart';

import '../../../data/model/doctor_category_specialist.dart' as doctorSpecialist;

class HomeController extends GetxController {
  late final GlobalKey<ScaffoldState> scaffoldKey;

  late final GlobalKey<FormState> loginKey;

  final http.Client client = http.Client();

  //untuk inisiasi bisa ngambil notif di home (web)
  final NotificationsController _notificationsController = Get.put(NotificationsController());

  // final DoctorController doctorController = Get.find<DoctorController>();

  RxString accessTokens = "".obs;
  RxInt currentIdx = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isSelectedTabBeranda = true.obs;
  RxBool isSelectedTabDokter = false.obs;
  RxBool isSelectedTabKonsultasi = false.obs;
  RxBool isEmailVerified = false.obs;
  RxString avatarUrl = "".obs;
  RxBool showNotificationContainer = false.obs;
  RxBool showReminder = false.obs; // delete soon development only

  static final List<Map<String, dynamic>> floatingMenus = [
    {"title": "Cari Spesialis", "assetImage": "assets/cari_spesialis_logo.png", "routes": "/home/search-specialist"},
    {"title": "Download App", "assetImage": "assets/download_app_logo.png"},
    {"title": "Vaksinasi COVID-19", "assetImage": "assets/vaksinasi_covid_logo.png"},
  ];

  static final List<Map<String, dynamic>> spesialisMenus = [
    {"title": "Covid-19", "assetImage": "assets/covid19_logo.png"},
    {"title": "Spesialis Anak", "assetImage": "assets/spesialis_anak_logo.png"},
    {"title": "Penyakit Dalam", "assetImage": "assets/penyakit_dalam_logo.png"},
    {"title": "Spesialis THT", "assetImage": "assets/tht_logo.png"},
    {"title": "Kulit & Kelamin", "assetImage": "assets/kulit_kelamin_logo.png"},
  ];

  final List<String> notificationTabMenu = ["Semua", "Pembayaran", "Memo Altea", "Dokumen Medis"];

  RxList<DatumArticle> listArticles = <DatumArticle>[].obs;
  Rx<Meta> dataPageArticle = Meta().obs;
  RxList<DatumBannerPromo> allDataBannerPromo = <DatumBannerPromo>[].obs;

  // Data banner
  DatumBannerPromo dataMainBanner = DatumBannerPromo();
  // Data Promo
  RxList<DatumBannerPromo> dataPromosBanner = <DatumBannerPromo>[].obs;
  // Data banner loyalty
  DatumBannerPromo dataAlteaLoyalty = DatumBannerPromo();

  Rx<User> userData = User().obs;
  Rx<DataMyProfile> userProfile = DataMyProfile().obs; // -> mobile web pakai ini untuk get data di hamburger menu

  List floatingMenu() => floatingMenus;
  List spesialisMenu() => spesialisMenus;

  RxList<doctorSpecialist.Datum> doctorCategory = <doctorSpecialist.Datum>[].obs;

  RxString totalDurationCall = "".obs;

  /// Use this function for get the article data for the first time
  Future<Article> getArticles() async {
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/articles?sort=createdAt:DESC"),
      );

      if (response.statusCode == 200) {
        return Article.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return Article.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return Article.fromJsonErrorCatch(e.toString());
    }
  }

  Future<Map<String, dynamic>> getPromoBanner() async {
    try {
      final response = await client.get(
        Uri.parse('$alteaURL/data/banners'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
        // print('status code : 200 = ${response.body}');
        // print(
        //     '=>> ${PromoBanner.fromJson(jsonDecode(response.body) as Map<String, dynamic>)}');
        // return PromoBanner.fromJson(
        //     jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        // print('status code : ${response.statusCode} = ${response.body}');
        throw response;
      }
    } catch (e) {
      return e as Map<String, dynamic>;
    }
  }

  Future<User> getUserProfile() async {
    var token = await AppSharedPreferences.getAccessToken();
    try {
      final response =
          await client.get(Uri.parse('$alteaURL/user/profile/me'), headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});
      // log("getuserprofile : ${response.statusCode} :: ${response.body}");
      if (response.statusCode == 200) {
        _userForWeb.value = User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        userData.value = User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

        return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return User.fromJsonError(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }
    } catch (e, sss) {
      print(sss);
      print("error home controller : " + e.toString());
      return User.fromJsonErrorCatch(e.toString());
    }
  }

  Future<BannersAndPromo> getBannersAndPromo() async {
    try {
      final response = await client.get(Uri.parse("$alteaURL/data/banners"), headers: {
        // "Access-Control-Allow-Origin": "*",
      });

      if (response.statusCode == 200) {
        return BannersAndPromo.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return BannersAndPromo.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return BannersAndPromo.fromJsonErrorCatch(e.toString());
    }
  }

  void checkAndInsertBannerPromoData() {
    dataPromosBanner.clear();
    for (final DatumBannerPromo item in allDataBannerPromo) {
      if (item.type == null) {
      } else if (item.type == "ALTEA") {
        dataAlteaLoyalty = item;
        // print(dataAlteaLoyalty);
      } else if (item.type == "MAIN") {
        dataMainBanner = item;
      } else {
        dataPromosBanner.add(item);
      }
    }
    // print(dataPromosBanner);
  }

  Future<void> launchURL(String url) async => await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  Future getUserCheckEmailVerification(BuildContext context) async {
    final User user = await getUserProfile();
    // print('user profile => $user');
    if (user.data!.isVerifiedEmail! == false) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(
          Icons.error_outline,
          color: kBackground,
        ),
        backgroundColor: kMidnightBlue,
        messageText: Text(
          'Verifikasi Email',
          style: kValidationText.copyWith(color: kBackground),
        ),
        mainButton: Row(
          children: [
            InkWell(
              onTap: () => Get.toNamed('/verify'),
              child: Container(
                decoration: BoxDecoration(color: kMidnightBlue, borderRadius: BorderRadius.circular(8), border: Border.all(color: kBackground)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Verifikasi',
                  style: kValidationText.copyWith(color: kBackground),
                ),
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 15,
              ),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ).show(context);
    }
  }

  Future<doctorSpecialist.DoctorSpecialistCategory> getDoctorsPopularCategory() async {
    isLoading.value = true;
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/specializations/?is_popular=YES"),
      );

      if (response.statusCode == 200) {
        return doctorSpecialist.DoctorSpecialistCategory.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return doctorSpecialist.DoctorSpecialistCategory.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print("masuk catch $e");
      return doctorSpecialist.DoctorSpecialistCategory.fromJsonErrorCatch(e.toString());
    }
  }

  /// this function is to get my profile data
  Future<MyProfile> getProfile() async {
    final token = AppSharedPreferences.getAccessToken();

    try {
      final response =
          await client.get(Uri.parse("$alteaURL/user/profile/me"), headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});
      // log("getProfile : ${response.statusCode} :: ${response.body}");

      // print("login get user = ${response.body}");
      // print(response.statusCode);

      if (response.statusCode == 200) {
        return MyProfile.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        accessTokens.value = "";
        // print(jsonDecode(response.body)['message']);

        return MyProfile.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      // print(e.toString());
      return MyProfile.fromJsonErrorCatch(e.toString());
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading.value = true;

    scaffoldKey = GlobalKey<ScaffoldState>(
      debugLabel: "drawer key denny",
    );
    loginKey = GlobalKey<FormState>(
      debugLabel: "login key denny",
    );
    final String accessToken = AppSharedPreferences.getAccessToken();
    // final Article result = await getArticles();
    final BannersAndPromo resultPromoBanner = await getBannersAndPromo();

    // print("access token -> $accessToken");

    // listArticles.value = result.data!;
    // dataPageArticle.value = result.meta!;

    allDataBannerPromo.value = resultPromoBanner.data ?? [];

    checkAndInsertBannerPromoData();

    userData.value = await getUserProfile();

    if (accessToken.isNotEmpty) {
      accessTokens.value = accessToken;
      final MyProfile profile = await getProfile();
      if (profile.status!) {
        userProfile.value = profile.data!;
      }

      if (profile.data != null) {
        if (profile.data!.userDetails!.avatar != null) {
          avatarUrl.value = profile.data!.userDetails!.avatar["formats"]["thumbnail"].toString();
        }
      }
    }
    final doctorSpecialist.DoctorSpecialistCategory resultDoctor = await getDoctorsPopularCategory();
    doctorCategory.value = resultDoctor.data!;
    // print("Doctor Category -> ${doctorCategory.value}");

    // doctorController.spesialisMenus.value = resultDoctor.data!;

    isLoading.value = false;
  }

  RxList<String> menus = <String>[].obs;

  Future<void> getUserProfileAgain() async {
    // print('hei hoi get user profile again');

    final MyProfile profile = await getProfile();
    if (profile.status!) {
      userProfile.value = profile.data!;
      // print(userProfile.value.firstName);
    } else {
      // print('wew user profile again');
      // print(userProfile.value.firstName);
    }
  }

  bool isUserAlreadyVerified = false;
  Future<void> checkUserToShowSnackbar() async {
    // print("check user snackbar");
    if (accessTokens.value.isNotEmpty && !isUserAlreadyVerified) {
      // print("check user is user verified");

      final User u = await getUserProfile();
      if (u.data?.isVerifiedEmail ?? false) {
      } else {
        // print("belum verif");
        Get.snackbar('User 123', 'Successfully created', animationDuration: Duration(seconds: 20), snackPosition: SnackPosition.TOP);
      }
    }
  }

  bool isEmailUserChecked = false;
  Future getUserCheckEmailVerificationMobileWeb(BuildContext context, PassedFunction passedFunction) async {
    if (accessTokens.value.isNotEmpty && !isEmailUserChecked) {
      isEmailUserChecked = true;
      await getUserProfileForWeb();
      // print('user profile => $user');
      if (userData.value.data?.isVerifiedEmail == false || _userForWeb.value.data?.isVerifiedEmail == false) {
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(
            Icons.error_outline,
            color: kBackground,
          ),
          backgroundColor: kMidnightBlue,
          messageText: Text(
            'Verifikasi Email',
            style: kValidationText.copyWith(color: kBackground),
          ),
          mainButton: Row(
            children: [
              InkWell(
                onTap: () {
                  passedFunction();
                },
                child: Container(
                  decoration: BoxDecoration(color: kMidnightBlue, borderRadius: BorderRadius.circular(8), border: Border.all(color: kBackground)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Verifikasi',
                    style: kValidationText.copyWith(color: kBackground),
                  ),
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 15,
                ),
                onPressed: () {
                  isEmailUserChecked = false;
                  Get.back();
                },
              ),
            ],
          ),
        ).show(context);
      }
    }
  }

  Rx<User> _userForWeb = User().obs;
  User get userForWeb => _userForWeb.value;
  Rx<UserForWebState> _userForWebState = UserForWebState.ok.obs;
  UserForWebState get userForWebState => _userForWebState.value;

  Future<void> getUserProfileForWeb() async {
    _userForWebState.value = UserForWebState.loading;
    var token = accessTokens;
    // print(token.toString());
    if (token.isNotEmpty) {
      // print('chekkkkk get user profile for web');

      try {
        final response =
            await client.get(Uri.parse('$alteaURL/user/profile/me'), headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});
        log("getUserProfileForWeb : ${response.statusCode} :: ${response.body}");

        if (response.statusCode == 200) {
          // print(response.body);
          _userForWeb.value = User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
          // print(_userForWeb.value.data?.isVerifiedEmail);
          if (_userForWeb.value.data!.isVerifiedEmail! == true) {
            // print("check user profle harusnya masuk sini");
            _userForWebState.value = UserForWebState.ok;
            _verificationBannerStatus.value = false;
          } else {
            _userForWebState.value = UserForWebState.notVerified;
            _verificationBannerStatus.value = true;
          }
        } else {
          _userForWebState.value = UserForWebState.error;
          _verificationBannerStatus.value = false;

          // print(response.body);
        }
      } catch (e) {
        // print("error apanih home controller : " + e.toString());
        _userForWebState.value = UserForWebState.error;
      }
      update();
    }
  }

  final RxBool _verificationBannerStatus = false.obs;
  bool get verificationBannerStatus => _verificationBannerStatus.value;
  void dismissWebVerificationBanner() {
    _verificationBannerStatus.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.dispose();
  }
}

typedef PassedFunction();
enum UserForWebState { ok, error, loading, notVerified }
