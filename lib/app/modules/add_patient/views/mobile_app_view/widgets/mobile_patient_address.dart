import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/add_patient/controllers/add_patient_controller.dart';
import 'package:altea/app/modules/profile-edit-detail/controllers/profile_edit_detail_controller.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobilePatientAddress extends StatefulWidget {
  final void Function() nextPage;

  MobilePatientAddress({required this.nextPage});
  @override
  _MobilePatientAddressState createState() => _MobilePatientAddressState();
}

class _MobilePatientAddressState extends State<MobilePatientAddress> {
  String selectedId = '';
  ProfileEditDetailController controller = Get.put(ProfileEditDetailController());
  SpesialisKonsultasiController konsultasiController = Get.find<SpesialisKonsultasiController>();
  AddPatientController addController = Get.find<AddPatientController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.76,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.55,
            child: FutureBuilder(
              future: controller.getAddresses(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // print('snapshot data => ${snapshot.data}');
                  List<dynamic> addressess = snapshot.data == null
                      ? []
                      : (snapshot.data as Map<String, dynamic>)['data'] == null
                          ? []
                          : (snapshot.data as Map<String, dynamic>)['data']['address'] as List<dynamic>;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: addressess.length,
                    itemBuilder: (context, idx) {
                      bool isExpanded = false;
                      return AddressCard(
                          addresses: addressess[idx] as Map<String, dynamic>,
                          onTap: () {
                            setState(() {
                              selectedId = addressess[idx]['id'].toString();
                              konsultasiController.selectedAddress.value = addressess[idx]['id'].toString();
                              addController.selectedAddress.value = addressess[idx]['id'].toString();
                              addController.fullAddress.value =
                                  "Jl. ${addressess[idx]['street'] == null ? " " : addressess[idx]['street']!}, Blok RT/RW${addressess[idx]['rt_rw'] == null ? " " : addressess[idx]['rt_rw']!}, Kel. ${addressess[idx]['subdistrict'] == null ? " " : addressess[idx]['subdistrict']!.name}, Kec.${addressess[idx]['district'] == null ? "" : addressess[idx]['district']!['name']} ${addressess[idx]['city'] == null ? "" : addressess[idx]['city']!['name']} ${addressess[idx]['province'] == null ? " " : addressess[idx]['province']!['name']} ${addressess[idx]['subdistrict'] == null ? " " : addressess[idx]['subdistrict']!['postal_code']}";
                            });
                          },
                          border: Border.all(color: addressess[idx]['id'] == selectedId ? kDarkBlue : kWhiteGray, width: 2));
                    },
                  );
                } else {
                  return Center(child: CupertinoActivityIndicator());
                }
              },
            ),
          ),
          SizedBox(
            child: CustomFlatButton(
                height: MediaQuery.of(context).size.height * 0.07,
                width: double.infinity,
                text: 'Lanjutkan',
                onPressed: () {
                  if (selectedId != '') {
                    konsultasiController.selectedAddress.value = selectedId;
                    // print('address id => ${konsultasiController.selectedAddress.value}');
                    widget.nextPage();
                  }
                },
                color: selectedId == '' ? kLightGray : kButtonColor),
          ),
          Transform(
            transform: Matrix4.translationValues(0.0, -20.0, 0.0),
            child: CustomFlatButton(
              height: MediaQuery.of(context).size.height * 0.07,
              width: double.infinity,
              text: 'Tambah Alamat',
              onPressed: () async {
                await Get.toNamed('/patient-address');
                widget.nextPage();
              },
              color: kBackground,
              borderColor: kButtonColor,
            ),
          )
        ],
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final Map<String, dynamic> addresses;
  final void Function()? onTap;
  final Border border;
  AddressCard({required this.addresses, required this.onTap, required this.border});
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap!();
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: kWhiteGray, border: widget.border),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Text(
                "Jl. ${widget.addresses['street'] == null ? " " : widget.addresses['street']!}, RT/RW${widget.addresses['rt_rw'] == null ? " " : widget.addresses['rt_rw']!}, Kel. ${widget.addresses['subdistrict'] == null ? " " : widget.addresses['subdistrict']!.name}, Kec.${widget.addresses['district'] == null ? "" : widget.addresses['district']!['name']} ${widget.addresses['city'] == null ? "" : widget.addresses['city']!['name']} ${widget.addresses['province'] == null ? " " : widget.addresses['province']!['name']} ${widget.addresses['subdistrict'] == null ? " " : widget.addresses['subdistrict']!['postal_code']}",
                style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor),
                overflow: TextOverflow.ellipsis,
                maxLines: isExpanded ? 5 : 2,
              ),
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down_rounded,
              color: kBlackColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
