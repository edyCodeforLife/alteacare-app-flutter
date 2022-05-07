import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/patient_data/views/widget/patient_data_card.dart';
import 'package:altea/app/modules/patient_list/controllers/patient_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileAppView extends GetView<PatientListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Anggota Keluarga',
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              // height: MediaQuery.of(context).size.height * 0.43,
              child: Obx(
                () => NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    // print("cek cek cek");
                    if (scrollInfo is ScrollEndNotification &&
                        scrollInfo.metrics.extentAfter == 0 &&
                        controller.patientListState == PatientListState.ok &&
                        controller.maxPage > controller.page) {
                      controller.nextPatientList();
                      return true;
                    }
                    return false;
                  },
                  child: (controller.patientListState == PatientListState.loading)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : (controller.patientListState == PatientListState.error)
                          ? const Center()
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.listPatient.length,
                              itemBuilder: (context, index) {
                                // print('idx => ${patientData[index].addressId} - ${patientData[index].firstName}');
                                return PatientDataCard(
                                  idx: index,
                                  onTap: () {},
                                  // selected: index,
                                  patientData: controller.listPatient[index],
                                );
                              },
                            ),
                ),
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
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
