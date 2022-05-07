// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import 'package:altea/app/modules/payment-guide/controllers/payment_guide_controller.dart';

class MobileWebPaymentGuidePage extends GetView<PaymentGuideController> {
  const MobileWebPaymentGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kBackground,
      appBar: MobileWebMainAppbar(
        scaffoldKey: scaffoldKey,
      ),
      drawer: MobileWebHamburgerMenu(),
      body: Stack(
        children: [
          ListView(
            children: [
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(TextSpan(children: [
                      TextSpan(text: "Order ID: ", style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 10)),
                      TextSpan(text: "66870080", style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 10))
                    ])),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.yellow.withOpacity(
                          0.1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Menunggu Pembayaran",
                          style: kPoppinsSemibold600.copyWith(fontSize: 10, color: Colors.yellow),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Divider(
                height: 1,
                color: kLightGray,
              ),
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  children: [
                    SizedBox(
                        height: 74,
                        width: 74,
                        child: Container(
                          color: kGreenColor,
                        )
                        // Image.network(data["doctor"]["photo"]["formats"]
                        //         ["thumbnail"]
                        //     .toString()),
                        ),
                    const SizedBox(
                      width: 14,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // data["doctor"]["name"].toString(),
                          "Dr. Vinda Octavio",
                          style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 14),
                        ),
                        Text(
                          // data["doctor"]["specialist"]["name"].toString(),
                          "Sp. Anak - Endokrinologi",
                          style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 10),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 14,
                              width: 14,
                              child: Image.asset("calendar_icon.png", color: kLightGray),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              // DateFormat("EEEE, dd/MM/yyyy", "id").format(
                              //     DateTime.parse(
                              //         data["schedule"]["date"].toString())),
                              "Monday, 22/03/2021",
                              style: kPoppinsRegular400.copyWith(color: kBlackColor, fontSize: 10),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              height: 14,
                              width: 14,
                              child: Image.asset(
                                "time_icon.png",
                                color: kLightGray,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              // "${data["schedule"]["time_start"]} - ${data["schedule"]["time_end"]}",
                              "08.15 - 08.30",
                              style: kPoppinsRegular400.copyWith(color: kBlackColor, fontSize: 10),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Divider(
                height: 1,
                color: kLightGray,
              ),
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: kBackground,
                    boxShadow: [BoxShadow(blurRadius: 12, offset: Offset(0, 3), color: kLightGray)],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Batas Akhir Pembayaran:",
                        style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 10),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Rabu, 12 Des 2020 ",
                            style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 13),
                          ),
                          Text(
                            "08:08",
                            style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "00:08:03",
                        style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 22),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: kBackground,
                    boxShadow: [BoxShadow(blurRadius: 12, offset: Offset(0, 3), color: kLightGray)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: SizedBox(
                                height: 47,
                                width: 47,
                                child: Container(
                                  color: kLightBlue,
                                ),
                              )),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "BCA Virtual Account",
                                  style: kPoppinsSemibold600.copyWith(color: kBlackColor, fontSize: 13),
                                ),
                                Text(
                                  "Biaya Transaksi akan dikenakan Rp. 1.000 untuk semuanya",
                                  style: kPoppinsRegular400.copyWith(color: kBlackColor, fontSize: 10),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Nomor Virtual Account",
                        style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 10),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "8077081234567890",
                            style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 12),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                "Salin",
                                style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 11),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Text(
                        "Nomor Virtual Account",
                        style: kPoppinsMedium500.copyWith(color: kLightGray, fontSize: 10),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "8077081234567890",
                            style: kPoppinsSemibold600.copyWith(color: kDarkBlue, fontSize: 12),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                "Salin Jumlah",
                                style: kPoppinsSemibold600.copyWith(color: kButtonColor, fontSize: 11),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Divider(
                        color: kLightGray,
                        height: 2,
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Detail Pembayaran",
                            style: kPoppinsSemibold600.copyWith(color: kTextHintColor, fontSize: 10),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 14,
                            color: kTextHintColor,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: kBackground,
                    boxShadow: [BoxShadow(blurRadius: 12, offset: Offset(0, 3), color: kLightGray)],
                  ),
                  child: buildExpansionTile({}),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 78,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: kBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: CustomFlatButton(width: screenWidth, text: "Batalkan Konsultasi", onPressed: () {}, color: kButtonColor),
            ),
          )
        ],
      ),
    );
  }

  Widget buildExpansionTile(Map<String, dynamic> data) {
    final controller = Get.find<PaymentGuideController>();

    return Container(
      child: ExpansionTile(
        key: controller.keyTile,
        initiallyExpanded: controller.isExpanded.value,
        title: Text(
          data["title"].toString(),
          style: kPoppinsSemibold600.copyWith(fontSize: 12, color: kDarkBlue),
        ),
        children: [
          Text(
            data["text"].toString(),
            style: kPoppinsRegular400.copyWith(fontSize: 10, color: kLightGray),
          ),
        ],
      ),
    );
  }
}
