import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/choose_payment/controllers/choose_payment_controller.dart';
import 'package:altea/app/modules/payment-guide/controllers/payment_guide_controller.dart';
import 'package:clipboard/clipboard.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/payment-guide/controllers/payment_guide_controller.dart';

extension on Duration {
  String format() => '$this'.split('.')[0].padLeft(8, '0');
}

class WaitingPaymentConsultationTab extends StatefulWidget {
  Map<String, dynamic> data;
  WaitingPaymentConsultationTab({required this.data});

  @override
  _WaitingPaymentConsultationTabState createState() => _WaitingPaymentConsultationTabState();
}

class _WaitingPaymentConsultationTabState extends State<WaitingPaymentConsultationTab> {
  CountdownController countdownController = CountdownController();
  PaymentGuideController controller = Get.put(PaymentGuideController());
  ChoosePaymentController paymentController = Get.put(ChoosePaymentController());
  final oCcy = NumberFormat("#,##0", "en_US");
  bool isExpanded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (widget.data['transaction'] == null) {
        paymentController.fromConsultationPayment.value = true;
        Get.toNamed('/choose-payment', arguments: widget.data['id']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('data => ${widget.data}');
    countdownController.start();
    return SingleChildScrollView(
      child: widget.data['transaction'] == null
          ? Container()
          : Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(boxShadow: [kBoxShadow], color: kBackground, borderRadius: BorderRadius.circular(24)),
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'Batas Akhir Pembayaran',
                          style: kPoppinsMedium500.copyWith(color: kBlackColor.withOpacity(0.7), fontSize: 10),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          DateFormat('EEEE, dd MMM yyyy, HH:mm')
                              .format(DateTime.parse(DateTime.parse(widget.data['transaction']['expiredAt'].toString()).toIso8601String())),
                          style: kPoppinsSemibold600.copyWith(fontSize: 13, color: kBlackColor),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Countdown(
                          seconds: DateTime.parse(DateTime.parse(widget.data['transaction']['expiredAt'].toString()).toIso8601String())
                              .difference(DateTime.parse(DateTime.now().toIso8601String()))
                              .inSeconds,
                          controller: countdownController,
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
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(boxShadow: [kBoxShadow], color: kBackground, borderRadius: BorderRadius.circular(24)),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ExtendedImage.network(
                            widget.data['transaction']['detail']['icon'].toString(),
                            width: MediaQuery.of(context).size.width / 6,
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.data['transaction']['detail']['name'].toString(),
                                style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 14),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Text(
                                  widget.data['transaction']['detail']['description'].toString(),
                                  style: kPoppinsRegular400.copyWith(
                                    fontSize: 10,
                                    color: kBlackColor.withOpacity(0.4),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          InkWell(
                            child: Text(
                              'Ganti',
                              style: kButtonTextStyle2,
                            ),
                            onTap: () {
                              Get.toNamed('/choose-payment', arguments: widget.data['id']);
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      if (widget.data['transaction']['detail']['code'] == 'bca_va')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nomor Virtual Account',
                              style: kPoppinsMedium500.copyWith(fontSize: 9, color: kBlackColor.withOpacity(0.8)),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.data['transaction']['va_number'].toString(),
                                  style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 12),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await FlutterClipboard.copy(widget.data['transaction']['va_number'].toString());
                                  },
                                  child: Text(
                                    'Salin',
                                    style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 11),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' Lakukan Pembayaran',
                              style: kPoppinsMedium500.copyWith(fontSize: 9, color: kBlackColor.withOpacity(0.8)),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            CustomFlatButton(
                                width: MediaQuery.of(context).size.width * 0.3,
                                text: 'Bayar',
                                onPressed: () async {
                                  // print('transaction => ${widget.data['transaction']['redirect_url']}');
                                  // if (await canLaunch(widget.data['transaction']
                                  //         ['redirect_url']
                                  //     .toString())) {
                                  //   await launch(widget.data['transaction']
                                  //           ['redirect_url']
                                  //       .toString());
                                  //   setState(() {});
                                  // } else {
                                  //   print('GA BISA LAUNCH!');
                                  // }
                                  String url = widget.data['transaction']['redirect_url'].toString();
                                  await Get.to(() => SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                        child: WebView(
                                          initialUrl: url,
                                          javascriptMode: JavascriptMode.unrestricted,
                                        ),
                                      ));
                                  setState(() {});
                                },
                                color: kButtonColor)
                          ],
                        ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Total Pembayaran',
                        style: kPoppinsMedium500.copyWith(fontSize: 9, color: kBlackColor.withOpacity(0.8)),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rp. ${oCcy.format(widget.data['total_price'])}',
                            style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 12),
                          ),
                          InkWell(
                            onTap: () async {
                              await FlutterClipboard.copy(widget.data['total_price'].toString());
                            },
                            child: Text(
                              'Salin Jumlah',
                              style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 11),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      // SizedBox(
                      //   height: 4,
                      // ),
                      if (isExpanded)
                        Container(
                          child: Column(
                            children: [
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: (widget.data['fees'] as List).length,
                                itemBuilder: (context, idx) {
                                  Map<String, dynamic> fee = (widget.data['fees'] as List)[idx] as Map<String, dynamic>;
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          fee['label'].toString(),
                                          style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.6)),
                                        ),
                                        Text(
                                          'Rp. ${oCcy.format(fee['amount'])}',
                                          style: kPoppinsMedium500.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.8)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: kPoppinsSemibold600.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.6)),
                                  ),
                                  Text(
                                    'Rp. ${oCcy.format(widget.data['total_price'])}',
                                    style: kPoppinsSemibold600.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.8)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              )
                            ],
                          ),
                        )
                      else
                        Container(),
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                        color: kBlackColor.withOpacity(0.3),
                        height: 1,
                      ),

                      SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Detail Pembayaran',
                              style: kPoppinsMedium500.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.5)),
                            ),
                            isExpanded
                                ? Icon(
                                    Icons.keyboard_arrow_up,
                                    size: 15,
                                  )
                                : Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 15,
                                  )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(boxShadow: [kBoxShadow], color: kBackground, borderRadius: BorderRadius.circular(24)),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Panduan Pembayaran',
                        style: kPoppinsMedium500.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.5)),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      FutureBuilder(
                        future: controller.getPaymentGuide(),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            List data = (snap.data! as Map<String, dynamic>)['data'] as List;
                            return Container(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (context, idx) {
                                  return ExpandedRow(data: data[idx] as Map<String, dynamic>);
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
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                )
              ],
            ),
    );
  }
}

class ExpandedRow extends StatefulWidget {
  Map<String, dynamic> data;
  ExpandedRow({required this.data});
  @override
  _ExpandedRowState createState() => _ExpandedRowState();
}

class _ExpandedRowState extends State<ExpandedRow> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.data['title'].toString(),
              style: kPoppinsSemibold600.copyWith(fontSize: 12, color: kDarkBlue),
            ),
            IconButton(
                icon: Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                onPressed: () => setState(() => isExpanded = !isExpanded))
          ],
        ),
        if (isExpanded)
          Container(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: HtmlWidget(
                widget.data['text'].toString(),
                textStyle: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.5)),
              ),
            ),
          )
        else
          Container()
      ],
    );
  }
}
