// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/utils/use_shared_pref.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/core/widgets/custom_text_field.dart';
import 'package:altea/app/data/model/doctor_schedules.dart';
import 'package:altea/app/data/model/sign_in_model.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import 'package:altea/app/modules/login/controllers/login_controller.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import 'package:altea/app/routes/app_pages.dart';

class MobileWebViewSpesialisKonsultasiPage extends GetView<SpesialisKonsultasiController> {
  MobileWebViewSpesialisKonsultasiPage({Key? key}) : super(key: key);

  final homeController = Get.find<HomeController>();
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // final Doctor doctorData = Get.arguments as Doctor;

    // print(controller.listDate.length);
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: kBackground,
        appBar: MobileWebMainAppbar(
          scaffoldKey: scaffoldKey,
        ),
        drawer: MobileWebHamburgerMenu(),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    Positioned(
                      top: 0,
                      child: Container(
                        color: kLightGray,
                        width: screenWidth,
                        child: Center(
                          child: Container(
                            // margin: const EdgeInsets.only(top: 41),
                            // padding: const EdgeInsets.only(top: 8),
                            width: screenWidth,
                            height: (screenWidth <= 350) ? 220 : 210,
                            child: FadeInImage.assetNetwork(
                              placeholder: "assets/loadingPlaceholder.gif",
                              image: (controller.doctorInfo.value.photo!.formats!.thumbnail != null)
                                  ? controller.doctorInfo.value.photo!.formats!.thumbnail!
                                  : "http://cdn.onlinewebfonts.com/svg/img_148071.png",
                              width: screenWidth,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 180,
                      child: Container(
                        width: screenWidth,
                        height: MediaQuery.of(context).size.height - ((screenWidth <= 350) ? 220 : 180),
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        decoration: const BoxDecoration(
                          color: kBackground,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(33),
                          ),
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.doctorInfo.value.name ?? "No data",
                                  style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  controller.doctorInfo.value.overview ?? "No data",
                                  style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 18,
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      decoration: BoxDecoration(color: kButtonColor.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                                      child: Text(
                                        controller.doctorInfo.value.experience ?? "No data",
                                        style: kPoppinsMedium500.copyWith(fontSize: 10, color: kButtonColor),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 18,
                                        // width: 200,
                                        child: Row(
                                          children: [
                                            Image.network(
                                              (controller.doctorInfo.value.hospital![0].icon == null ||
                                                      controller.doctorInfo.value.hospital![0].icon!.formats!.thumbnail == null)
                                                  ? "http://cdn.onlinewebfonts.com/svg/img_148071.png"
                                                  : addCDNforLoadImage(controller.doctorInfo.value.hospital![0].icon!.formats!.thumbnail!),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(controller.doctorInfo.value.hospital![0].name ?? "No data",
                                                style: kPoppinsMedium500.copyWith(fontSize: 10, color: kBlackColor),
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Languages: ",
                                      style: kPoppinsRegular400.copyWith(color: kSubHeaderColor, fontSize: 9),
                                    ),
                                    Text(
                                      controller.doctorInfo.value.overview ?? "-",
                                      style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 10),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 35,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Profil Dokter",
                                      style: kPoppinsMedium500.copyWith(
                                        fontSize: 12,
                                        color: grayTitleColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Obx(() {
                                      return buildDoctorProfileDescription(
                                        text: controller.doctorInfo.value.about ?? "No data",
                                        isReadmore: controller.isReadmore.value,
                                      );
                                    }),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Divider(
                                      height: 1,
                                      color: kLightGray,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Obx(() => Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                controller.isReadmore.value = !controller.isReadmore.value;
                                              },
                                              child: Text(
                                                controller.isReadmore.value ? "Read Less" : "Read More",
                                                style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 10),
                                              ),
                                            ),
                                            Icon(
                                              controller.isReadmore.value ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                              size: 18,
                                            )
                                          ],
                                        )),
                                    const SizedBox(
                                      height: 48,
                                    ),
                                    Text(
                                      "Consult by",
                                      style: kPoppinsMedium500.copyWith(
                                        fontSize: 12,
                                        color: grayTitleColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      // width: screenWidth * 0.27,
                                      height: 28,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: kButtonColor)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 11,
                                            child: Image.asset("assets/vidcall_icon.png"),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            controller.consultBy.value,
                                            style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 11),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 35,
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Pilih Jadwal yang tersedia",
                                                style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 12),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                "Menampilkan jadwal 7 hari kedepan",
                                                style: kPoppinsRegular400.copyWith(color: hinTextColor, fontSize: 10),
                                              ),
                                            ],
                                          ),
                                          // InkWell(
                                          //   onTap: () {
                                          //     // print("pilih tanggal");
                                          //   },
                                          //   child: Row(
                                          //     children: [
                                          //       Text(
                                          //         "Pilih Tanggal",
                                          //         style: kPoppinsMedium500.copyWith(
                                          //             color: kButtonColor,
                                          //             fontSize: 10),
                                          //       ),
                                          //       const SizedBox(
                                          //         width: 7,
                                          //       ),
                                          //       SizedBox(
                                          //           width: 19,
                                          //           height: 18,
                                          //           child: Image.asset(
                                          //               "assets/calendar_icon.png")),
                                          //     ],
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    ),
                                    // ? JADWAL Dokter
                                    JadwalDokter(controller: controller, doctorId: controller.doctorInfo.value.doctorId!),
                                    // ?TnC
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Terms & Conditions:",
                                          style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 12),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. \n Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of 'de Finibus Bonorum et Malorum' (The Extremes of Good and Evil).",
                                          style: kPoppinsMedium500.copyWith(color: hinTextColor, fontSize: 10),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: screenWidth * 0.3,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: screenWidth * 0.2,
                        width: screenWidth,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                        decoration: BoxDecoration(
                          color: kBackground,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(33),
                            topRight: Radius.circular(33),
                          ),
                          boxShadow: [BoxShadow(offset: const Offset(0, -3), color: kLightGray, blurRadius: 12)],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Biaya Konsultasi:",
                                  style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 10),
                                ),
                                Text(
                                  controller.doctorInfo.value.price!.formatted ?? "No data",
                                  style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 15),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 138,
                              height: 38,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(22.5),
                                      ),
                                      primary: kButtonColor,
                                      elevation: 0),
                                  onPressed: controller.selectedTime.value.isEmpty
                                      ? null
                                      : () async {
                                          controller.accessTokens.value = homeController.accessTokens.value;
                                          final result = await controller.checkAddress();

                                          if (result.status == false) {
                                            Get.bottomSheet(
                                              const LoginCheckBottomSheetPage(),
                                              backgroundColor: kBackground,
                                              isScrollControlled: true,
                                              isDismissible: true,
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(33),
                                                  topRight: Radius.circular(33),
                                                ),
                                              ),
                                            );
                                          } else {
                                            final String doctorId =
                                                Get.parameters.containsKey('doctorId') ? Get.parameters['doctorId'].toString() : "";
                                            Get.toNamed("${Routes.PATIENT_TYPE}?doctorId=$doctorId");

                                            // if (result.data!.address!.isEmpty) {
                                            //   Get.toNamed(Routes.PATIENT_ADDRESS);
                                            // } else {
                                            //   Get.toNamed('/patient-type');

                                            //   // Get.toNamed(Routes.PATIENT_DATA);
                                            // }
                                          }
                                        },
                                  child: Text(
                                    "Lanjut",
                                    style: kPoppinsMedium500.copyWith(color: kBackground, fontSize: 12),
                                  )),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ));
  }

  Widget buildDoctorProfileDescription({
    required String text,
    required bool isReadmore,
  }) {
    final maxLines = isReadmore ? 0 : 2;

    if (maxLines == 0) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        height: 100,
        child: HtmlWidget(
          text,
          customStylesBuilder: (_) {
            return {'color': "0xFF606D77", 'font-size': '11px'};
          },
        ),
      );
    } else {
      return Container(
        child: HtmlWidget(
          text,
          customStylesBuilder: (_) {
            return {
              'color': "0xFF606D77",
              'font-size': '11px',
              'text-overflow': 'ellipsis',
              'max-lines': maxLines.toString(),
            };
          },
        ),
      );
    }
  }
}

class LoginCheckBottomSheetPage extends StatelessWidget {
  const LoginCheckBottomSheetPage({
    Key? key,
  }) : super(key: key);

  static final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final loginController = Get.put(LoginController());
    final homeController = Get.find<HomeController>();
    final specialistController = Get.find<SpesialisKonsultasiController>();

    return Column(
      children: [
        const SizedBox(
          height: 11,
        ),
        Container(height: 6, width: 48, color: kLightGray),
        const SizedBox(
          height: 55,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign In',
                        style: kHeaderStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Lakukan proses sign in untuk booking konsultasi',
                        style: kPoppinsRegular400.copyWith(fontSize: 12, color: kLightGray),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Form(
                    key: loginKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomTextField(
                          onChanged: (val) {},
                          hintText: 'Email',
                          keyboardType: TextInputType.text,
                          onSaved: (val) {
                            loginController.email.value = val.toString();
                          },
                          validator: (val) {
                            if (val == '') {
                              return 'Email tidak boleh kosong';
                            } else {
                              return null;
                            }
                          },
                        ),
                        CustomTextField(
                          onChanged: (val) {},
                          hintText: 'Password',
                          keyboardType: TextInputType.visiblePassword,
                          onSaved: (val) {
                            loginController.password.value = val.toString();
                          },
                          validator: (val) {
                            // print('val => $val');
                            if (val == '') {
                              return 'Password tidak boleh kosong';
                            } else {
                              return null;
                            }
                          },
                        ),
                        TextButton(
                          onPressed: () => Get.toNamed('/forgot'),
                          child: Text(
                            'Forgot Password',
                            style: kForgotTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: CustomFlatButton(
                      width: screenWidth * 0.8,
                      text: 'Sign In',
                      onPressed: () async {
                        final res = loginKey.currentState?.validate();
                        if (res == true) {
                          loginKey.currentState!.save();
                        }
                        final SignIn result =
                            await loginController.signInToUserAccount(email: loginController.email.value, password: loginController.password.value);
                        if (result.status == true) {
                          await AppSharedPreferences.setAccessToken(result.data!.accessToken!);

                          final String accessToken = AppSharedPreferences.getAccessToken();
                          if (accessToken.isNotEmpty) {
                            homeController.accessTokens.value = accessToken;
                            specialistController.accessTokens.value = accessToken;
                            // print("access token -> ${homeController.accessTokens}");
                            Get.back();
                          }
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => CustomSimpleDialog(
                                  icon: SizedBox(
                                    width: screenWidth * 0.1,
                                    child: Image.asset("assets/failed_icon.png"),
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  title: 'Login Gagal',
                                  buttonTxt: 'Mengerti',
                                  subtitle: result.message!));
                        }
                      },
                      color: kButtonColor),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          // width: double.infinity,
                          height: 1,
                          color: Colors.black38,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: 'Belum punya akun? ', style: kDontHaveAccStyle),
                              TextSpan(
                                text: 'Sign Up',
                                style: kDontHaveAccStyle.copyWith(color: kDarkBlue, fontWeight: FontWeight.w600),
                                recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed('/register'),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        // width: double.infinity,
                        height: 1,
                        color: Colors.black38,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class JadwalDokter extends StatelessWidget {
  final List<String> singkatanBulan = [
    "",
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "Mei",
    "Jun",
    "Jul",
    "Ags",
    "Sep",
    "Okt",
    "Nov",
    "Des",
  ];
  JadwalDokter({
    Key? key,
    required this.controller,
    required this.doctorId,
  }) : super(key: key);

  final SpesialisKonsultasiController controller;
  final String doctorId;

  @override
  Widget build(BuildContext context) {
    controller.selectDate.value = DateFormat("yyyy-MM-dd").format(controller.listDate[controller.tabController.index]);
    return DefaultTabController(
      length: controller.listDate.length,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: kLightGray,
            ))),
            child: TabBar(
              isScrollable: true,
              onTap: (index) {
                controller.selectedTime.value = '';
                controller.selectDate.value = DateFormat("yyyy-MM-dd").format(controller.listDate[controller.tabController.index]);
              },
              controller: controller.tabController,
              labelColor: kDarkBlue,
              labelPadding: EdgeInsets.zero,
              unselectedLabelColor: kLightGray,
              indicatorColor: kDarkBlue,
              labelStyle: kPoppinsMedium500.copyWith(fontSize: 10),
              tabs: List.generate(
                controller.listDate.length,
                (index) {
                  return Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          Text(controller.listDate[index].day == DateTime.now().day
                              ? 'Hari ini'
                              : DateFormat('EEEE', 'id').format(controller.listDate[index])),
                          Text(
                            " ${controller.listDate[index].day}" + " ${singkatanBulan[controller.listDate[index].month]}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Obx(
            () => FutureBuilder(
              future: controller.getDoctorSchedule(doctorId: doctorId, date: controller.selectDate.value),
              builder: (_, snapshot) {
                if (snapshot.connectionState.index == 3) {
                  final DoctorSchedules result = snapshot.data! as DoctorSchedules;
                  return Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 20),
                    height: (result.status == false || result.data!.isEmpty) ? 150 : ((result.data!.length ~/ ((Get.width - 40) ~/ 110)) + 1) * 40,
                    child: TabBarView(
                      controller: controller.tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                        controller.listDate.length,
                        (_) => (result.status == false || result.data!.isEmpty)
                            ? Container(
                                height: 100,
                                width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      child: Image.asset(
                                        "assets/no_doctor_icon.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "No Doctor Schedule Available",
                                      style: kPoppinsRegular400.copyWith(color: kBlackColor, fontSize: 10),
                                    )
                                  ],
                                ),
                              )
                            : Wrap(
                                children: List.generate(
                                  result.data!.length,
                                  (index) => Obx(
                                    () => Container(
                                      width: 100,
                                      height: 30,
                                      margin: const EdgeInsets.only(right: 8, bottom: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: controller.selectedTime.value == "${result.data![index].startTime} - ${result.data![index].endTime}"
                                              ? kButtonColor
                                              : kLightGray,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(16),
                                        onTap: () {
                                          controller.selectedDoctorTime.value = result.data![index];
                                          controller.selectedTime.value = "${result.data![index].startTime} - ${result.data![index].endTime}";
                                        },
                                        child: Center(
                                          child: Text(
                                            "${result.data![index].startTime} - ${result.data![index].endTime}",
                                            style: kPoppinsRegular400.copyWith(
                                              color:
                                                  controller.selectedTime.value == "${result.data![index].startTime} - ${result.data![index].endTime}"
                                                      ? kButtonColor
                                                      : kBlackColor,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 100,
                    width: 100,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
