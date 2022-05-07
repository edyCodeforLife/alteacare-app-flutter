// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/settings.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/data/model/patient_data_model.dart';
import 'package:altea/app/modules/add_patient/controllers/add_patient_controller.dart';
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:altea/app/modules/home/views/mobile_web/mobile_web_hamburger_menu.dart';
import 'package:altea/app/modules/home/views/mobile_web/widgets/mobile_web_main_appbar.dart';
import 'package:altea/app/modules/patient_data/controllers/patient_data_controller.dart';
import 'package:altea/app/routes/app_pages.dart';

class MobileWebPatientDataPage extends GetView<PatientDataController> {
  const MobileWebPatientDataPage({Key? key, this.doctorIdFromParam}) : super(key: key);
  final String? doctorIdFromParam;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final screenWidth = MediaQuery.of(context).size.width;
    final homeController = Get.find<HomeController>();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kBackground,
      appBar: MobileWebMainAppbar(
        scaffoldKey: scaffoldKey,
      ),
      drawer: MobileWebHamburgerMenu(),
      body: ListView(
        children: [
          const SizedBox(
            height: 26,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Data Pasien",
                  style: kPoppinsMedium500.copyWith(fontSize: 17, color: kBlackColor),
                ),
                Text(
                  "Pilih pasien yang akan melakukan konsultasi.",
                  style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          FutureBuilder<PatientData>(
              future: controller.getPatientList(homeController.accessTokens.value),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  final PatientData result = snapshot.data!;

                  if (result.status!) {
                    return Column(
                      children: List.generate(result.data!.patient.length, (index) {
                        final dataPatient = result.data!.patient[index];
                        String? alamat =
                            "${dataPatient.street!}, Blok RT/RW${dataPatient.rtRw!}, Kel. ${dataPatient.subDistrict!.name}, Kec.${dataPatient.district!.name} ${dataPatient.city!.name} ${dataPatient.province!.name} ${dataPatient.subDistrict!.postalCode}";
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: InkWell(
                            onTap: () {
                              controller.selectedPatient.value = index;
                              controller.selectedPatientData.value = dataPatient;
                            },
                            child: PatientCardWeb(
                              dataPatient: dataPatient,
                              alamat: alamat,
                              index: index,
                            ),
                          ),
                        );
                      }),
                    );
                  } else {
                    return Center(
                      child: Text(
                        "No Data",
                        style: kPoppinsMedium500.copyWith(color: kBlackColor),
                      ),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          const SizedBox(
            height: 21,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 1,
                  width: screenWidth * 0.22,
                  color: kLightGray,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  "Belum ada daftar keluarga?",
                  style: kPoppinsRegular400.copyWith(color: kLightGray, fontSize: 10),
                ),
                const SizedBox(
                  width: 4,
                ),
                Container(
                  height: 1,
                  width: screenWidth * 0.22,
                  color: kLightGray,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 21,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                    color: kBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(blurRadius: 12, offset: const Offset(0, 3), color: kLightGray)]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tambah Data Pasien",
                      style: kPoppinsSemibold600.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.6)),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.toNamed("${Routes.ADD_PATIENT}?doctorId=$doctorIdFromParam");
                        },
                        icon: Icon(
                          Icons.add_circle_outlined,
                          color: kButtonColor,
                        ))
                  ],
                )),
          ),
          const SizedBox(
            height: 175,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Obx(() => CustomFlatButton(
                width: screenWidth,
                text: "Lanjutkan",
                onPressed: () async {
                  if (controller.selectedPatientData.value.id != null) {
                    if (controller.selectedPatientData.value.addressId!.replaceAll(" ", "").isEmpty) {
                      // print("KOSONG");

                      AddPatientController addPatientCtrl = Get.put(AddPatientController());
                      await Get.toNamed('/patient-address?doctorId=$doctorIdFromParam');

                      // var res = await addPatientCtrl.updateAddress(
                      //     konsultasiController.selectedUid.value,
                      //     addPatientCtrl.selectedAddress.value);
                      //
                      // if (res['status'] as bool) {
                      //   print('set state? ${res['status']}');
                      //   setState(() {});
                      // Get.toNamed('/patient-confirmation');

                    } else {
                      Get.toNamed("${Routes.PATIENT_CONFIRMATION}?doctorId=$doctorIdFromParam", arguments: controller.selectedPatientData.value);
                    }
                  }
                },
                color: (controller.selectedPatientData.value.id != null) ? kButtonColor : Colors.black12)),
          ),
          const SizedBox(
            height: 28,
          ),
        ],
      ),
    );
  }
}

class PatientCardWeb extends StatefulWidget {
  const PatientCardWeb({
    Key? key,
    required this.dataPatient,
    required this.index,
    required this.alamat,
  }) : super(key: key);

  final Patient dataPatient;
  final int index;
  final String alamat;

  @override
  _PatientCardWebState createState() => _PatientCardWebState();
}

class _PatientCardWebState extends State<PatientCardWeb> {
  bool isExpanded = false;
  final controller = Get.find<PatientDataController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
              color: kBackground,
              border: Border.all(color: controller.selectedPatient.value == widget.index ? kDarkBlue : kBackground),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(blurRadius: 12, offset: const Offset(0, 3), color: kLightGray)]),
          child: isExpanded
              ? buildExpandPatientCard(
                  dataPatient: widget.dataPatient,
                  alamat: widget.alamat,
                )
              : buildPatientCard(
                  dataPatient: widget.dataPatient,
                ),
          // Container(
          //     padding: const EdgeInsets.all(8),
          //     margin: const EdgeInsets.only(bottom: 8),
          //     decoration: BoxDecoration(
          //         color: kBackground,
          //         borderRadius: BorderRadius.circular(12),
          //         boxShadow: [
          //           BoxShadow(
          //               blurRadius: 12,
          //               offset: const Offset(0, 3),
          //               color: kLightGray)
          //         ]),
          //     child: Center(
          //       child: Theme(
          //         data: Theme.of(context).copyWith(
          //             dividerColor: Colors.transparent),
          //         child: ExpansionTile(
          //           key: controller.keyTile,
          //           initiallyExpanded:
          //               controller.isExpanded.value,
          //           childrenPadding:
          //               const EdgeInsets.symmetric(
          //                   horizontal: 16),

          //           children: [

          //           ],
          //         ),
          //       ),
          //     )),
        ));
  }

  Widget buildPatientCard({required Patient dataPatient}) {
    return Row(
      children: [
        SizedBox(
          width: 39,
          height: 39,
          child: (dataPatient.cardPhoto!.isEmpty || dataPatient.cardPhoto == null || dataPatient.cardPhoto! == " ")
              ? Image.asset('assets/account-info.png')
              : Image.network(addCDNforLoadImage(dataPatient.cardPhoto!), fit: BoxFit.cover),
        ),
        const SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${dataPatient.firstName!} ${dataPatient.lastName!}', style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor)),
            Text('${dataPatient.age!.year} Tahun', style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor)),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          icon: Icon(
            (isExpanded) ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
            size: 14,
          ),
        )
      ],
    );
  }

  Widget buildExpandPatientCard({
    required Patient dataPatient,
    required String alamat,
  }) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
                width: 39,
                height: 39,
                child: (dataPatient.cardPhoto!.isEmpty || dataPatient.cardPhoto == null || dataPatient.cardPhoto! == " ")
                    ? Image.asset('assets/account-info.png')
                    : Image.network(addCDNforLoadImage(dataPatient.cardPhoto!), fit: BoxFit.cover)),
            const SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${dataPatient.firstName!} ${dataPatient.lastName!}', style: kPoppinsMedium500.copyWith(fontSize: 12, color: kBlackColor)),
                Text('${dataPatient.age!.year} Tahun', style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor)),
              ],
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                  setState(
                    () {
                      isExpanded = !isExpanded;
                    },
                  );
                },
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 14,
                ))
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Jenis Kelamin",
                    style: kPoppinsRegular400.copyWith(fontSize: 10, color: kLightGray),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Text(
                        ":",
                        style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          dataPatient.gender == "MALE" ? "Laki-laki" : "Perempuan",
                          style: kPoppinsMedium500.copyWith(fontSize: 10, color: kBlackColor),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Tempat lahir",
                    style: kPoppinsRegular400.copyWith(fontSize: 10, color: kLightGray),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Text(
                        ":",
                        style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          "${dataPatient.birthPlace!}, ${dataPatient.birthCountry?.name!}",
                          style: kPoppinsMedium500.copyWith(fontSize: 10, color: kBlackColor),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Tanggal lahir",
                    style: kPoppinsRegular400.copyWith(
                      fontSize: 10,
                      color: kLightGray,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Text(
                        ":",
                        style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          DateFormat("dd/MM/yyyy").format(dataPatient.birthDate!),
                          style: kPoppinsMedium500.copyWith(fontSize: 10, color: kBlackColor),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 70,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "Alamat",
                      style: kPoppinsRegular400.copyWith(
                        fontSize: 10,
                        color: kLightGray,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Text(
                          ":",
                          style: kPoppinsRegular400.copyWith(fontSize: 10, color: kBlackColor),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            alamat == null ? "No Data" : alamat,
                            style: kPoppinsMedium500.copyWith(fontSize: 10, color: kBlackColor),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ],
    );
  }
}
