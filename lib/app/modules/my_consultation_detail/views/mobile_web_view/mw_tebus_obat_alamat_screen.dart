// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/add_patient/controllers/add_patient_controller.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import 'package:altea/app/modules/my_consultation_detail/views/mobile_web_view/mw_tebus_obat_success_screen.dart';
import 'package:altea/app/modules/profile-edit-detail/controllers/profile_edit_detail_controller.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import '../../models/obat_demo_model.dart';

class MWTebusObatAlamatScreen extends StatefulWidget {
  final List<ObatDemo> listObatDemo;
  MWTebusObatAlamatScreen({required this.listObatDemo});

  @override
  _MWTebusObatAlamatScreenState createState() => _MWTebusObatAlamatScreenState();
}

class _MWTebusObatAlamatScreenState extends State<MWTebusObatAlamatScreen> {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedId = '';
  ProfileEditDetailController controller = Get.find<ProfileEditDetailController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: MobileWebMainAppbar(
        scaffoldKey: scaffoldKey,
      ),
      drawer: MobileWebHamburgerMenu(),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tebus Obat",
              style: kPoppinsSemibold600.copyWith(fontSize: 16),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'List Alamat Pengiriman',
                      style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor.withOpacity(0.5)),
                    ),
                    InkWell(
                      onTap: () async {
                        Get.put(AddPatientController());
                        Get.put(SpesialisKonsultasiController());
                        await Get.toNamed('/patient-address');
                        setState(() {});
                      },
                      child: Text(
                        'Tambah Alamat',
                        style: kPoppinsSemibold600.copyWith(fontSize: 11, color: kDarkBlue),
                      ),
                    )
                  ],
                )),
            Expanded(
                flex: 11,
                child: FutureBuilder(
                  future: controller.getAddresses(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // print('snapshot data => ${snapshot.data}');
                      List<dynamic> addressess = (snapshot.data as Map<String, dynamic>)['data']['address'] as List<dynamic>;
                      return ListView.builder(
                        itemCount: addressess.length,
                        itemBuilder: (context, idx) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedId = addressess[idx]['id'].toString();
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: kWhiteGray,
                                  border: Border.all(color: addressess[idx]['id'] == selectedId ? kDarkBlue : kWhiteGray, width: 2)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.65,
                                    child: Text(
                                      "Jl. ${addressess[idx]['street'] == null ? " " : addressess[idx]['street']!}, Blok RT/RW${addressess[idx]['rt_rw'] == null ? " " : addressess[idx]['rt_rw']!}, Kel. ${addressess[idx]['subdistrict'] == null ? " " : addressess[idx]['subdistrict']!.name}, Kec.${addressess[idx]['district'] == null ? "" : addressess[idx]['district']!['name']} ${addressess[idx]['city'] == null ? "" : addressess[idx]['city']!['name']} ${addressess[idx]['province'] == null ? " " : addressess[idx]['province']!['name']} ${addressess[idx]['subdistrict'] == null ? " " : addressess[idx]['subdistrict']!['postal_code']}",
                                      style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: kBlackColor,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: CupertinoActivityIndicator());
                    }
                  },
                )),
            Expanded(
              flex: 1,
              child: Container(
                // padding: EdgeInsets.symmetric(vertical: 12),
                child: CustomFlatButton(
                  width: double.infinity,
                  text: 'Pilih ALamat',
                  onPressed: () async {
                    if (selectedId.isEmpty) {
                    } else {
                      var res = await controller.updatePrimaryAddress(selectedId);
                      // print('hasil res => $res');
                      if (res['data'] as bool) {
                        Get.to(() => MWTebusObatSuccessScreen(listObatDemo: widget.listObatDemo));
                        // Get.back();
                      }
                    }
                    //
                  },
                  color: (selectedId.isEmpty) ? Colors.black12 : kButtonColor,
                ),
                // color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
