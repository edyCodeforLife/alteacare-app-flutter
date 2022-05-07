import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/data/model/user.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomepageProfileCard extends StatelessWidget {
  HomeController controller = Get.find<HomeController>();

  String getYear(String birthDate) {
    // print('birthDate => $birthDate');
    List<String> dates = birthDate.split(' ')[0].split('-');
    int month = int.parse(dates[1]);
    int year = int.parse(dates[0]);
    int day = int.parse(dates[2]);
    var birth = DateTime.utc(year, month, day);
    var now = DateTime.now();

    var diff = now.difference(birth).inDays / 365;
    // print('ini diff => $diff');
    return diff.toInt().toString();
  }

  ImageProvider getImage(String? url) {
    // print('url ====> $url');
    if (url != null) {
      // print('masuk sini');
      return NetworkImage(url);
    } else {
      // print('masuk network image');
      return const AssetImage('assets/account-info@2x.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: controller.getUserProfile(),
        builder: (context, snapshot) {
          // print('snapshot.data => ${snapshot.data}');
          User? user;
          if (snapshot.hasData) {
            user = snapshot.data;
            // if (user!.message! == 'jwt expired') {
            //   Get.offNamed('/login');
            // }
          }

          return Container(
            color: kWhiteGray,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: kBackground,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [kBoxShadow],
              ),
              padding: const EdgeInsets.all(10),
              child: snapshot.hasData
                  ? (snapshot.data!.data == null)
                      ? Container()
                      : Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 7,
                              height: MediaQuery.of(context).size.width / 7,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                      image: NetworkImage(snapshot.data!.data!.userDetails!.avatar == null
                                          ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                                          : (snapshot.data!.data!.userDetails!.avatar as Map<String, dynamic>)['formats']['thumbnail'] as String),
                                      fit: BoxFit.cover)),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${user?.data!.firstName!} ${user?.data!.lastName}'),
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Row(
                                    children: [
                                      Text(
                                        getYear(user!.data!.userDetails!.birthDate!.toString()),
                                        style: kVerifText1.copyWith(fontWeight: FontWeight.w500, color: const Color(0xFF717579)),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Tahun',
                                        style: kValidationText.copyWith(color: const Color(0xFF9FA5AC)),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        '0',
                                        style: kVerifText1.copyWith(fontWeight: FontWeight.w500, color: const Color(0xFF717579)),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Poin',
                                        style: kValidationText.copyWith(color: const Color(0xFF9FA5AC)),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                  : const Center(
                      child: CupertinoActivityIndicator(),
                    ),
            ),
          );
        });
  }
}
