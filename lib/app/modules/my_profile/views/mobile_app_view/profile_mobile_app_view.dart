import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/utils/use_shared_pref.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/data/model/user.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/my_profile/controllers/my_profile_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileMobileAppView extends StatefulWidget {
  @override
  _ProfileMobileAppViewState createState() => _ProfileMobileAppViewState();
}

class _ProfileMobileAppViewState extends State<ProfileMobileAppView> {
  @override
  MyProfileController controller = Get.put(MyProfileController());

  HomeController homeController = Get.put(HomeController());

  List<String> routings = ['/profile-edit', '/profile-settings', '/profile-faq', '/profile-contact', '/profile-tnc', '/profile-privacy', ""];

  String username = '';

  List<String> menus = ['Profil', 'Pengaturan', 'FAQ', 'Kontak Altea Care', 'Syarat & Ketentuan', 'Privacy Policy', 'Keluar'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            FutureBuilder<User>(
                future: homeController.getUserProfile(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    username = '${snapshot.data!.data!.firstName} ${snapshot.data!.data!.lastName}';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: MediaQuery.of(context).size.width / 8,
                              backgroundImage: NetworkImage(snapshot.data!.data!.userDetails!.avatar == null
                                  ? ''
                                  : (snapshot.data!.data!.userDetails!.avatar as Map<String, dynamic>)['formats']['thumbnail'] as String),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                // child: IconButton(
                                //   icon: Icon(
                                //     Icons.add_circle,
                                //     size: 30,
                                //   ),
                                //   onPressed: () {},
                                // )
                                child: InkWell(
                                  onTap: () {
                                    // print('upload image');
                                    // controller.pickImage(src);
                                    showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                              child: Container(
                                                margin: EdgeInsets.all(16),
                                                width: MediaQuery.of(context).size.width * 0.6,
                                                height: MediaQuery.of(context).size.height * 0.1,
                                                decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(16)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        Get.back();
                                                        await controller.pickImage(ImageSource.camera);
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                          margin: EdgeInsets.all(8),
                                                          child: Text(
                                                            'Ambil Gambar',
                                                            style: kPoppinsMedium500.copyWith(fontSize: 14, color: kBlackColor),
                                                          )),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        Get.back();
                                                        await controller.pickImage(ImageSource.gallery);
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets.all(8),
                                                        child: Text(
                                                          'Pilih dari Album',
                                                          style: kPoppinsMedium500.copyWith(fontSize: 14, color: kBlackColor),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ));
                                  },
                                  child: CircleAvatar(
                                    radius: MediaQuery.of(context).size.width * 0.035,
                                    backgroundColor: kBackground,
                                    child: CircleAvatar(
                                      radius: MediaQuery.of(context).size.width * 0.03,
                                      backgroundColor: kButtonColor,
                                      child: Icon(
                                        Icons.add,
                                        color: kBackground,
                                        size: MediaQuery.of(context).size.width * 0.04,
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          '${snapshot.data!.data!.firstName} ${snapshot.data!.data!.lastName}',
                          style: kPoppinsMedium500.copyWith(fontSize: 17, color: Colors.black),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          snapshot.data!.data!.email!,
                          style: kPoppinsRegular400.copyWith(fontSize: 14, color: kBlackColor.withOpacity(0.5)),
                        )
                      ],
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.all(16),
                      child: CupertinoActivityIndicator(),
                    );
                  }
                }),
            const SizedBox(
              height: 16,
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: menus.length,
              itemBuilder: (context, idx) {
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 1, color: kBlackColor.withOpacity(0.3)),
                          bottom: BorderSide(width: 1, color: kBlackColor.withOpacity(0.15)))),
                  child: InkWell(
                    onTap: () async {
                      if (idx != 6) {
                        Get.toNamed(routings[idx]);
                      } else {
                        Get.defaultDialog(
                          content: Container(
                              padding: EdgeInsets.all(16),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Apakah anda yakin mau keluar dari akun ',
                                        style: kPoppinsRegular400.copyWith(fontSize: 13, color: kBlackColor)),
                                    TextSpan(text: '$username ?', style: kPoppinsSemibold600.copyWith(fontSize: 13, color: kBlackColor)),
                                  ],
                                ),
                              )
                              // Text(
                              //     'Apakah anda yakin mau keluar dari akun $username ?',
                              //     textAlign: TextAlign.center,
                              //     style: kPoppinsRegular400.copyWith(
                              //       fontSize: 13,
                              //     )),
                              ),
                          title: '',
                          radius: 8,
                          middleTextStyle: kPoppinsRegular400.copyWith(fontSize: 13, color: kBlackColor.withOpacity(0.7)),
                          confirm: CustomFlatButton(
                              width: MediaQuery.of(context).size.width * 0.3,
                              text: 'Keluar',
                              onPressed: () async {
                                var res = await controller.userLogout();
                                // print('error => $res');

                                if (res['status'] as bool) {
                                  await AppSharedPreferences.deleteAccessToken();
                                  homeController.currentIdx.value = 0;
                                  Get.back();
                                  Get.offNamed('/login');
                                } else {
                                  Get.back();
                                }
                              },
                              color: kButtonColor),
                          cancel: CustomFlatButton(
                            width: MediaQuery.of(context).size.width * 0.3,
                            text: 'Batal',
                            onPressed: () {
                              Get.back();
                            },
                            color: kBackground,
                            borderColor: kButtonColor,
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          menus[idx],
                          style: kPoppinsRegular400.copyWith(fontSize: 13, color: kBlackColor.withOpacity(0.7)),
                        ),
                        if (idx < 5)
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: kBlackColor.withOpacity(0.7),
                          )
                        else
                          Container()
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
