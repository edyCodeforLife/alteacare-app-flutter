import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/choose_payment/controllers/choose_payment_controller.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MobileAppView extends StatelessWidget {
  SpesialisKonsultasiController konsultasiController = Get.find<SpesialisKonsultasiController>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed("/home");
        return false;
      },
      child: Scaffold(
        backgroundColor: kBackground,
        body: FutureBuilder(
            future: Get.put(ChoosePaymentController()).getDetailAppointment(konsultasiController.appointmentId.value, false),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // print('snapshot data => ${snapshot.data}');
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox(
                            width: 90,
                            height: 90,
                            child: Image.asset(
                              "assets/vidcall_icon.png",
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Column(
                      children: [
                        Text(
                          "Panggilan Berakhir:",
                          style: kPoppinsRegular400.copyWith(color: kTextHintColor, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          ModalRoute.of(context)!.settings.arguments.toString(),
                          style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 25),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: Text(
                        (snapshot.data as Map)['data']['status'] == 'NEW'
                            ? "Konfirmasi rencana telekonsultasi Anda telah berakhir\nAkan tetapi data anda belum di approve oleh MA,\nHarap menghubungi MA kembali"
                            : "Konfirmasi rencana telekonsultasi Anda telah selesai.\nDimohon untuk menyelesaikan pembayaran Anda\n paling lambat 1 jam sebelum konsultasi dimulai",
                        style: kPoppinsRegular400.copyWith(fontSize: 11, color: kTextHintColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: Text(
                        "Transaksi tidak dapat dilakukan harap gunakan Alteacare App",
                        style: kPoppinsRegular400.copyWith(fontSize: 13, color: kTextHintColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 58,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: CustomFlatButton(
                          width: MediaQuery.of(context).size.width,
                          text: "Download Altea Care",
                          onPressed: () async {

                            if (GetPlatform.isAndroid) {
                              if (await canLaunch("https://play.google.com/store/apps/details?id=com.dre.loyalty")) {
                            launch("https://play.google.com/store/apps/details?id=com.dre.loyalty");
                            }
                          }
                          },
                          color: kButtonColor),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: CustomFlatButton(
                          width: MediaQuery.of(context).size.width,
                          text: (snapshot.data as Map)['data']['status'] == 'NEW' ? "Kembali ke Beranda" : "Pembayaran",
                          onPressed: () {
                            (snapshot.data as Map)['data']['status'] == 'NEW'
                                ? Get.offNamed('/home')
                                : Get.toNamed('/choose-payment', arguments: konsultasiController.appointmentId.value);
                          },
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            }),
      ),
    );
  }
}
