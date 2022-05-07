import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavBar extends GetView<HomeController> {
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
          // margin: const EdgeInsets.only(top: 8),
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: const BoxDecoration(
            color: kBackground,
            borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 1),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: Container(
              color: kBackground,
              height: MediaQuery.of(context).size.height * 0.1,
              child: BottomNavigationBar(
                backgroundColor: kBackground,
                type: BottomNavigationBarType.fixed,
                onTap: (idx) {
                  controller.currentIdx.value = idx;
                  // print(controller.currentIdx.value.toString());
                },
                currentIndex: controller.currentIdx.value,
                selectedItemColor: kButtonColor,
                unselectedItemColor: kTextHintColor,
                showUnselectedLabels: true,
                selectedIconTheme: IconThemeData(color: kButtonColor),
                selectedLabelStyle: kHomeSmallText.copyWith(fontWeight: FontWeight.w500, color: kButtonColor),
                unselectedIconTheme: IconThemeData(color: kTextHintColor),
                unselectedLabelStyle: kHomeSmallText.copyWith(fontWeight: FontWeight.w500, color: kButtonColor),
                showSelectedLabels: true,
                // ignore: prefer_const_literals_to_create_immutables
                items: <BottomNavigationBarItem>[
                  const BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage('assets/path@2x.png'),
                        size: 20,
                      ),
                      label: 'Beranda'),
                  const BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage('assets/spesialis@2x.png'),
                      size: 25,
                    ),
                    label: 'Spesialis',
                  ),
                  const BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage('assets/icon@2x.png'),
                        size: 25,
                      ),
                      label: 'Konsultasi Saya'),
                  const BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage('assets/group_6.png'),
                      size: 30,
                    ),
                    label: 'Akun',
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
