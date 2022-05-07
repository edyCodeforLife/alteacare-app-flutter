// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/screen_size.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/data/model/notification_model.dart';
import 'package:altea/app/modules/doctor/controllers/doctor_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:altea/app/modules/notifications/views/desktop_web_view/desktop_web_notification_card.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import 'package:altea/app/modules/verif_otp/views/verify_otp_dialog.dart';
import 'package:altea/app/modules/verify_email/controllers/verify_email_controller.dart';
import 'package:altea/app/routes/app_pages.dart';

class NavBarSectionLoginWidget extends GetView<HomeController> {
  const NavBarSectionLoginWidget({
    Key? key,
    required this.screenWidth,
  }) : super(key: key);

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final doctorController = Get.find<DoctorController>();
    final NotificationsController _notificationsController = Get.find();
    ScreenSize.recalculate(context);

    return Container(
      decoration: BoxDecoration(
          color: kBackground, boxShadow: [BoxShadow(color: fullBlack.withAlpha(10), offset: const Offset(0, 4), spreadRadius: 1, blurRadius: 12)]),
      width: screenWidth,
      child: Column(
        children: [
          SizedBox(
            height: 0.5.hb,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.wb),
            child: Row(
              children: [
                // SizedBox(
                //   width: screenWidth * 0.1,
                // ),
                InkWell(
                  onTap: () {
                    Get.offNamed(
                      Routes.HOME,
                    );
                    Get.delete<SpesialisKonsultasiController>();

                    if (controller.menus.length > 1) {
                      controller.menus.removeRange(1, controller.menus.length);
                    }

                    // print("menus-> ${controller.menus.length}");
                  },
                  child: SizedBox(
                      width: 10.wb,
                      height: 10.hb,
                      child: Image.asset(
                        "assets/altea_logo.png",
                      )),
                ),
                const Spacer(),
                Expanded(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (controller.menus.length > 1) {
                            controller.menus.removeRange(1, controller.menus.length - 1);
                          }

                          Get.offNamed(
                            Routes.HOME,
                          );
                          Get.delete<SpesialisKonsultasiController>();
                        },
                        child: Text(
                          "Beranda",
                          style: berandaRoutes.contains(Get.currentRoute.contains("?") ? Get.currentRoute.split("?").first : Get.currentRoute)
                              ? kPoppinsSemibold600.copyWith(
                                  fontSize: 1.wb,
                                  color: berandaRoutes.contains(Get.currentRoute.contains("?") ? Get.currentRoute.split("?").first : Get.currentRoute)
                                      ? kSubHeaderColor
                                      : kSubHeaderColor.withOpacity(0.5))
                              : kPoppinsRegular400.copyWith(
                                  fontSize: 1.wb,
                                  color: berandaRoutes.contains(Get.currentRoute.contains("?") ? Get.currentRoute.split("?").first : Get.currentRoute)
                                      ? kSubHeaderColor
                                      : kSubHeaderColor.withOpacity(0.5)),
                        ),
                      ),
                      SizedBox(
                        width: 2.wb,
                      ),
                      InkWell(
                        onTap: () {
                          if (controller.menus.length > 1) {
                            controller.menus.removeAt(1);
                          }

                          Get.toNamed(
                            Routes.DOCTOR,
                          );
                          Get.delete<SpesialisKonsultasiController>();
                        },
                        child: Row(
                          children: [
                            Text(
                              "Dokter Spesialis",
                              style: dokterSpesialisRoutes
                                      .contains(Get.currentRoute.contains("?") ? Get.currentRoute.split("?").first : Get.currentRoute)
                                  ? kPoppinsSemibold600.copyWith(
                                      fontSize: 1.wb,
                                      color: dokterSpesialisRoutes
                                              .contains(Get.currentRoute.contains("?") ? Get.currentRoute.split("?").first : Get.currentRoute)
                                          ? kSubHeaderColor
                                          : kSubHeaderColor.withOpacity(0.5))
                                  : kPoppinsRegular400.copyWith(
                                      fontSize: 1.wb,
                                      color: dokterSpesialisRoutes
                                              .contains(Get.currentRoute.contains("?") ? Get.currentRoute.split("?").first : Get.currentRoute)
                                          ? kSubHeaderColor
                                          : kSubHeaderColor.withOpacity(0.5)),
                            ) // Icon(,
                            //   Icons.keyboard_arrow_down_rounded,
                            //   color: controller.isSelectedTabDokter.value
                            //       ? kSubHeaderColor
                            //       : kSubHeaderColor.withOpacity(0.5),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 2.wb,
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(
                            Routes.MY_CONSULTATION,
                          );
                          Get.delete<SpesialisKonsultasiController>();
                        },
                        child: Text(
                          "Konsultasi Saya",
                          style: konsultasiSayaRoutes.contains(Get.currentRoute.contains("?") ? Get.currentRoute.split("?").first : Get.currentRoute)
                              ? kPoppinsSemibold600.copyWith(
                                  fontSize: 1.wb,
                                  color: konsultasiSayaRoutes
                                          .contains(Get.currentRoute.contains("?") ? Get.currentRoute.split("?").first : Get.currentRoute)
                                      ? kSubHeaderColor
                                      : kSubHeaderColor.withOpacity(0.5))
                              : kPoppinsRegular400.copyWith(
                                  fontSize: 1.wb,
                                  color: konsultasiSayaRoutes
                                          .contains(Get.currentRoute.contains("?") ? Get.currentRoute.split("?").first : Get.currentRoute)
                                      ? kSubHeaderColor
                                      : kSubHeaderColor.withOpacity(0.5)),
                        ),
                      ),
                      SizedBox(
                        width: 2.wb,
                      ),
                      InkWell(
                        onTap: () {
                          Get.dialog(
                              Stack(
                                children: const [
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Dialog(
                                      child: NotificationContainer(),
                                    ),
                                  )
                                ],
                              ),
                              barrierColor: Colors.transparent);
                          // controller.showNotificationContainer.value = !controller.showNotificationContainer.value;
                          // controller.showReminder.value =
                          //     !controller.showReminder.value;

                          // controller.showReminder.value
                          //     ? Get.dialog(const ReminderConsultationDialog())
                          //     : Container();
                        },
                        child: SizedBox(
                          width: 1.3.wb,
                          height: 1.3.wb,
                          child: Stack(
                            children: [
                              Icon(
                                Icons.notifications,
                                size: 1.4.wb,
                                color: kBlackColor.withOpacity(0.7),
                              ),
                              Obx(
                                () => _notificationsController.notifications.isEmpty
                                    ? Container()
                                    : Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          width: 1.wb,
                                          height: 1.wb,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kRedError,
                                            border: Border.all(
                                              color: kBackground,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 2.wb),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.MY_PROFILE);
                        },
                        child: Obx(
                          () => controller.avatarUrl.value.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: SizedBox(
                                    width: 2.2.wb,
                                    height: 2.2.wb,
                                    // decoration: BoxDecoration(
                                    //   shape: BoxShape.circle,
                                    //   image: DecorationImage(
                                    //       image: NetworkImage(
                                    //         ,
                                    //       ),
                                    //       fit: BoxFit.cover),
                                    // ),
                                    child: Image.network(
                                      addCDNforLoadImage(controller.avatarUrl.value),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 2.wb,
                                  height: 3.8.hb,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage('assets/account-info.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
                // Expanded(
                //   child: Row(
                //     children: [
                //       InkWell(
                //         onTap: () {},
                //         child: Text(
                //           "Beranda",
                //           style: kPoppinsRegular400,
                //         ),
                //       ),
                //       SizedBox(
                //         width: screenWidth * 0.02,
                //       ),
                //       InkWell(
                //         onTap: () {},
                //         child: Row(
                //           children: [
                //             Text(
                //               "Dokter Spesialis",
                //               style: kPoppinsRegular400,
                //             ),
                //             Icon(
                //               Icons.keyboard_arrow_down_rounded,
                //               color: kSubHeaderColor,
                //             ),
                //           ],
                //         ),
                //       ),
                //       SizedBox(
                //         width: screenWidth * 0.02,
                //       ),
                //       InkWell(
                //         onTap: () {},
                //         child: Text(
                //           "Konsultasi Saya",
                //           style: kPoppinsRegular400,
                //         ),
                //       ),
                //       SizedBox(
                //         width: screenWidth * 0.02,
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          FutureBuilder(
            future: controller.getUserProfileForWeb(),
            builder: (_, snapshot) {
              return (
                      // 1+1 == 2
                      controller.verificationBannerStatus)
                  ? Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                        color: kMidnightBlue,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Spacer(),
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                  size: screenWidth * 0.02,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  child: Text(
                                    'Verifikasi Email Anda',
                                    style: kValidationText.copyWith(color: kBackground, fontSize: screenWidth * 0.01),
                                  ),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final VerifyEmailController verifyEmailController = Get.put(VerifyEmailController());
                              if (controller.userForWeb.data != null) {
                                // print(controller.userForWeb.data!.email.toString());
                                final result = await verifyEmailController.sendVerificationEmailWithEmailInput(controller.userForWeb.data!.email!);
                                if (result['status'] == true) {
                                  Get.back();
                                  Get.dialog(
                                    VerifyOtpDialog(email: controller.userForWeb.data!.email!),
                                  );
                                  // Get.toNamed('/verify/otp');
                                } else {
                                  Get.dialog(
                                    CustomSimpleDialog(
                                      icon: const ImageIcon(
                                        AssetImage('assets/group-5.png'),
                                        size: 200,
                                        color: kRedError,
                                      ),
                                      onPressed: () => Get.back(),
                                      title: 'Verifikasi Gagal',
                                      buttonTxt: 'Kembali',
                                      subtitle: result['message'].toString(),
                                    ),
                                  );
                                }
                              } else {
                                Get.dialog(
                                  CustomSimpleDialog(
                                    icon: const ImageIcon(
                                      AssetImage('assets/group-5.png'),
                                      size: 200,
                                      color: kRedError,
                                    ),
                                    onPressed: () => Get.back(),
                                    title: 'Verifikasi Gagal',
                                    buttonTxt: 'Kembali',
                                    subtitle: "email tidak valid",
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: kMidnightBlue, borderRadius: BorderRadius.circular(8), border: Border.all(color: kBackground, width: 1)),
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: 4),
                                child: Text(
                                  'Verifikasi',
                                  style: kValidationText.copyWith(color: kBackground, fontSize: screenWidth * 0.01),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          // IconButton(
                          //   icon: const Icon(
                          //     Icons.close,
                          //     color: Colors.white,
                          //     size: 15,
                          //   ),
                          //   onPressed: () {
                          //     controller.dismissWebVerificationBanner();
                          //   },
                          // ),
                        ],
                      ),
                    )
                  : Container();
            },
          ),
        ],
      ),
    );
  }
}

class NotificationContainer extends StatelessWidget {
  const NotificationContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final screenWidth = context.width;
    final NotificationsController _notificationsController = Get.find();
    return Container(
        width: screenWidth * 0.3,
        // height: screenWidth * 0.3,
        decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(22), boxShadow: [
          BoxShadow(
            color: kLightGray,
            offset: const Offset(
              0.0,
              3.0,
            ),
            blurRadius: 12.0,
          ),
        ]),
        child: FutureBuilder(
          future: _notificationsController.getNotifWeb(),
          builder: (context, data) {
            if (data.hasData) {
              // print(data.data.toString());
              final List<NotificationModel> _unSeenNotifications =
                  (data.data! as List).map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).where((nm) => !nm.isRead).toList();
              _unSeenNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
              if (_unSeenNotifications.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      const Text("Belum ada notifikasi"),
                      const SizedBox(
                        height: 15,
                      ),
                      TextButton(
                        onPressed: () {
                          homeController.showNotificationContainer.value = false;
                          _notificationsController.getNotifWeb();
                          Get.toNamed(Routes.NOTIFICATIONS);
                        },
                        child: Text(
                          "Lihat Semua",
                          style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    ...List.generate(
                      _unSeenNotifications.length > 4 ? 3 : _unSeenNotifications.length,
                      (index) => Column(
                        children: [
                          DesktopWebNotificationCard(notification: _unSeenNotifications[index], screenWidth: screenWidth),
                          // notificationCard(),
                          Container(
                            height: 1,
                            width: screenWidth * 0.27,
                            color: grayDarker.withOpacity(0.5),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                      onPressed: () {
                        homeController.showNotificationContainer.value = false;
                        _notificationsController.getNotifWeb();
                        Get.toNamed(Routes.NOTIFICATIONS);
                      },
                      child: Text(
                        "Lihat Semua",
                        style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 11),
                      ),
                    ),
                  ],
                );
              }
            } else {
              return const Center(
                child: Text("Belum ada notifikasi"),
              );
            }
          },
        ));
  }

  Widget notificationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(color: kLightGray.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: Image.asset(
                "assets/no_file_upload_icon.png",
                color: kDarkBlue,
                height: 30,
                width: 30,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hari ini 09.30",
                style: kPoppinsRegular400.copyWith(color: bannerUploadTextColor, fontSize: 8),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Pembayaran Diterima",
                style: kPoppinsMedium500.copyWith(color: fullBlack, fontSize: 12),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Order ID No. 66870080 telah dibayar. Klik di sini untuk melihat status anda.",
                style: kPoppinsMedium500.copyWith(color: kTextHintColor, fontSize: 9),
              ),
            ],
          )
        ],
      ),
    );
  }
}
