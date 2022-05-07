import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileAppPharmacyInformationPage extends StatelessWidget {
  const MobileAppPharmacyInformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();
    List<String> instruction = [
      "1.   Anda akan dihubungi oleh petugas farmasi Rumah Sakit dalam 30menit",
      "2.   Konfirmasi pembelian obat & alamat pengiriman obat",
      "3.   Pembayaran ",
      "4.   Pengiriman obat ke lokasi tujuan",
      "5.   Obat sampai di tujuan "
    ];

    List<String> img = [
      'assets/info_obat_01.png',
      'assets/info_obat_02.png',
      'assets/info_obat_03.png',
      'assets/info_obat_04.png',
      'assets/info_obat_05.png',
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Informasi Pemesanan Obat',
          style: kAppBarTitleStyle,
        ),
        centerTitle: true,
        backgroundColor: kBackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kBlackColor,
          ),
          onPressed: () {
            homeController.currentIdx.value = 2;
            Get.offNamed('/home');
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          homeController.currentIdx.value = 2;
          Get.offNamed('/home');
          return false;
        },
        child: Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: instruction.length,
                itemBuilder: (context, idx) {
                  return Container(
                    margin: EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage(img[idx]), fit: BoxFit.contain),
                              color: kButtonColor,
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Container(
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
              CustomFlatButton(
                  width: double.infinity,
                  text: 'Saya Mengerti',
                  onPressed: () {
                    homeController.currentIdx.value = 2;
                    Get.offNamed('/home');
                  },
                  color: kButtonColor)
            ],
          ),
        ),
      ),
    );
  }
}
