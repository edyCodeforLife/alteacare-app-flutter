import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/choose_payment/controllers/choose_payment_controller.dart';
import 'package:altea/app/modules/payment-guide/controllers/payment_guide_controller.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

class MobileAppView extends StatefulWidget {
  @override
  _MobileAppViewState createState() => _MobileAppViewState();
}

class _MobileAppViewState extends State<MobileAppView> {
  PaymentGuideController controller = Get.find<PaymentGuideController>();
  ChoosePaymentController paymentController = Get.find<ChoosePaymentController>();
  @override
  Widget build(BuildContext context) {
    // print('sel => ${controller.selectedPaymentMethod.value}');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kBlackColor,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: kBackground,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(32),
                  child: Row(
                    children: [
                      ExtendedImage.network(
                        controller.selectedPaymentMethod.value['icon'].toString(),
                        width: MediaQuery.of(context).size.width / 6,
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.selectedPaymentMethod.value['name'].toString(),
                            style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 14),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              controller.selectedPaymentMethod.value['description'].toString(),
                              style: kPoppinsRegular400.copyWith(
                                fontSize: 10,
                                color: kBlackColor.withOpacity(0.4),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Panduan Pembayaran',
                    style: kPoppinsMedium500.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.6)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(24),
                  child: FutureBuilder(
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
                              return ExpandedWidget(data: data[idx] as Map<String, dynamic>, idx: idx);
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
                )
              ],
            ),
            Container(
                padding: EdgeInsets.all(16),
                child: CustomFlatButton(
                    width: double.infinity,
                    text: 'Konfirmasi',
                    onPressed: () async {
                      // print(' argsssssss => ${ModalRoute.of(context)!.settings.arguments}');
                      var res = await paymentController.createPaymentNonModel(ModalRoute.of(context)!.settings.arguments as int, 'bca_va');

                      if (res['status'] == true) {
                        // print('success ${res['data']}');
                        Get.toNamed('/success-payment-page', arguments: {"data": res['data'], "orderId": ModalRoute.of(context)!.settings.arguments});
                      }
                    },
                    color: kButtonColor))
          ],
        ),
      ),
    );
  }
}

class ExpandedWidget extends StatefulWidget {
  Map<String, dynamic> data;
  int idx;
  ExpandedWidget({required this.idx, required this.data});
  @override
  _ExpandedWidgetState createState() => _ExpandedWidgetState();
}

class _ExpandedWidgetState extends State<ExpandedWidget> {
  bool init = false;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // print('isExpanded ${widget.idx} => $isExpanded');
    if (!init) {
      if (widget.idx == 0) {
        isExpanded = true;
        init = true;
      }
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.data['title'].toString(),
                style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 12),
              ),
              IconButton(
                  icon: Icon(isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
                  onPressed: () {
                    setState(() => isExpanded = !isExpanded);
                  })
            ],
          ),
          isExpanded
              ? Container(
                  padding: EdgeInsets.all(16),
                  child: HtmlWidget(
                    widget.data['text'].toString(),
                    textStyle: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.6)),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
