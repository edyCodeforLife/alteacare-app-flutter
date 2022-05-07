import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/data/model/user.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileEditMobileView extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        centerTitle: true,
        title: Text(
          'Profil',
          style: kAppBarTitleStyle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kBlackColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: FutureBuilder<User>(
              future: controller.getUserProfile(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // print('dataaa => ${snapshot.data!.data!.userAddresses!.isEmpty}');
                  return Column(
                    children: [
                      TitleSection(
                        title: 'Personal Data',
                        onPressed: () {
                          Get.toNamed('/profile-edit-detail', arguments: 'personal');
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: kWhiteGray),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Nama                        :',
                                  style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.6)),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  '${snapshot.data!.data!.firstName} ${snapshot.data!.data!.lastName}',
                                  style: kPoppinsMedium500.copyWith(fontSize: 11, color: kBlackColor),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Umur                          :',
                                  style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.6)),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  '${snapshot.data!.data!.userDetails!.age!.year} Tahun',
                                  style: kPoppinsMedium500.copyWith(fontSize: 11, color: kBlackColor),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Jenis Kelamin         :',
                                  style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.6)),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  snapshot.data!.data!.userDetails!.gender == 'FEMALE' ? 'Perempuan' : 'Laki-Laki',
                                  style: kPoppinsMedium500.copyWith(fontSize: 11, color: kBlackColor),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Tempat Lahir          :',
                                  style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.6)),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  '${snapshot.data!.data!.userDetails!.birthPlace}, ${snapshot.data!.data!.userDetails!.birthCountry?.name}',
                                  style: kPoppinsMedium500.copyWith(fontSize: 11, color: kBlackColor),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Tanggal Lahir         :',
                                  style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.6)),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  snapshot.data!.data!.userDetails!.birthDate.toString().split(' ')[0],
                                  style: kPoppinsMedium500.copyWith(fontSize: 11, color: kBlackColor),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Alamat                      :',
                                  style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.6)),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  child: snapshot.data!.data!.userAddresses!.isEmpty
                                      ? Text(
                                          '-',
                                          style: kPoppinsMedium500.copyWith(fontSize: 11, color: kBlackColor),
                                        )
                                      : Text(
                                          "${snapshot.data!.data!.userAddresses![0]['street'] == null ? " " : snapshot.data!.data!.userAddresses![0]['street']!}, Blok RT/RW${snapshot.data!.data!.userAddresses![0]['rt_rw'] == null ? " " : snapshot.data!.data!.userAddresses![0]['rt_rw']!}, Kel. ${snapshot.data!.data!.userAddresses![0]['subdistrict'] == null ? " " : snapshot.data!.data!.userAddresses![0]['subdistrict']!.name}, Kec.${snapshot.data!.data!.userAddresses![0]['district'] == null ? "" : snapshot.data!.data!.userAddresses![0]['district']!['name']} ${snapshot.data!.data!.userAddresses![0]['city'] == null ? "" : snapshot.data!.data!.userAddresses![0]['city']!['name']} ${snapshot.data!.data!.userAddresses![0]['province'] == null ? " " : snapshot.data!.data!.userAddresses![0]['province']!['name']} ${snapshot.data!.data!.userAddresses![0]['subdistrict'] == null ? " " : snapshot.data!.data!.userAddresses![0]['subdistrict']!['postal_code']}",
                                          style: kPoppinsMedium500.copyWith(fontSize: 11, color: kBlackColor),
                                        ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TitleSection(
                        title: 'Anggota Keluarga',
                        onPressed: () {
                          Get.toNamed('/patient-list', arguments: 'address');
                        },
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TitleSection(
                          title: 'No. Handphone',
                          onPressed: () {
                            Get.toNamed('/profile-edit-detail', arguments: 'phone');
                          }),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: kWhiteGray),
                        padding: EdgeInsets.all(16),
                        child: Text(
                          snapshot.data!.data!.phone.toString(),
                          style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
                        ),
                      ),
                      SizedBox(height: 16),
                      TitleSection(
                          title: 'Alamat Email',
                          onPressed: () {
                            Get.toNamed('/profile-edit-detail', arguments: 'email');
                          }),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: kWhiteGray),
                        padding: EdgeInsets.all(16),
                        child: Text(
                          snapshot.data!.data!.email.toString(),
                          style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
                        ),
                      ),
                      SizedBox(height: 16),
                      TitleSection(
                          title: 'Alamat Pengiriman',
                          onPressed: () {
                            Get.toNamed('/profile-edit-detail', arguments: 'address');
                          }),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: kWhiteGray),
                        padding: EdgeInsets.all(16),
                        child: snapshot.data!.data!.userAddresses!.isEmpty
                            ? Text(
                                '-',
                                style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
                              )
                            : Text(
                                "${snapshot.data!.data!.userAddresses![0]['street'] == null ? " " : snapshot.data!.data!.userAddresses![0]['street']!}, Blok RT/RW${snapshot.data!.data!.userAddresses![0]['rt_rw'] == null ? " " : snapshot.data!.data!.userAddresses![0]['rt_rw']!}, Kel. ${snapshot.data!.data!.userAddresses![0]['subdistrict'] == null ? " " : snapshot.data!.data!.userAddresses![0]['subdistrict']!.name}, Kec.${snapshot.data!.data!.userAddresses![0]['district'] == null ? "" : snapshot.data!.data!.userAddresses![0]['district']!['name']} ${snapshot.data!.data!.userAddresses![0]['city'] == null ? "" : snapshot.data!.data!.userAddresses![0]['city']!['name']} ${snapshot.data!.data!.userAddresses![0]['province'] == null ? " " : snapshot.data!.data!.userAddresses![0]['province']!['name']} ${snapshot.data!.data!.userAddresses![0]['subdistrict'] == null ? " " : snapshot.data!.data!.userAddresses![0]['subdistrict']!['postal_code']}",
                                style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
                              ),
                      )
                    ],
                  );
                } else {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  String title;
  void Function() onPressed;

  TitleSection({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor.withOpacity(0.7)),
        ),
        InkWell(
          onTap: onPressed,
          child: Text(
            'Ubah',
            style: kPoppinsSemibold600.copyWith(fontSize: 11, color: kDarkBlue),
          ),
        )
      ],
    );
  }
}
