// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/data/model/my_profile.dart';
import 'package:altea/app/modules/patient-type/views/desktop_web_view/patient_type_desktop_web_view.dart';
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/utils/use_shared_pref.dart';
import '../../../../core/widgets/custom_flat_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../data/model/doctor_schedules.dart';
import '../../../../data/model/sign_in_model.dart';
import '../../../add_patient/views/add_patient_view.dart';
import '../../../add_patient_address/views/add_patient_address_view.dart';
import '../../../add_patient_confirmed/views/add_patient_confirmed_view.dart';
import '../../../home/controllers/home_controller.dart';
import '../../../home/views/dekstop_web/widget/footer_section_view.dart';
import '../../../home/views/dekstop_web/widget/top_navigation_bar_desktop.dart';
import '../../../login/controllers/login_controller.dart';
import '../../../patient_address/views/patient_address_view.dart';
import '../../../patient_confirmation/patient_confirmation_view.dart';
import '../../../patient_data/views/patient_data_view.dart';
import '../../../register/presentation/modules/register/views/custom_simple_dialog.dart';
import '../../controllers/spesialis_konsultasi_controller.dart';

class DesktopViewSpesialisKonsultasiPage extends GetView<SpesialisKonsultasiController> {
  final homeController = Get.find<HomeController>();

  DesktopViewSpesialisKonsultasiPage({Key? key}) : super(key: key);
  final double screenWidth = Get.width;

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(SpesialisKonsultasiController());

    // print("formats -> ${controller.doctorInfo.value.photo!.formats!}");
    // print("formats -> ${controller.doctorInfo.value.hospital![0].icon}");
    // print(
    //     "hospital icons -> ${controller.doctorInfo.value.hospital![0].icon!.formats!.thumbnail}");
    // final screenWidth = context.width;
    return WillPopScope(
      onWillPop: () async {
        controller.tabController.index = 0;
        controller.selectedTime.value = "";
        Get.back();
        return true;
      },
      child: Scaffold(
        backgroundColor: kBackground,
        body: Column(
          children: [
            TopNavigationBarSection(screenWidth: screenWidth),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: screenWidth * 0.04,
                  ),
                  Obx(
                    () => (controller.doctorInfo.value.name == null)
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                            child: BreadCrumb.builder(
                              itemCount: controller.menus.length,
                              builder: (index) {
                                // print("menus ->${controller.menus[index]}");
                                // print(
                                //     "selection dokter -> ${controller.spesialisMenus[index].name!}");
                                return BreadCrumbItem(
                                  content: Text(
                                    controller.menus[index],
                                    style: kPoppinsRegular400.copyWith(
                                        color: (controller.menus[index].contains(controller.doctorInfo.value.name!))
                                            ? kButtonColor
                                            : kSubHeaderColor.withOpacity(0.5)),
                                  ),
                                  onTap: index < controller.menus.length
                                      ? () {
                                          // TODO: CEK LAGI NANTI YA
                                          if (index == 0) {
                                            controller.menus.removeAt(index + 1);
                                            Get.back();
                                          }
                                        }
                                      : null,
                                  // textColor: ,
                                );
                              },
                              divider: const Text(" / "),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: screenWidth * 0.01,
                  ),
                  Obx(
                    () => Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 210,
                                  width: 210,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(22),
                                    child: controller.doctorInfo.value.photo == null
                                        ? Image.asset(
                                            "assets/account_info@3x.png",
                                            fit: BoxFit.cover,
                                          )
                                        : controller.doctorInfo.value.photo!.formats!.thumbnail == null
                                            ? Image.asset("assets/account-info@3x.png", fit: BoxFit.cover)
                                            : Image.network(
                                                addCDNforLoadImage(controller.doctorInfo.value.photo!.formats!.thumbnail!),
                                                fit: BoxFit.cover,
                                              ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.02,
                                ),
                                SizedBox(
                                  // width: screenWidth * 0.3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        controller.doctorInfo.value.name ?? "- - -",
                                        style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 25),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        controller.doctorInfo.value.specialization?.name ?? "- - -",
                                        style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 19),
                                      ),
                                      const SizedBox(
                                        height: 19,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 7),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              color: kButtonColor.withOpacity(0.1),
                                            ),
                                            child: Text(
                                              controller.doctorInfo.value.experience ?? "- - -",
                                              style: kSubHeaderStyle.copyWith(fontSize: 11, color: kButtonColor),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          if (controller.doctorInfo.value.hospital != null)
                                            SizedBox(
                                              height: 18,
                                              width: 300,
                                              child: Row(
                                                children: [
                                                  Image.network((controller.doctorInfo.value.hospital![0].icon == null ||
                                                          controller.doctorInfo.value.hospital![0].icon!.formats!.thumbnail == null)
                                                      ? "http://cdn.onlinewebfonts.com/svg/img_148071.png"
                                                      : addCDNforLoadImage(controller.doctorInfo.value.hospital![0].icon!.formats!.thumbnail!)),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(controller.doctorInfo.value.hospital![0].name ?? "- - -",
                                                      style: kPoppinsMedium500.copyWith(fontSize: 11, color: kBlackColor),
                                                      overflow: TextOverflow.ellipsis),
                                                ],
                                              ),
                                            )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 13,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Languages: ",
                                            style: kPoppinsRegular400.copyWith(color: kSubHeaderColor, fontSize: 13),
                                          ),
                                          Text(
                                            controller.doctorInfo.value.overview ?? "- - -",
                                            style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 23,
                                      ),
                                      Text(
                                        controller.doctorInfo.value.price?.formatted ?? "- - -",
                                        style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 22),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 1,
                                        width: screenWidth * 0.34,
                                        color: searchBarBorderColor.withOpacity(0.7),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        "Profil Dokter",
                                        style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 14),
                                      ),
                                      // const SizedBox(
                                      //   height: 3,
                                      // ),
                                      SizedBox(
                                        width: screenWidth * 0.3,
                                        child: buildDoctorProfileDescription(text: controller.doctorInfo.value.about ?? "- - -"),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Spacer()
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 57,
                  ),
                  Obx(
                    () => DefaultTabController(
                      length: controller.tabDesktopMenuDoctorProfile.length,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: screenWidth * 0.2,
                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: kTextHintColor))),
                                  child: TabBar(
                                    labelColor: kDarkBlue,
                                    labelPadding: EdgeInsets.zero,
                                    unselectedLabelColor: kSubHeaderColor.withOpacity(0.5),
                                    indicatorColor: kDarkBlue,
                                    labelStyle: kPoppinsMedium500.copyWith(fontSize: 14),
                                    tabs: List.generate(
                                      controller.tabDesktopMenuDoctorProfile.length,
                                      (index) => Tab(
                                        text: controller.tabDesktopMenuDoctorProfile[index],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 37,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                            child: SizedBox(
                              height: Get.height * 0.90,
                              child: TabBarView(physics: const NeverScrollableScrollPhysics(), children: [
                                buildJadwalDokterSection(screenWidth),
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Terms & Conditions:",
                                        style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Obx(
                                        () => (controller.tncBlock == null)
                                            ? Center(
                                                child: InkWell(
                                                  onTap: () {
                                                    controller.getTNCBlock();
                                                  },
                                                  child: Text(
                                                    "Klik di sini untuk mengulang",
                                                    style: kPoppinsMedium500.copyWith(fontSize: 14, height: 1.6, color: kBlackColor.withOpacity(0.5)),
                                                  ),
                                                ),
                                              )
                                            : HtmlWidget(
                                                controller.tncBlock!.text,
                                                textStyle: kPoppinsMedium500.copyWith(
                                                  fontSize: 12,
                                                  color: kBlackColor,
                                                ),
                                              ),
                                      )
                                    ],
                                  ),
                                )
                              ]),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 144,
                                  height: 40,
                                  child: Obx(
                                    () => ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(22.5),
                                          ),
                                          primary: kButtonColor,
                                          elevation: 0),
                                      onPressed: controller.selectedTime.value.isEmpty
                                          ? null
                                          : () async {
                                              // Get.dialog(
                                              //     const PatientConfirmationPage());

                                              controller.accessTokens.value = homeController.accessTokens.value;
                                              final result = await controller.checkAddress();

                                              if (result.status == false) {
                                                Get.dialog(
                                                  const LoginCheckDialog(),
                                                );
                                              } else {
                                                if (result.data!.address!.isEmpty) {
                                                  Get.dialog(const AddAddressDialog());
                                                } else {
                                                  // Get.toNamed(Routes.PATIENT_DATA);
                                                  final controller = Get.put(PatientDataController());

                                                  Get.dialog(const PatientDataDialog(), barrierDismissible: true);
                                                }
                                              }
                                            },
                                      child: Text(
                                        "Lanjut",
                                        style: kPoppinsMedium500.copyWith(color: kBackground, fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FooterSectionWidget(screenWidth: screenWidth)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildJadwalDokterSection(double screenWidth) {
    // final homeController = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Consult by",
          style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 16),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          width: screenWidth * 0.08,
          height: 28,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: kButtonColor)),
          child: Row(
            children: [
              SizedBox(
                width: 14,
                child: Image.asset("assets/vidcall_icon.png"),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "Video Call",
                style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 11),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 48,
        ),
        Text(
          "Pilih Jadwal yang tersedia",
          style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 16),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          "Menampilkan jadwal 7 hari kedepan",
          style: kPoppinsRegular400.copyWith(color: hinTextColor, fontSize: 13),
        ),
        const SizedBox(
          height: 30,
        ),
        if (controller.doctorInfo.value.doctorId != null)
          JadwalDokterDesktop(controller: controller, doctorId: controller.doctorInfo.value.doctorId!),
        const SizedBox(
          height: 30,
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       SizedBox(
        //         width: 144,
        //         height: 40,
        //         child: Obx(
        //           () => ElevatedButton(
        //             style: ElevatedButton.styleFrom(
        //                 shape: RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(22.5),
        //                 ),
        //                 primary: kButtonColor,
        //                 elevation: 0),
        //             onPressed: controller.selectedTime.value.isEmpty
        //                 ? null
        //                 : () async {
        //                     // Get.dialog(
        //                     //     const PatientConfirmationPage());

        //                     controller.accessTokens.value = homeController.accessTokens.value;
        //                     final result = await controller.checkAddress();

        //                     if (result.status == false) {
        //                       Get.dialog(
        //                         const LoginCheckDialog(),
        //                       );
        //                     } else {
        //                       if (result.data!.address!.isEmpty) {
        //                         Get.dialog(const AddAddressDialog());
        //                       } else {
        //                         // Get.toNamed(Routes.PATIENT_DATA);
        //                         final controller = Get.put(PatientDataController());

        //                         Get.dialog(const PatientDataDialog(), barrierDismissible: true);
        //                       }
        //                     }
        //                   },
        //             child: Text(
        //               "Lanjut",
        //               style: kPoppinsMedium500.copyWith(color: kBackground, fontSize: 13),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}

class PatientDataDialog extends StatelessWidget {
  const PatientDataDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    // final addPatientController = Get.put(AddPatientController());
    final controller = Get.find<PatientDataController>();

    if (controller.refreshPatientDataAndGoToListPatient.value) {
      controller.pageController = PageController(initialPage: 1);

      controller.update();
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: screenWidth * 0.38,
          width: screenWidth * 0.28,
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.pageController,
            onPageChanged: (index) {
              // print("page ke $index");
              controller.currentpage.value = index;
            },
            children: [
              const PatientTypeDesktopWebView(),
              PatientDataView(),
              AddPatientView(),
              AddPatientAddressView(),
              AddPatientConfirmedView(),
              const PatientConfirmationPage(),
            ],
          ),
        ),
      ),
    );
  }
}

class AddAddressDialog extends StatelessWidget {
  const AddAddressDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;

    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(height: screenWidth * 0.38, width: screenWidth * 0.28, child: PatientAddressView()),
        ));
  }
}

class LoginCheckDialog extends StatelessWidget {
  const LoginCheckDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final GlobalKey<FormState> loginKey = GlobalKey<FormState>();

    final loginController = Get.put(LoginController());
    final homeController = Get.find<HomeController>();
    final specialistController = Get.find<SpesialisKonsultasiController>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: SizedBox(
        height: screenWidth * 0.4,
        width: screenWidth * 0.3,
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 40),
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
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 40),
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
                          const SizedBox(height: 8),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
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
                              final MyProfile profile = await homeController.getProfile();

                              if (profile.data!.userDetails!.avatar != null) {
                                homeController.avatarUrl.value = profile.data!.userDetails!.avatar["formats"]["thumbnail"].toString();
                              }
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
                        Expanded(
                          child: Container(
                            // width: double.infinity,
                            height: 1,
                            color: Colors.black38,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildDoctorProfileDescription({
  required String text,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 2),
    height: 100,
    child: HtmlWidget(
      text,
      textStyle: kPoppinsRegular400.copyWith(color: kSubHeaderColor, fontSize: 13),
    ),
  );
}

class JadwalDokterDesktop extends StatelessWidget {
  const JadwalDokterDesktop({
    Key? key,
    required this.controller,
    required this.doctorId,
  }) : super(key: key);

  final SpesialisKonsultasiController controller;
  final String doctorId;

  @override
  Widget build(BuildContext context) {
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
                onTap: (index) {
                  controller.selectedTime.value = '';
                  // controller.onTap();

                  controller.selectDate.value = DateFormat("yyyy-MM-dd").format(controller.listDate[controller.tabController.index]);
                },
                controller: controller.tabController,
                labelColor: kDarkBlue,
                labelPadding: EdgeInsets.zero,
                unselectedLabelColor: kSubHeaderColor.withOpacity(0.5),
                indicatorColor: kDarkBlue,
                labelStyle: kPoppinsMedium500.copyWith(fontSize: 14),
                tabs: List.generate(
                  controller.listDate.length,
                  (index) {
                    return Tab(
                      text: controller.listDate[index].day == DateTime.now().day
                          ? 'Hari ini'
                          : DateFormat('EEEE', 'id').format(controller.listDate[index]),
                    );
                  },
                )),
          ),
          Obx(
            () => FutureBuilder(
              future: controller.getDoctorSchedule(doctorId: doctorId, date: controller.selectDate.value),
              builder: (_, snapshot) {
                // final ScrollController jadwalScrollController =
                //     ScrollController();
                if (snapshot.connectionState.index == 3) {
                  final DoctorSchedules result = snapshot.data! as DoctorSchedules;
                  return Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: Get.height * 0.5,
                    child: TabBarView(
                      controller: controller.tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                        controller.listDate.length,
                        (_) => result.status == false || result.data!.isEmpty
                            ? SizedBox(
                                height: 100,
                                width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 100,
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
                                      style: kPoppinsRegular400.copyWith(color: kBlackColor, fontSize: 14),
                                    )
                                  ],
                                ),
                              )
                            : SingleChildScrollView(
                                child: Wrap(
                                  children: List.generate(
                                    result.data!.length,
                                    (index) => Obx(
                                      () => Container(
                                        width: 150,
                                        height: 42,
                                        margin: const EdgeInsets.only(right: 12, bottom: 12),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                controller.selectedTime.value == "${result.data![index].startTime} - ${result.data![index].endTime}"
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
                                                  color: controller.selectedTime.value ==
                                                          "${result.data![index].startTime} - ${result.data![index].endTime}"
                                                      ? kButtonColor
                                                      : kBlackColor,
                                                  fontSize: 14),
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
                  return const SizedBox(
                    height: 100,
                    width: 100,
                    child: Center(
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
