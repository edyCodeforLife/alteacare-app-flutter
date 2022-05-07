import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/data/model/patient_data_model.dart';
import 'package:altea/app/modules/add_patient/controllers/add_patient_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
import 'package:altea/app/modules/patient_data/views/widget/patient_data_card.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileAppView extends StatefulWidget {
  @override
  _MobileAppViewState createState() => _MobileAppViewState();
}

class _MobileAppViewState extends State<MobileAppView> {
  int selectedIdx = -2;
  bool isExpanded = false;

  PatientDataController controller = Get.find<PatientDataController>();
  SpesialisKonsultasiController konsultasiController = Get.find<SpesialisKonsultasiController>();
  final userController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: Text(
          'Data Pasien',
          style: kAppBarTitleStyle,
        ),
        centerTitle: true,
        backgroundColor: kBackground,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: kBlackColor,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // height: MediaQuery.of(context).size.height * 0.65,
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Pilih pasien yang akan melakukan konsultasi.',
                  style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.8)),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.43,
                  child: FutureBuilder<PatientData>(
                    future: controller.getPatientList(userController.accessTokens.value),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // print('ada snapshot data lhooo ${snapshot.data!.data}');
                        // print('snapshot dataa =>${snapshot.data!.data}');
                        List<Patient> patientData = snapshot.data!.data == null ? [] : snapshot.data!.data!.patient;
                        // print('masuk siniii ${patientData}');
                        return SizedBox(
                          height: patientData.length > 3 ? MediaQuery.of(context).size.height * 0.43 : null,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: patientData.length,
                            itemBuilder: (context, index) {
                              // print('idx => ${patientData[index].addressId} - ${patientData[index].firstName}');
                              return PatientDataCard(
                                idx: index,
                                onTap: () {
                                  konsultasiController.selectedPatientName.value = '${patientData[index].firstName} ${patientData[index].lastName}';
                                  konsultasiController.selectedUid.value = patientData[index].id!;
                                  // print("selectedUid => ${konsultasiController.selectedUid.value}");
                                  if (patientData[index].addressId != null && patientData[index].addressId != '') {
                                    // print('ini address id => ${patientData[index].addressId}');
                                    konsultasiController.selectedAddress.value = patientData[index].addressId!;
                                    konsultasiController.selectedPatientData.value = patientData[index];
                                  } else {
                                    konsultasiController.selectedAddress.value = '';
                                  }
                                  setState(() {
                                    selectedIdx = index;
                                  });
                                },
                                selected: selectedIdx,
                                patientData: patientData[index],
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
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 1,
                          color: kBlackColor.withOpacity(0.5),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          child: Text(
                            'Belum ada daftar keluarga ?',
                            style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor.withOpacity(0.7)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 1,
                          color: kBlackColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(boxShadow: [kBoxShadow], color: kBackground, borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 32),
                  child: InkWell(
                    onTap: () async {
                      await Get.toNamed('/add-patient');
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tambah Data Pasien',
                          style: kPoppinsMedium500.copyWith(color: kBlackColor.withOpacity(0.8), fontSize: 11),
                        ),
                        Icon(
                          Icons.add_circle,
                          color: kButtonColor,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(24),
            child: CustomFlatButton(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.06,
                text: 'Confirm',
                onPressed: () async {
                  // print(konsultasiController.selectedAddress.value == ' ');
                  // print('sel address => ${konsultasiController.selectedAddress.value}');
                  if (konsultasiController.selectedAddress.value != ' ' && selectedIdx != -2) {
                    Get.toNamed('/patient-confirmation', arguments: false);
                  } else if (konsultasiController.selectedAddress.value == ' ') {
                    AddPatientController addPatientCtrl = Get.put(AddPatientController());
                    await Get.toNamed('/patient-address');
                    // print('address id => ${addPatientCtrl.selectedAddress.value} | patient => ${konsultasiController.selectedUid.value}');

                    var res = await addPatientCtrl.updateAddress(konsultasiController.selectedUid.value, addPatientCtrl.selectedAddress.value);

                    if (res['status'] as bool) {
                      // print('set state? ${res['status']}');
                      setState(() {});
                      // Get.toNamed('/patient-confirmation');
                    }
                    // Get.toNamed('/patient-confirmation');
                    // showDialog(
                    //     context: context,
                    //     builder: (context) => CustomSimpleDialog(
                    //         icon: ImageIcon(
                    //           AssetImage('assets/group-5.png'),
                    //           size: 100,
                    //         ),
                    //         onPressed: () {
                    //           Get.back();
                    //           Get.toNamed('/patient-address', arguments: true);
                    //         },
                    //         title: 'Belum ada alamat',
                    //         buttonTxt: 'Tambah Alamat',
                    //         subtitle: 'Harap isi alamat terlebih dahulu'));
                  }
                },
                color: selectedIdx == -2 ? kLightGray : kButtonColor),
          )
        ],
      ),
    );
  }
}
