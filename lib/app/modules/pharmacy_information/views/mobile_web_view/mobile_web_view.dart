// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';

class MobileWebPharmacyInformationPage extends StatelessWidget {
  MobileWebPharmacyInformationPage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>(
    debugLabel: "drawer di home webview",
  );
  final List<String> instruction = [
    "1. Anda akan dihubungi oleh petugas farmasi Rumah Sakit dalam 30menit",
    "2. Konfirmasi pembelian obat & alamat pengiriman obat",
    "3. Pembayaran ",
    "4. Pengiriman obat ke lokasi tujuan",
    "5. Obat sampai di tujuan "
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: MobileWebHamburgerMenu(),
      appBar: MobileWebMainAppbar(
        scaffoldKey: scaffoldKey,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: instruction.length,
            itemBuilder: (context, idx) {
              return Container(
                margin: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.width * 0.15,
                      decoration: BoxDecoration(
                          color: kButtonColor,
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(image: AssetImage("assets/info_obat_0${idx + 1}.png"))),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        instruction[idx],
                        style: kPoppinsRegular400.copyWith(fontSize: 12, color: kBlackColor.withOpacity(0.6)),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: Container(),
          ),
          CustomFlatButton(width: double.infinity, text: 'Saya Mengerti', onPressed: () {}, color: kButtonColor)
        ],
      ),
    );
  }
}
