// Package imports:
// Project imports:
import 'package:altea/app/data/model/hospital.dart' as hospital;
import 'package:altea/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DoctorSpesialisController extends GetxController {
  final homeController = Get.find<HomeController>();
  final http.Client client = http.Client();
  final spesialisAnakId = "607d01ca3925ca001231fae3";
  RxList<hospital.Datum> allHospital = <hospital.Datum>[].obs;

  // Future<Doctors> getDoctorListBySpecializationAndAllHospitalFilter(
  //     {String? selectedDoctorFilterId}) async {
  //   isLoadingPage.value = true;

  //   RxString selectDoctor = (selectedDoctorFilterId ?? "").obs;

  //   if (selectDoctor.isEmpty) {
  //     selectDoctor.value = spesialisAnakId;
  //   }

  //   try {
  //     final response = await client.get(
  //       Uri.parse(
  //         "$alteaURL/data/doctors?specialis.id_in=${selectDoctor.value}",
  //       ),
  //     );

  //     // print('balikan => ${response.statusCode} : ${response.body}');
  //     if (response.statusCode == 200) {
  //       isLoadingPage.value = false;

  //       print('masuk 200');
  //       return Doctors.fromJson(
  //           jsonDecode(response.body) as Map<String, dynamic>);
  //     } else {
  //       // print('masuk $response.body');
  //       isLoadingPage.value = false;

  //       return Doctors.fromJsonError(
  //           jsonDecode(response.body) as Map<String, dynamic>);
  //     }
  //   } catch (e) {
  //     // print("masuk catch $e");
  //     isLoadingPage.value = false;

  //     return Doctors.fromJsonErrorCatch(e.toString());
  //   }
  // }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
