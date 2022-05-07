// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/helper.dart' as helper;
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/footer_mobile_web_view.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import '../../models/obat_demo_model.dart';

class MWTebusObatSuccessScreen extends StatelessWidget {
  final List<ObatDemo> listObatDemo;
  MWTebusObatSuccessScreen({required this.listObatDemo}) {
    int a = 0;
    for (ObatDemo o in listObatDemo) {
      a += o.price as int;
    }
    totalHarga = a;
  }
  late final int totalHarga;
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MobileWebHamburgerMenu(),
      key: scaffoldKey,
      appBar: MobileWebMainAppbar(
        scaffoldKey: scaffoldKey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xffeceff2),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Text(
                    "Order ID:  ",
                    style: kPoppinsMedium500.copyWith(color: kBlackColor),
                  ),
                  Text(
                    listObatDemo.hashCode.toString(),
                    style: kPoppinsSemibold600.copyWith(color: kDarkBlue),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(color: kBackground, boxShadow: [kBoxShadow]),
              child: Center(
                  child: Column(
                children: [
                  Image.asset(
                    "assets/success_icon.png",
                    scale: 4,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Tebus Obat Berhasil",
                    style: kPoppinsSemibold600.copyWith(color: kBlackColor),
                  ),
                ],
              )),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(color: kBackground, boxShadow: [kBoxShadow]),
              child: Column(
                children: [
                  Text(
                    "Anda telah melakukan tebus obat, sebentar lagi petugas farmasi Rumah Sakit akan menghubungi anda dalam 30menit.",
                    style: kPoppinsRegular400.copyWith(fontSize: 12),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ...listObatDemo
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      e.name + ((e.qty > 0) ? " ${e.qty} ${e.unit}" : ""),
                                      style: kPoppinsRegular400.copyWith(fontSize: 12),
                                    ),
                                    Text(
                                      "Rp ${helper.formatter.format(e.price).replaceAll(",", ".")}",
                                      style: kPoppinsMedium500.copyWith(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[300],
                    margin: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 14),
                      ),
                      Text(
                        "Rp ${helper.formatter.format(totalHarga).replaceAll(',', '.')}",
                        style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 14),
                      ),
                    ],
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[300],
                    margin: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  CustomFlatButton(
                    width: MediaQuery.of(context).size.width,
                    text: "Memo Altea",
                    onPressed: () {
                      if (listObatDemo.where((ob) => ob.isSelected).isEmpty) {
                      } else {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                    color: listObatDemo.where((ob) => ob.isSelected).isEmpty ? Colors.black12 : kButtonColor,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            FooterMobileWebView(screenWidth: MediaQuery.of(context).size.width),
          ],
        ),
      ),
    );
  }
}
