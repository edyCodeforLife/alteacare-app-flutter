import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/utils/use_shared_pref.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/choose_payment/controllers/choose_payment_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:webview_flutter/webview_flutter.dart';

extension on Duration {
  String format() => '$this'.split('.')[0].padLeft(8, '0');
}

class MobileAppView extends StatefulWidget {
  @override
  _MobileAppViewState createState() => _MobileAppViewState();
}

class _MobileAppViewState extends State<MobileAppView> {
  List<Map<String, dynamic>> fees = [
    {"name": "Konsultasi Dokter", "price": "Rp.150.000"},
    {"name": "Biaya Layanan", "price": "Rp.15.000"}
  ];

  CountdownController countdownCtrl = CountdownController();
  ChoosePaymentController controller = Get.find<ChoosePaymentController>();
  HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    countdownCtrl.start();
    var args = ModalRoute.of(context)!.settings.arguments;
    final oCcy = NumberFormat("#,##0", "en_US");
    // print(' args => $args');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kBlackColor),
          onPressed: () => Get.back(),
        ),
        backgroundColor: kBackground,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: controller.getDetailAppointment((args as Map<String, dynamic>)['orderId'].toString(), false),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // print('data =>${snapshot.data}');
                return Container(
                  margin: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [kBoxShadow],
                    color: kBackground,
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset('assets/success_icon.png', width: MediaQuery.of(context).size.width / 4),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Silahkan Melakukan Pembayaran',
                        style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 14),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Order ID:',
                            style: kPoppinsRegular400.copyWith(fontSize: 13, color: kBlackColor.withOpacity(0.4)),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            (args as Map<String, dynamic>)['orderId'].toString(),
                            style: kPoppinsSemibold600.copyWith(fontSize: 13, color: kBlackColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      DotWidget(
                        dashColor: kBlackColor.withOpacity(0.4),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Batas Akhir Pembayaran',
                        style: kPoppinsMedium500.copyWith(color: kBlackColor.withOpacity(0.7), fontSize: 10),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        DateFormat('EEEE, dd MMM yyyy, HH:mm')
                            .format(DateTime.parse(DateTime.parse(args['data']['expiredAt'].toString()).toIso8601String())),
                        style: kPoppinsSemibold600.copyWith(fontSize: 13, color: kBlackColor),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Countdown(
                        seconds: DateTime.parse(DateTime.parse(args['data']['expiredAt'].toString()).toIso8601String())
                            .difference(DateTime.parse(DateTime.now().toIso8601String()))
                            .inSeconds,
                        controller: countdownCtrl,
                        interval: Duration(seconds: 1),
                        build: (context, time) {
                          // DateTime now = DateTime.now().toUtc();
                          // DateTime end =
                          //     DateTime.parse(args['data']['expiredAt'].toString());
                          //
                          // print('datetime end => ${args['data']['expiredAt']}');
                          // Duration duration = now.difference(end);
                          // print('duration => ${duration}');

                          return Text(
                            Duration(seconds: time.toInt()).format(),
                            style: kPoppinsSemibold600.copyWith(fontSize: 22, color: kDarkBlue),
                          );
                        },
                        onFinished: () {
                          // print('countdown done!');
                          // setState(() => countdownDone = true);
                        },
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Metode Pembayaran',
                            style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
                          ),
                          Image.network(
                            addCDNforLoadImage((snapshot.data as Map<String, dynamic>)['data']['transaction']['detail']['icon'].toString()),
                            width: MediaQuery.of(context).size.width * 0.2,
                          )
                        ],
                      ),
                      if (args['data']['va_number'] != null)
                        Column(
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'No. Virtual Account',
                                  style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
                                ),
                                Text('${args['data']['va_number']}',
                                    style: kPoppinsMedium500.copyWith(fontSize: 12, color: kDarkBlue.withOpacity(0.8)))
                              ],
                            ),
                          ],
                        )
                      else
                        Container(),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: ((snapshot.data as Map<String, dynamic>)['data']['fees'] as List).length,
                        itemBuilder: (context, idx) {
                          Map<String, dynamic> fee = ((snapshot.data as Map<String, dynamic>)['data']['fees'] as List)[idx] as Map<String, dynamic>;
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  fee['label'].toString(),
                                  style: kPoppinsRegular400.copyWith(fontSize: 12, color: kBlackColor.withOpacity(0.6)),
                                ),
                                Text(
                                  'Rp. ${oCcy.format(fee['amount'])}',
                                  style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor.withOpacity(0.8)),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 1,
                        color: kBlackColor,
                        width: double.infinity,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: kPoppinsSemibold600.copyWith(fontSize: 14, color: kButtonColor),
                            ),
                            Text(
                              'Rp. ${oCcy.format((snapshot.data as Map<String, dynamic>)['data']['total_price'])}',
                              style: kPoppinsSemibold600.copyWith(fontSize: 18, color: kButtonColor),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomFlatButton(
                          width: double.infinity,
                          text: (snapshot.data as Map<String, dynamic>)['data']['transaction']['detail']['name'] == 'BCA - Virtual Account'
                              ? 'Panduan Pembayaran'
                              : 'Bayar',
                          onPressed: () async {
                            // print((snapshot.data as Map<String, dynamic>)['data']['transaction']['redirect_url'].toString());
                            if ((snapshot.data as Map<String, dynamic>)['data']['transaction']['detail']['name'] == 'Kartu Kredit') {
                              String url = (snapshot.data as Map<String, dynamic>)['data']['transaction']['redirect_url'].toString();

                              await Get.to(() => SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    child: WebView(
                                      initialUrl: url,
                                      javascriptMode: JavascriptMode.unrestricted,
                                    ),
                                  ));
                              Get.offNamed('/my-consultation-detail', arguments: (snapshot.data as Map<String, dynamic>)['data']['id']);

                              // if (await canLaunch((snapshot.data
                              //             as Map<String, dynamic>)['data']
                              //         ['transaction']['redirect_url']
                              //     .toString())) {
                              //   await launch((snapshot.data
                              //               as Map<String, dynamic>)['data']
                              //           ['transaction']['redirect_url']
                              //       .toString());
                              // } else {
                              //   print('GA BISA LAUNCH!');
                              // }
                            } else if ((snapshot.data as Map<String, dynamic>)['data']['transaction']['detail']['name'] ==
                                'Telekonsultasi Gratis dari AlteaCare') {
                              String token = await AppSharedPreferences.getAccessToken();
                              String url = (snapshot.data as Map<String, dynamic>)['data']['transaction']['payment_url']
                                  .toString()
                                  .replaceAll('{{REPLACE_THIS_TO_BEARER_USER}}', token);
                              // print('url => $url');
                              await Get.to(() => SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    child: WebView(
                                      initialUrl: url,
                                      javascriptMode: JavascriptMode.unrestricted,
                                    ),
                                  ));

                              Get.offAllNamed('/my-consultation-detail', arguments: (snapshot.data as Map<String, dynamic>)['data']['id']);
                            } else {
                              Get.offAllNamed('/my-consultation-detail', arguments: (snapshot.data as Map<String, dynamic>)['data']['id']);
                            }
                          },
                          color: kButtonColor),
                      CustomFlatButton(
                        width: double.infinity,
                        text: 'Beranda',
                        onPressed: () async {
                          homeController.currentIdx.value = 0;
                          Get.offNamed('/home');
                        },
                        color: kBackground,
                        borderColor: kButtonColor,
                      )
                    ],
                  ),
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

class DotWidget extends StatelessWidget {
  final double totalWidth, dashWidth, emptyWidth, dashHeight;

  final Color dashColor;

  const DotWidget({this.totalWidth = 300, this.dashWidth = 10, this.emptyWidth = 5, this.dashHeight = 1, this.dashColor = kBlackColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalWidth ~/ (dashWidth + emptyWidth),
        (_) => Container(
          width: dashWidth,
          height: dashHeight,
          color: dashColor,
          margin: EdgeInsets.only(left: emptyWidth / 2, right: emptyWidth / 2),
        ),
      ),
    );
  }
}
