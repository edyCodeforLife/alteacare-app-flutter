// Flutter imports:
import 'package:altea/app/modules/register/presentation/modules/register/views/custom_simple_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/choose_payment/controllers/choose_payment_controller.dart';
import 'package:altea/app/modules/payment-guide/controllers/payment_guide_controller.dart';
import 'package:altea/app/core/utils/helper.dart' as helper;

class MobileAppView extends StatefulWidget {
  @override
  _MobileAppViewState createState() => _MobileAppViewState();
}

class _MobileAppViewState extends State<MobileAppView> {
  ChoosePaymentController controller = Get.find<ChoosePaymentController>();
  int selectedIdx = -1;
  String selectedPayment = '';
  int orderId = 0;

  final oCcy = NumberFormat("#,##0", "en_US");

  PaymentGuideController _paymentGuideController = Get.put(PaymentGuideController());
  //
  // List<Map<String, dynamic>> payments = [
  //   {
  //     "title": "Kartu Kredit",
  //     "data": [
  //       {
  //         "id": 0,
  //         "name": "Visa",
  //         "text": "Cicilan tersedia sampai 12 bulan",
  //         "img": "assets/group.png"
  //       },
  //       {
  //         "id": 1,
  //         "name": "Master Card",
  //         "text": "Cicilan tersedia sampai 12 bulan",
  //         "img": "assets/group-copy-2.png"
  //       },
  //       {
  //         "id": 2,
  //         "name": "Discover",
  //         "text": "Cicilan tersedia sampai 12 bulan",
  //         "img": "assets/group-copy-3.png"
  //       },
  //     ]
  //   },
  //   {
  //     "title": "Virtual Account",
  //     "data": [
  //       {
  //         "id": 3,
  //         "name": "BCA",
  //         "text":
  //             "Biaya Transaksi akan dikenakan Rp.1000 untuk setiap Transaksi",
  //         "img": "assets/group-copy-4.png"
  //       },
  //     ]
  //   },
  //   {
  //     "title": "E-Wallet",
  //     "data": [
  //       {
  //         "id": 4,
  //         "name": "OVO",
  //         "text":
  //             "Biaya Transaksi akan dikenakan Rp.1000 untuk setiap Transaksi",
  //         "img": "assets/group-copy-5.png"
  //       },
  //       {
  //         "id": 5,
  //         "name": "Gopay",
  //         "text":
  //             "Biaya Transaksi akan dikenakan Rp.1000 untuk setiap Transaksi",
  //         "img": "assets/group-copy-6.png"
  //       },
  //     ]
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context)!.settings.arguments.toString();
    // print('id => $id');
    return WillPopScope(
      onWillPop: () async {
        if (controller.fromConsultationDetail.value) {
          controller.fromConsultationDetail.value = false;
          Navigator.of(context).popUntil((route) => route.isFirst);
          Get.toNamed('/home');

          // Get.back();
          // Get.back();
          // Get.back();
          // Get.back();
        } else if (controller.fromConsultationPayment.value) {
          controller.fromConsultationPayment.value = false;
          Navigator.of(context).popUntil((route) => route.isFirst);
          Get.toNamed('/home');

          // Get.back();
          // Get.back();
        } else {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Get.toNamed('/home');

          // Get.back();
          // Get.back();
          // Get.back();
          // Get.back();
          // Get.back();
          // Get.back();
          // Get.back();
        }

        return false;
      },
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          title: Text(
            'Payment',
            style: kAppBarTitleStyle,
          ),
          centerTitle: true,
          backgroundColor: kBackground,
          leading: IconButton(
            onPressed: () {
              if (controller.fromConsultationDetail.value) {
                controller.fromConsultationDetail.value = false;
                Navigator.of(context).popUntil((route) => route.isFirst);
                Get.toNamed('/home');
                // Get.back();
                // Get.back();
                // Get.back();
                // Get.back();
              } else if (controller.fromConsultationPayment.value) {
                controller.fromConsultationPayment.value = false;
                Navigator.of(context).popUntil((route) => route.isFirst);
                Get.toNamed('/home');

                // Get.back();
                // Get.back();
              } else {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Get.toNamed('/home');

                // Get.back();
                // Get.back();
                // Get.back();
                // Get.back();
                // Get.back();
                // Get.back();
                // Get.back();
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: kBlackColor,
            ),
          ),
        ),
        body: FutureBuilder(
            future: controller.getDetailAppointment(id, false),
            builder: (context, snapshot) {
              Map<String, dynamic> snap;

              if (snapshot.hasData) {
                // print('snapshot data =>${snapshot.data}');
                snap = (snapshot.data! as Map<String, dynamic>)['data'] as Map<String, dynamic>;
                orderId = snap['id'] as int;

                // print('price => ${snap['total_price']}');

                return Stack(
                  children: [
                    SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Text(
                                'Order ID : ',
                                style: kPoppinsRegular400.copyWith(color: kBlackColor.withOpacity(0.4), fontSize: 12),
                              ),
                              Text(
                                snap['id'].toString(),
                                style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 12),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 2,
                          color: kLightGray.withOpacity(0.33),
                          width: double.infinity,
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 5,
                                height: MediaQuery.of(context).size.width / 5,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: ExtendedImage.network(
                                    snap['doctor']['photo'] == null ? ' ' : snap['doctor']['photo']['formats']['thumbnail'].toString(),
                                    fit: BoxFit.fill,
                                    cache: true,
                                    borderRadius: BorderRadius.circular(24),
                                    loadStateChanged: (ExtendedImageState state) {
                                      if (state.extendedImageLoadState == LoadState.failed) {
                                        return Icon(
                                          Icons.image_not_supported_rounded,
                                          color: kLightGray,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dr. ${snap['doctor']['name']}',
                                      style: kPoppinsSemibold600.copyWith(fontSize: 14, color: kBlackColor),
                                    ),
                                    // SizedBox(
                                    //   height: 4,
                                    // ),
                                    Text(
                                      'Sp. ${snap['doctor']['specialist']['name']}',
                                      style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.date_range,
                                          color: kButtonColor,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          helper.getDateWithMonthAbv(
                                            snap['schedule']['date'].toString(),
                                          ),
                                          style: kPoppinsRegular400.copyWith(fontSize: 12, color: kBlackColor),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Icon(
                                          Icons.access_time,
                                          color: kButtonColor,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          '${snap['schedule']['time_start']} - ${snap['schedule']['time_end']}',
                                          style: kPoppinsRegular400.copyWith(fontSize: 12, color: kBlackColor),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 2,
                          color: kLightGray.withOpacity(0.33),
                          width: double.infinity,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 16, left: 16, bottom: 8),
                          child: Text(
                            'Pilih Metode Pembayaran',
                            style: kPoppinsSemibold600.copyWith(fontSize: 12, color: kBlackColor),
                          ),
                        ),
                        FutureBuilder(
                            future: controller.getPaymentTypes(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                Map<String, dynamic> map = snapshot.data! as Map<String, dynamic>;

                                List types = map['data'] as List;
                                // if (snap['total_price'] == 0) {
                                //   types = (map['data'] as List).sublist(2);
                                // } else {
                                //   types = (map['data'] as List).sublist(0, 2);
                                // }
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: types.length,
                                    itemBuilder: (context, idx) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(vertical: 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              types[idx]['type'].toString(),
                                              style: kPoppinsMedium500.copyWith(color: kBlackColor.withOpacity(0.7), fontSize: 12),
                                            ),
                                            ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: (types[idx]['payment_methods'] as List).length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedPayment = types[idx]['payment_methods'][index]['code'].toString();
                                                    });
                                                    if (selectedPayment == 'bca_va') {
                                                      _paymentGuideController.selectedPaymentMethod.value =
                                                          types[idx]['payment_methods'][index] as Map<String, dynamic>;
                                                    } else {
                                                      _paymentGuideController.selectedPaymentMethod.value = Map<String, dynamic>();
                                                    }

                                                    // print('selected payment $selectedPayment');
                                                    // print('payment guide ${_paymentGuideController.selectedPaymentMethod.value}');
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(24),
                                                    margin: EdgeInsets.symmetric(vertical: 4),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: types[idx]['payment_methods'][index]['code'] == selectedPayment
                                                                ? kDarkBlue
                                                                : kBackground),
                                                        color: types[idx]['payment_methods'][index]['code'] == selectedPayment
                                                            ? kLightBlue
                                                            : kBackground,
                                                        borderRadius: BorderRadius.circular(16),
                                                        boxShadow: [kBoxShadow]),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(context).size.width / 6,
                                                          child: Image.network(types[idx]['payment_methods'][index]['icon'].toString()),
                                                        ),
                                                        SizedBox(
                                                          width: 24,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              types[idx]['payment_methods'][index]['name'].toString(),
                                                              style: kPoppinsSemibold600.copyWith(fontSize: 13, color: kBlackColor),
                                                            ),
                                                            SizedBox(
                                                              height: 8,
                                                            ),
                                                            Container(
                                                                width: MediaQuery.of(context).size.width * 0.5,
                                                                child: Text(
                                                                  types[idx]['payment_methods'][index]['description'].toString(),
                                                                  style:
                                                                      kPoppinsRegular400.copyWith(color: kBlackColor.withOpacity(0.4), fontSize: 11),
                                                                ))
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return Container(
                                  child: Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                );
                              }
                            }),
                        Container(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                        )
                      ],
                    )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 15),
                          // height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                              color: kBackground, boxShadow: [kBoxShadow], borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                                decoration: BoxDecoration(
                                    color: kPaleGreen.withOpacity(0.1),
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8))),
                                child: Container(
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/Bitmap@1x.png',
                                        width: MediaQuery.of(context).size.width * 0.05,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Gunakan Voucher',
                                        style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Biaya Total:',
                                          style: kPoppinsMedium500.copyWith(fontSize: 11, color: kBlackColor),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Rp. ${NumberFormat('#,##0', 'en_US').format(snap['total_price']).replaceAll(',', '.')}',
                                              style: kPoppinsSemibold600.copyWith(fontSize: 17, color: kDarkBlue),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            InkWell(
                                                child: Icon(
                                                  Icons.keyboard_arrow_up,
                                                  size: 20,
                                                ),
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) => Container(
                                                            height: MediaQuery.of(context).size.height * 0.45,
                                                            color: Color(0XFF757575),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius:
                                                                      BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets.all(16),
                                                                    width: MediaQuery.of(context).size.width * 0.3,
                                                                    height: 5,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      color: Colors.grey,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.all(16),
                                                                    width: double.infinity,
                                                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                      SizedBox(
                                                                        height: 30,
                                                                      ),
                                                                      Text(
                                                                        'Biaya Total',
                                                                        style: kPoppinsSemibold600.copyWith(fontSize: 19, color: kBlackColor),
                                                                      ),
                                                                      SizedBox(
                                                                        height: 24,
                                                                      ),
                                                                      ListView.builder(
                                                                          shrinkWrap: true,
                                                                          itemCount: (snap['fees'] as List).length,
                                                                          itemBuilder: (context, i) {
                                                                            return Container(
                                                                              margin: EdgeInsets.symmetric(vertical: 8),
                                                                              width: double.infinity,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    '${snap['fees'][i]['label']}:',
                                                                                    style: kPoppinsRegular400.copyWith(
                                                                                        fontSize: 13, color: kBlackColor.withOpacity(0.6)),
                                                                                  ),
                                                                                  Text(
                                                                                    'Rp.${oCcy.format(snap['fees'][i]['amount']).replaceAll(',', '.')}',
                                                                                    style:
                                                                                        kPoppinsMedium500.copyWith(fontSize: 15, color: kBlackColor),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            );
                                                                          }),
                                                                      SizedBox(
                                                                        height: 10,
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.symmetric(vertical: 8),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text('Total',
                                                                                style:
                                                                                    kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 14)),
                                                                            Text(
                                                                              'Rp. ${oCcy.format(snap['total_price']).replaceAll(',', '.')}',
                                                                              style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 20),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ]),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ));
                                                })
                                          ],
                                        )
                                      ],
                                    ),
                                    CustomFlatButton(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        text: 'Bayar',
                                        onPressed: () async {
                                          // print('selPayment => $selectedPayment');
                                          if (selectedPayment != '') {
                                            // Get.dialog(
                                            //   WillPopScope(
                                            //     child: CustomSimpleDualButtonDialog(
                                            //       icon: SizedBox(),
                                            //       onPressed1: () {
                                            //         Get.back();
                                            //       },
                                            //       onPressed2: () async {
                                            //         Get.back();
                                            //         Future.delayed(const Duration(milliseconds: 100), () async {
                                            //           if (GetPlatform.isAndroid) {
                                            //             if (await canLaunch("https://play.google.com/store/apps/details?id=com.dre.loyalty")) {
                                            //               launch("https://play.google.com/store/apps/details?id=com.dre.loyalty");
                                            //             }
                                            //           }
                                            //         });
                                            //       },
                                            //       title: 'Untuk kebutuhan internal testing',
                                            //       subtitle: "Transaksi tidak dapat dilakukan harap gunakan Alteacare App",
                                            //       buttonTxt1: 'Saya Mengerti',
                                            //       buttonTxt2: 'Download AlteaCare App',
                                            //     ),
                                            //     onWillPop: () async {
                                            //       return false;
                                            //     },
                                            //   ),
                                            //   barrierDismissible: false,
                                            // );

                                            var res = await controller.createPaymentNonModel(orderId, selectedPayment);

                                            if (res['status'] == true) {
                                              // print('success ${res['data']}');
                                              Get.toNamed('/success-payment-page', arguments: {"data": res['data'], "orderId": orderId});

                                              // await canLaunch(res['data']
                                              //         ['payment_url'] as String)
                                              //     ? launch(res['data']
                                              //             ['payment_url']
                                              //         .toString())
                                              //     : print('cant launch');
                                            } else {
                                              print('gagal ${res['message']}');

                                              Get.dialog(
                                                CustomSimpleDialog(
                                                  icon: const SizedBox(),
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  title: 'Pembayaran Gagal',
                                                  buttonTxt: 'Saya Mengerti',
                                                  subtitle: res['message'] ?? '',
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        color: selectedPayment == '' ? kLightGray : kButtonColor)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
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
