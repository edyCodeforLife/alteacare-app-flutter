// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/modules/my_consultation_detail/controllers/my_consultation_detail_controller.dart';
import 'package:altea/app/modules/my_consultation_detail/models/my_consultation_detail_model.dart';
import './mobile_web_medical_data_container.dart';

class MWCDDokumenMedis extends StatelessWidget {
  final List<MedicalDocument> dataMedicalDocs;
  final MyConsultationDetailController _controller = Get.find();
  final double screenWidth = Get.width;
  MWCDDokumenMedis({required this.dataMedicalDocs}) {
    _controller.uploadByAltea.value = [];
    _controller.uploadedByUser.value = [];
    for (var i = 0; i < dataMedicalDocs.length; i++) {
      // cek document baru
      if (i == dataMedicalDocs.length - 1) {
        _controller.newDocument.value = dataMedicalDocs[i].toJson();
      }
      // assign document
      if (dataMedicalDocs[i].uploadByUser == 0) {
        _controller.uploadByAltea.add(dataMedicalDocs[i].toJson());
      } else {
        _controller.uploadedByUser.add(dataMedicalDocs[i].toJson());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (dataMedicalDocs.isEmpty)
          ? Container(
              height: 50,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Tidak ada dokumen tersedia",
                textAlign: TextAlign.center,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MobileWebMedicalDataContainer(
                  bannerTitle: "Dokumen Terbaru",
                  newDocument: _controller.newDocument,
                ),
                if (_controller.uploadByAltea.isNotEmpty) ...[
                  MobileWebMedicalDataContainer(
                    bannerTitle: "Dokumen AlteaCare",
                    medicalDocuments: _controller.uploadByAltea,
                  ),
                ],
                if (_controller.uploadedByUser.isNotEmpty) ...[
                  MobileWebMedicalDataContainer(
                    bannerTitle: "Dokumen Saya",
                    medicalDocuments: _controller.uploadedByUser,
                  ),
                ]
              ],
            ),
    );
  }
}
