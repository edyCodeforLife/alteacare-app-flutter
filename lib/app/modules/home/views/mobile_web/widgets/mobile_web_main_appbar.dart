// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:another_flushbar/flushbar.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/data/model/user.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:altea/app/modules/verif_otp/views/verify_otp_dialog.dart';
import 'package:altea/app/modules/verify_email/controllers/verify_email_controller.dart';
import 'package:altea/app/modules/verify_email/verify_email_dialog.dart';
import '../../../../../core/utils/colors.dart';

class MobileWebMainAppbar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  final HomeController controller = Get.find<HomeController>();

  MobileWebMainAppbar({
    required this.scaffoldKey,
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      elevation: 5,
      backgroundColor: kBackground,
      centerTitle: false,
      leadingWidth: 0,
      title: InkWell(
        onTap: () {
          if (Get.currentRoute != "/home") {
            Get.offNamed("/home");
          }
        },
        child: Image.asset(
          'assets/altea_logo.png',
          width: MediaQuery.of(context).size.width / 3,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Obx(
          () => (controller.accessTokens.value.isNotEmpty)
              ? FutureBuilder(
                  future: controller.getUserCheckEmailVerificationMobileWeb(context, () async {
                    final verifyEmailController = Get.put(VerifyEmailController());
                    // print(controller.userForWeb.data!.email.toString());
                    final result = await verifyEmailController.sendVerificationEmailWithEmailInput(controller.userForWeb.data!.email!);
                    if (result['status'] == true) {
                      Get.back();
                      Get.dialog(
                        VerifyOtpDialogMobileWeb(email: controller.userForWeb.data!.email!),
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
                  }),
                  builder: (_, snapshot) {
                    return Container();
                  },
                )
              : Container(),
        ),
      ),
      actions: [
        Obx(
          () => (controller.accessTokens.value.isEmpty)
              ? Container()
              : (controller.verificationBannerStatus)
                  ? Container(
                      margin: const EdgeInsets.only(
                        right: 5,
                      ),
                      child: InkWell(
                        onTap: () async {
                          final verifyEmailController = Get.put(VerifyEmailController());
                          // print(controller.userForWeb.data!.email.toString());
                          final result = await verifyEmailController.sendVerificationEmailWithEmailInput(controller.userForWeb.data!.email!);
                          if (result['status'] == true) {
                            Get.back();
                            Get.dialog(
                              VerifyOtpDialogMobileWeb(email: controller.userForWeb.data!.email!),
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
                        },
                        child: Icon(
                          Icons.mark_email_unread_outlined,
                          color: kButtonColor,
                          size: Get.width * 0.08,
                        ),
                      ),
                    )
                  : Container(),
        ),
        Container(
          margin: const EdgeInsets.only(
            right: 10,
          ),
          child: InkWell(
            onTap: () {
              scaffoldKey.currentState?.openDrawer();
            },
            child: Icon(
              Icons.menu,
              color: kButtonColor,
              size: Get.width * 0.08,
            ),
          ),
        ),
      ],
    );
  }
}
