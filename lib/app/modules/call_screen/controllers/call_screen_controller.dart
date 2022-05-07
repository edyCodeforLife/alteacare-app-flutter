// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

class CallScreenController extends GetxController {
  final http.Client client = http.Client();

  RxBool isDownloadLoading = false.obs;
  RxBool isCallerEndCall = false.obs;
  final String? orderIdFromParam;
  RxBool isTryingReconnect = false.obs;
  RxBool isShareScreen = false.obs;
  RxBool isMeDisconnect = false.obs;

  CallScreenController({this.orderIdFromParam}) {
    if (GetPlatform.isWeb) {
      if (orderIdFromParam != null) {
        if (orderIdFromParam!.isNotEmpty) {
          orderId.value = orderIdFromParam!;
        } else {
          // print("call screen ctrl empty");
          Future.delayed(Duration.zero, () {
            Get.offAndToNamed("/err_404");
          });
        }
      } else {
        // print("call screen ctrl null");
        Future.delayed(Duration.zero, () {
          Get.offAndToNamed("/err_404");
        });
      }
    }
  }

  /// this function is for handle user input only empty string
  bool isAllSpaces(String input) {
    final String output = input.replaceAll(' ', '');
    if (output == '') {
      return true;
    }
    return false;
  }

  Future processFile(String url, String filename) async {
    try {
      http.Response response = await http.get(Uri.parse(url));
      // print('responseee => ${response.body}');
      final encodedStr = base64Encode(response.bodyBytes);
      Uint8List bytes = base64.decode(encodedStr);
      // final stream = Stream.fromIterable(bytes);
      // await download(stream, filename);
      String dir = (await getApplicationDocumentsDirectory()).path;
      // print('dir => $dir');
      File file = File('$dir/$filename');
      // print('file => ${file.path}');
      await file.writeAsBytes(bytes);
      // print('finish writes');

      //

      // Get.to(SfPdfViewer.memory(bytes));
      // PDFDocument doc = await PDFDocument.fromFile(file);
      // Get.to(PDFViewer(
      //   document: doc,
      // ));

      // return file.path;
    } catch (e) {
      // print('download error => $e');
    }
  }

  Future<void> downloadFile(String fileName, String url) async {
    isDownloadLoading.value = true;
    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // ? below function is for download file in browser

        final rawData = base64Encode(response.bodyBytes);
        // print('disini');
        html.AnchorElement(href: "data:application/octet-stream;charset=utf-16le;base64,$rawData")
          ..setAttribute("download", fileName)
          ..click();
        // print('kelar download?');
        isDownloadLoading.value = false;
      } else {
        // print("response error ->${response.statusCode}");
        // print("response error ->${response.reasonPhrase}");
        isDownloadLoading.value = false;
      }
    } catch (e) {
      // print("cathc error -> $e");
      isDownloadLoading.value = false;
    }
  }

  RxBool isMicOn = false.obs;
  RxBool isCameraOn = false.obs;

  RxBool videoState = true.obs;
  RxBool audioState = true.obs;
  // RxBool isShareScreen = false.obs;

  RxString fileUrl = ''.obs;
  RxString fileName = ''.obs;
  RxString callId = "".obs;
  RxBool isOpenChatContainer = false.obs;

  RxBool initCallDoctor = false.obs;
  RxBool callerA = false.obs;
  RxBool callerB = false.obs;
  RxBool theCaller = false.obs;
  RxBool callerAisOnline = false.obs;
  RxBool callerBisOnline = false.obs;
  RxString maName = "".obs;
  RxString callType = "".obs;
  RxBool onShareScreen = false.obs;
  RxInt chatCount = 0.obs;
  RxString orderId = "".obs;
  RxString patientName = "".obs;

  // RxBool isMeDisconnect = false.obs;

  UploadTask? uploadBytes(String destination, Uint8List dataBytes) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      // print("berhasil upload");

      // try {
      //   await storage.ref('chatFiles/$fileName').putFile(file);
      //   fileUrl.value = await storage.ref('chatFiles/$fileName').getDownloadURL();
      //   print('url download => ${fileUrl.value}');
      // } on FirebaseException catch (e) {
      //   print('error => $e');
      // }

      return ref.putData(dataBytes, SettableMetadata(contentType: 'image/jpeg'));
    } on FirebaseException catch (e) {
      // print("ada error upload");

      return null;
    }
  }

  Future pickImage(ImageSource src) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: src, maxWidth: 720, imageQuality: 70);
    if (image != null) {
      final File imageFile = File(image.path);
      // print('imageFile => $imageFile');
      // print('fileName => ${image.name}');

      await uploadFile(imageFile, image.name);

      // Uint8List uintImage = imageFile.readAsBytesSync();
    }
  }

  Future pickFile() async {
    // print('masuk siniii ~~~~~');
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowCompression: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );

    // print('fileUrl => ${fileUrl.value}');

    // print('resulttt => $result');
    PlatformFile? objFile;

    if (result != null) {
      // print('result fileee => ${result.files.first.path}');
      final File file = File(result.files.first.path.toString());
      // print('ini fileee => $file');
      fileName.value = result.files.first.name.toString();
      await uploadFile(file, result.files.first.name);
    }
  }

  Future uploadFile(File file, String fileName) async {
    final FirebaseStorage storage = FirebaseStorage.instance;

    try {
      await storage.ref('chatFiles/$fileName').putFile(file);
      fileUrl.value = await storage.ref('chatFiles/$fileName').getDownloadURL();
      // print('url download => ${fileUrl.value}');
    } on FirebaseException catch (e) {
      // print('error => $e');
    }
  }

  Rx<Stopwatch> _stopWatch = Stopwatch().obs;
  int get stopWatchElapsedTime => _stopWatch.value.elapsedMilliseconds;

  void startStopWatchOnCall() {
    _stopWatch.value.stop();
    _stopWatch.value.reset();
    _stopWatch.value.start();
  }

  void stopStopWatchOnCall() {
    _stopWatch.value.stop();
  }

  Rx<bool> isSmallScreen = false.obs;

  void refreshThisController() {
    isDownloadLoading.value = false;
    isCallerEndCall.value = false;
    isMicOn.value = false;
    isCameraOn.value = false;
    videoState.value = true;
    audioState.value = true;
    fileUrl.value = '';
    fileName.value = '';
    callId.value = "";
    isOpenChatContainer.value = false;
    initCallDoctor.value = false;
    callerA.value = false;
    callerB.value = false;
    theCaller.value = false;
    callType.value = "";
    onShareScreen.value = false;
    chatCount.value = 0;
    orderId.value = "";
    update();
  }

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
