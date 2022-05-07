import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:altea/app/modules/add_patient/controllers/add_patient_controller.dart';
import 'package:altea/app/modules/spesialis_konsultasi/controllers/spesialis_konsultasi_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobilePatientConfirmation extends StatelessWidget {
  SpesialisKonsultasiController konsultasiController = Get.find<SpesialisKonsultasiController>();
  AddPatientController controller = Get.find<AddPatientController>();

  bool isLoad = false;

  String getAge(String birthDate) {
    String year = birthDate.split('-')[0];
    String now = DateTime.now().year.toString();
    String age = (int.parse(now) - int.parse(year)).toString();

    // print('iniii ageeee => $age');

    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: kWhiteGray),
            margin: EdgeInsets.all(25),
            padding: EdgeInsets.all(20),
            // height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              children: [
                Text(
                  'Pastikan data yang di isi sudah benar. Hubungi customer service AlteaCare untuk perubahan data.',
                  style: kPoppinsSemibold600.copyWith(color: kBlackColor.withOpacity(0.8), fontSize: 11),
                ),
                SizedBox(
                  height: 16,
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            'Nama                          :',
                            style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.6)),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text('${controller.firstName.value}  ${controller.lastName.value}',
                              style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.8)))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            'Umur                           :',
                            style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.6)),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text('${getAge(controller.birthDate.value)} Tahun',
                              style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.8)))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            'Status                         :',
                            style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.6)),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text('${controller.familyName.value}',
                              style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.8)))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            'Jenis Kelamin          :',
                            style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.6)),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text('${controller.gender.value}', style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.8)))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            'Tempat Lahir           :',
                            style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.6)),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text('${controller.birthTown.value},  ${controller.birthCountry.value}',
                              style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.8)))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            'Tanggal Lahir          :',
                            style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.6)),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text('${controller.birthDate.value}', style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.8)))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alamat                       :',
                            style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.6)),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text('${controller.fullAddress.value}',
                                style: kPoppinsRegular400.copyWith(fontSize: 11, color: kBlackColor.withOpacity(0.8))),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomFlatButton(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.06,
                text: 'Konfirmasi',
                onPressed: () async {
                  if (!isLoad) {
                    isLoad = true;
                    var result = await controller.addFamily();

                    if (result['status'] == true) {
                      Get.back();
                    }
                    isLoad = false;
                  }
                },
                color: kButtonColor),
          )
        ],
      ),
    );
  }
}
