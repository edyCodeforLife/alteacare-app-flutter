import 'dart:async';

import 'package:altea/app/core/utils/colors.dart';
import 'package:altea/app/core/utils/styles.dart';
import 'package:altea/app/core/widgets/custom_flat_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileAppView extends StatefulWidget {
  Function stopCall;
  bool isDoctor;

  MobileAppView({required this.stopCall, required this.isDoctor});
  @override
  _MobileAppViewState createState() => _MobileAppViewState();
}

class _MobileAppViewState extends State<MobileAppView> {
  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  late Timer _timer;

  Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stopwatch.start();
    _timer = new Timer.periodic(new Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
    _stopwatch.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Container(
        padding: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: MediaQuery.of(context).size.width / 6,
              backgroundColor: kButtonColor,
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 6.3,
                backgroundColor: kBackground,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              widget.isDoctor ? 'Waiting for Doctor' : 'Waiting for Medical Advisor',
              style: kPoppinsRegular400.copyWith(fontSize: 14, color: kBlackColor.withOpacity(0.7)),
            ),
            Text(formatTime(_stopwatch.elapsedMilliseconds), style: kPoppinsSemibold600.copyWith(fontSize: 20, color: kDarkBlue)),
            SizedBox(
              height: 60,
            ),
            CustomFlatButton(
              height: MediaQuery.of(context).size.height * 0.06,
              width: double.infinity,
              text: 'Cancel',
              onPressed: () {
                widget.stopCall(false);
                Get.offNamed('/home');
              },
              color: kBackground,
              borderColor: kButtonColor,
            )
          ],
        ),
      ),
    );
  }
}
