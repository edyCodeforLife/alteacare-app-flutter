// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/helper.dart' as helper;
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/my_consultation_detail/views/mobile_web_view/mw_tebus_obat_alamat_screen.dart';
import 'package:altea/app/modules/profile-edit-detail/controllers/profile_edit_detail_controller.dart';
import '../../../models/obat_demo_model.dart';

class MWKonsultasiListObatContainerDemo extends StatefulWidget {
  @override
  _MWKonsultasiListObatContainerDemoState createState() => _MWKonsultasiListObatContainerDemoState();
}

class _MWKonsultasiListObatContainerDemoState extends State<MWKonsultasiListObatContainerDemo> {
  num totalHarga = 0;

  List<ObatDemo> listObatDemo = [
    ObatDemo(
      id: "a",
      name: "Analsik",
      isSelected: true,
      price: 108000,
      qty: 500,
      unit: "mg",
    ),
    ObatDemo(
      id: "a",
      name: "Omeprazole",
      isSelected: true,
      price: 4500,
      qty: 20,
      unit: "mg",
    ),
    ObatDemo(
      id: "a",
      name: "Sucrafalt",
      isSelected: true,
      price: 25000,
      qty: 100,
      unit: "ml",
    ),
    ObatDemo(
      id: "a",
      name: "Becom-C",
      isSelected: false,
      price: 20000,
      qty: 0,
      unit: "0",
    ),
  ];

  @override
  void initState() {
    // totalHarga = listObatDemo.where((ob) => ob.isSelected).reduce((a, b) => a.price + b.price);
    for (ObatDemo o in listObatDemo.where((ob) => ob.isSelected)) {
      totalHarga += o.price;
    }
    super.initState();
  }

  void cekHarga() {
    totalHarga = 0;
    final List<ObatDemo> oooo = listObatDemo.where((ob) => ob.isSelected).toList();
    for (ObatDemo o in oooo) {
      totalHarga += o.price;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "List Obat",
            style: kPoppinsSemibold600.copyWith(color: fullBlack, fontSize: 13),
          ),
          ...listObatDemo
              .map((e) => Row(
                    children: [
                      Checkbox(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: kButtonColor,
                          value: e.isSelected,
                          onChanged: (b) {
                            setState(() {
                              e.isSelected = b!;
                            });
                            cekHarga();
                          }),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e.name + ((e.qty > 0) ? " ${e.qty} ${e.unit}" : "")),
                            Text("Rp ${helper.formatter.format(e.price).replaceAll(",", ".")}"),
                          ],
                        ),
                      ),
                    ],
                  ))
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomFlatButton(
                width: MediaQuery.of(context).size.width / 3 + 20,
                text: "Info Pemesanan",
                onPressed: () {
                  Navigator.pushNamed(context, "/pharmacy-information");
                },
                color: Colors.white,
                borderColor: kButtonColor,
              ),
              CustomFlatButton(
                width: MediaQuery.of(context).size.width / 3 + 20,
                text: "Tebus Obat",
                onPressed: () {
                  if (listObatDemo.where((ob) => ob.isSelected).isEmpty) {
                  } else {
                    Get.put(ProfileEditDetailController());
                    Get.to(() => MWTebusObatAlamatScreen(
                          listObatDemo: listObatDemo.where((ob) => ob.isSelected).toList(),
                        ));
                  }
                },
                color: listObatDemo.where((ob) => ob.isSelected).isEmpty ? Colors.black12 : kButtonColor,
              ),
            ],
          ),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
            margin: const EdgeInsets.symmetric(vertical: 15),
          ),
        ],
      ),
    );
  }
}
