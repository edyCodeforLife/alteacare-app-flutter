// Dart imports:
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:faker_dart/faker_dart.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timer_count_down/timer_controller.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/use_shared_pref.dart';
import 'package:altea/app/data/model/my_profile.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/my_profile/views/desktop_web_view/desktop_web_view.dart';
import 'package:altea/app/modules/my_profile/views/mobile_web_view/mobile_web_view.dart';

class MyProfileController extends GetxController {
  final http.Client client = http.Client();
  final homeController = Get.find<HomeController>();

  // use for fake data
  final faker = Faker.instance;

  final List<String> myProfileMenuList = ["Profil", "Pengaturan", "FAQ", "Kontak AlteaCare", "Syarat & Ketentuan", "Privacy Policy", "Keluar"];

  final List<String> alamatPengirimanDummy = [];

  final RxString selectedShippingAddress = "".obs;

  RxString selectedMyProfileMenu = 'Profil'.obs;

  /// this function is to get my profile data
  Future<MyProfile> getProfile() async {
    final token = AppSharedPreferences.getAccessToken();

    try {
      final response =
          await client.get(Uri.parse("$alteaURL/user/profile/me"), headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});
      // log("getProfile my_profile_controller : ${response.statusCode} :: ${response.body}");

      if (response.statusCode == 200) {
        // below code is for update photo in top nav bar in desktop web
        final MyProfile data = MyProfile.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

        if (data.data!.userDetails!.avatar != null) {
          homeController.avatarUrl.value = data.data!.userDetails!.avatar["formats"]["thumbnail"].toString();
        }

        return MyProfile.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return MyProfile.fromJsonError(jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      return MyProfile.fromJsonErrorCatch(e.toString());
    }
  }

  /// this function is to get my TNC Altea data
  Future<Map<String, dynamic>> getTnCData() async {
    try {
      final response = await client.get(Uri.parse("$alteaURL/data/blocks?type=TERMS_CONDITION"), headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      return e as Map<String, dynamic>;
    }
  }

  /// this function is to get my PrivacyPolicy Altea data
  Future<Map<String, dynamic>> getPrivacyPolicyData() async {
    try {
      final response = await client.get(Uri.parse("$alteaURL/data/blocks?type=PRIVACY_POLICY"), headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      return e as Map<String, dynamic>;
    }
  }

  /// this function is to get my profile data
  Future<Map<String, dynamic>> userLogout() async {
    final token = await AppSharedPreferences.getAccessToken();
    // print('token => $token');

    try {
      final response =
          await client.post(Uri.parse("$alteaURL/user/auth/logout"), headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        homeController.accessTokens.value = "";
        homeController.dismissWebVerificationBanner();

        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      return e as Map<String, dynamic>;
    }
  }

  Widget showWidget(String selectedMyProfileMenu, DataMyProfile data) {
    switch (selectedMyProfileMenu) {
      case 'Pengaturan':
        return const MyProfileSettingMenuContentSection();
      case 'FAQ':
        return const Center(
          child: MyProfileFAQSection(),
        );
      case 'Kontak AlteaCare':
        return const AlteaContactCareSection();
      case 'Syarat & Ketentuan':
        return const MyProfileTnCContentSection();
      case 'Privacy Policy':
        return const MyProfilePrivacyPolicyContentSection();
      default:
        return MyProfileMenuContentSection(
          data: data,
        );
    }
  }

  void goToProfileSectionMobileWeb({required String selectedMyProfileMenu, required DataMyProfile data}) {
    switch (selectedMyProfileMenu) {
      case 'Pengaturan':
        Get.to(() => const MyProfileWebSettingMenuSection());
        break;
      case 'FAQ':
        Get.to(() => const MyProfileMobileWebFAQSection());
        break;
      case 'Kontak AlteaCare':
        Get.to(() => const MyProfleMobileWebAlteaContactCareSection());
        break;
      case 'Syarat & Ketentuan':
        Get.to(() => const MyProfileMobileWebTnCContentSection());
        break;
      case 'Privacy Policy':
        Get.to(() => const MyProfileMobileWebPrivacyPolicySectionContent());
        break;
      default:
        Get.to(MyProfileWebSection(
          data: data,
        ));
        break;
    }
  }

  final pageControllerProfile = PageController();
  RxInt currentpage = 0.obs;
  RxString noHp = "".obs;
  RxString email = "".obs;
  RxString otp = "".obs;
  RxBool isOtpCorrect = false.obs;

  CountdownController countdownCtrl = CountdownController();

  RxString selectedLanguange = "Bahasa".obs;
  RxInt selectLanguange = (-1).obs;
  RxString oldPassword = "".obs;
  RxString password = "".obs;
  RxString confirmPassword = "".obs;
  RxBool isLoading = false.obs;
  RxString messageType = "".obs;
  RxString messageAltea = "".obs;
  RxList<Map<String, dynamic>> listMessageType = <Map<String, dynamic>>[].obs;
  TextEditingController messageAlteaController = TextEditingController();
  RxString avatarId = "".obs; // this for store the id after upload the photo image

  /// this function is to get my Request Change Phone Number Altea
  Future<Map<String, dynamic>> requestChangePhoneNumber(String newPhoneNumber) async {
    final token = AppSharedPreferences.getAccessToken();

    try {
      final response = await client.post(Uri.parse("$alteaURL/user/phone/change/otp"),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
          body: jsonEncode({
            "phone": newPhoneNumber,
          }));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      return e as Map<String, dynamic>;
    }
  }

  /// this function is to get my Request Change Email Altea
  Future<Map<String, dynamic>> requestChangeEmail(String newEmail) async {
    final token = AppSharedPreferences.getAccessToken();

    try {
      final response = await client.post(Uri.parse("$alteaURL/user/email/change/otp"),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
          body: jsonEncode({
            "email": newEmail,
          }));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      return e as Map<String, dynamic>;
    }
  }

  /// this function is to get my Request Change Password Altea
  Future<Map<String, dynamic>> requestChangeUserPassword({required String password, required String passwordConfirmation}) async {
    final token = AppSharedPreferences.getAccessToken();

    try {
      final response = await client.post(Uri.parse("$alteaURL/user/password/change"),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
          body: jsonEncode({"password": password, "password_confirmation": passwordConfirmation}));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      return e as Map<String, dynamic>;
    }
  }

  /// this function is to get my Request Check old Password Altea
  Future<Map<String, dynamic>> checkOldPassword({required String oldPassword}) async {
    final token = AppSharedPreferences.getAccessToken();

    try {
      final response = await client.post(Uri.parse("$alteaURL/user/password/check"),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
          body: jsonEncode({
            "password": oldPassword,
          }));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      return e as Map<String, dynamic>;
    }
  }

  /// this function is to get my FAQ Info Altea
  Future<Map<String, dynamic>> getFAQWEb() async {
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/faqs"),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  /// this function is to get message altea care type
  Future<Map<String, dynamic>> getMessageAlteaCareType() async {
    try {
      final response = await client.get(
        Uri.parse("$alteaURL/data/message-types"),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  /// this function is to get my Request Check old Password Altea
  Future<Map<String, dynamic>> contactAlteaCare(
      {required String messageType,
      required String message,
      required String userName,
      required String emailuser,
      required String userId,
      required String userPhoneNum}) async {
    try {
      final response = await client.post(Uri.parse("$alteaURL/data/messages"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(
              {"message_type": messageType, "message": message, "name": userName, "phone": userPhoneNum, "email": emailuser, "user_id": userId}));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      return e as Map<String, dynamic>;
    }
  }

  /// this function is to post new number with OTP to change phone number Altea
  Future<Map<String, dynamic>> changePhoneNumber({required String newPhoneNum, required String otpNum}) async {
    isLoading.value = true;
    final token = AppSharedPreferences.getAccessToken();

    try {
      final response = await client.post(Uri.parse("$alteaURL/user/phone/change"),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
          body: jsonEncode({
            "phone": newPhoneNum,
            "otp": otpNum,
          }));

      if (response.statusCode == 200) {
        isLoading.value = false;

        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        isLoading.value = false;

        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      isLoading.value = false;

      return {"status": false, "message": e.toString()};
    }
  }

  /// this function is to post new number with OTP to change email Altea
  Future<Map<String, dynamic>> changeEmail({required String newEmail, required String otpNum}) async {
    isLoading.value = true;
    final token = AppSharedPreferences.getAccessToken();

    try {
      final response = await client.post(Uri.parse("$alteaURL/user/email/change"),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
          body: jsonEncode({
            "email": newEmail,
            "otp": otpNum,
          }));

      if (response.statusCode == 200) {
        isLoading.value = false;

        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        isLoading.value = false;

        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      isLoading.value = false;

      return {"status": false, "message": e.toString()};
    }
  }

  Future pickImage(ImageSource src) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: src);
    if (image != null) {
      final File imageFile = File(image.path);
      // print('imageFile => $imageFile');

      Uint8List uintImage = imageFile.readAsBytesSync();
      final resultResponse = await changeProfile(imageBytes: uintImage);
      // print("resultResponse -> $resultResponse");

      avatarId.value = resultResponse["data"]["id"].toString();
      // print("avatar id -> ${avatarId.value}");

      final resultUpdatePhotoProfile = await updateAvatar(avatarId: avatarId.value);

      if (resultUpdatePhotoProfile["status"] == true) {
        Fluttertoast.showToast(
          msg: "Photo profile berhasil diganti",
          backgroundColor: kGreenColor.withOpacity(0.2),
          textColor: kGreenColor,
          webShowClose: true,
          timeInSecForIosWeb: 8,
          fontSize: 13,
          gravity: ToastGravity.TOP,
          webPosition: 'center',
          toastLength: Toast.LENGTH_LONG,
          webBgColor: '#F8FCF5',
        );
      } else {
        Fluttertoast.showToast(
          msg: "Photo profile tidak berhasil diganti",
          backgroundColor: kRedError.withOpacity(0.2),
          textColor: kRedError,
          webShowClose: true,
          timeInSecForIosWeb: 8,
          fontSize: 13,
          gravity: ToastGravity.TOP,
          webPosition: 'center',
          toastLength: Toast.LENGTH_LONG,
          webBgColor: '#F8FCF5',
        );
      }
    }
  }

  Future pickPhotoFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    PlatformFile? objFile;

    if (result != null) {
      // print('result => ${result.files.first.path}');
      final Uint8List fileBytes = result.files.first.bytes!;
      objFile = result.files.single;

      final resultResponse = await changeProfile(imageBytes: fileBytes, objFile: objFile);
      // print("resultResponse -> $resultResponse");

      avatarId.value = resultResponse["data"]["id"].toString();
      // print("avatar id -> ${avatarId.value}");

      final resultUpdatePhotoProfile = await updateAvatar(avatarId: avatarId.value);

      if (resultUpdatePhotoProfile["status"] == true) {
        Fluttertoast.showToast(
          msg: "Photo profile berhasil diganti",
          backgroundColor: kGreenColor.withOpacity(0.2),
          textColor: kGreenColor,
          webShowClose: true,
          timeInSecForIosWeb: 8,
          fontSize: 13,
          gravity: ToastGravity.TOP,
          webPosition: 'center',
          toastLength: Toast.LENGTH_LONG,
          webBgColor: '#F8FCF5',
        );
      } else {
        Fluttertoast.showToast(
          msg: "Photo profile tidak berhasil diganti",
          backgroundColor: kRedError.withOpacity(0.2),
          textColor: kRedError,
          webShowClose: true,
          timeInSecForIosWeb: 8,
          fontSize: 13,
          gravity: ToastGravity.TOP,
          webPosition: 'center',
          toastLength: Toast.LENGTH_LONG,
          webBgColor: '#F8FCF5',
        );
      }
    } else {
      return null;
    }
  }

  /// this function is to upload/change profile photo in profile altea
  Future changeProfile({required Uint8List imageBytes, PlatformFile? objFile}) async {
    isLoading.value = true;
    final token = AppSharedPreferences.getAccessToken();

    try {
      String url = "$alteaURL/data/upload-files";
      final Map<String, String> headers = {'Content-Type': 'multipart/form-data', "Authorization": "Bearer $token"};

      final List<int> dataImage = imageBytes.cast();
      // print("dataimage ->$dataImage");

      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers.addAll(headers);

      request.files.add(http.MultipartFile.fromBytes('files', dataImage,
          filename: objFile != null ? objFile.name : "photo", contentType: MediaType('image', 'jpg,png')));

      final response = await request.send();
      String dataStream;

      if (response.statusCode == 200) {
        isLoading.value = false;
        dataStream = await response.stream.bytesToString();
        // print("upload sukses");

        return jsonDecode(dataStream);
      } else {
        // print("status code -> ${response.statusCode}");
        // print("response -> $response");
        isLoading.value = false;

        return {"status": false, "message": response.statusCode.toString()};
      }
    } catch (e) {
      isLoading.value = false;

      return {"status": false, "message": e.toString()};
    }
  }

  /// this function is to update photo profile altea
  Future<Map<String, dynamic>> updateAvatar({required String avatarId}) async {
    isLoading.value = true;
    final token = AppSharedPreferences.getAccessToken();

    try {
      final response = await client.post(Uri.parse("$alteaURL/user/profile/update-avatar"),
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
          body: jsonEncode({
            "avatar": avatarId,
          }));

      // print('response ganti pic => ${response.body}');

      if (response.statusCode == 200) {
        isLoading.value = false;

        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        isLoading.value = false;

        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      isLoading.value = false;

      return {"status": false, "message": e.toString()};
    }
  }

  @override
  void onInit() {
    super.onInit();
    initializeDateFormatting();

    // ini untuk initiate data dummy buat alamat
    for (var i = 0; i < 5; i++) {
      // faker.address.
      alamatPengirimanDummy.add(faker.fake("{{address.city}}, {{address.county}}, {{address.streetName}}, {{address.state}} "));
    }
    selectedShippingAddress.value = alamatPengirimanDummy[0];
  }

  @override
  void onReady() {
    super.onReady();
    // String page = Get.parameters.containsKey("page") ? Get.parameters['page']! : "";
    // if(page.isNotEmpty){
    //   pageControllerProfile.jumpToPage(int.tryParse(page)??0);
    // }
  }

  @override
  @override
  void onClose() {}
}
