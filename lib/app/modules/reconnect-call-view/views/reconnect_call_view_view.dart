import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReconnectCallViewView extends StatefulWidget {
  @override
  _ReconnectCallViewViewState createState() => _ReconnectCallViewViewState();
}

class _ReconnectCallViewViewState extends State<ReconnectCallViewView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      // print('ke halaman reconnect nih !');
      Get.offNamed('/call-screen', arguments: 'doctor'); //biar ke halaman "landing loading nunggu pasien"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: CupertinoActivityIndicator(),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                'Harap tunggu, sedang mencoba menghubungkan kembali ...',
                textAlign: TextAlign.center,
                style: kPoppinsMedium500.copyWith(color: kBlackColor, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
