// Dart imports:
import 'dart:async';

// Project imports:
import 'package:altea/app/core/utils/use_shared_pref.dart';
import 'package:altea/app/modules/home/bindings/home_binding.dart';
// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Here we set the URL strategy for our web app.
  // It is safe to call this function when running on mobile or desktop as well.
  setPathUrlStrategy();

  await AppSharedPreferences.init();

  await Firebase.initializeApp();

  HomeBinding().dependencies();
  initializeDateFormatting();

  // ? kalau di app pakai ini
  // runZonedGuarded<Future<void>>(() async {
  //   //   // The following lines are the same a previously explained in "Handling uncaught errors"
  //   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  //   runApp(
  //     GetMaterialApp(
  //       // builder: (context, child) => ResponsiveWrapper(
  //       //   maxWidth: 1200,
  //       //   minWidth: 480,
  //       //   defaultScale: true,
  //       //   breakpoints: [
  //       //     ResponsiveBreakpoint.resize(480, name: MOBILE),
  //       //     ResponsiveBreakpoint.autoScale(800, name: TABLET),
  //       //     ResponsiveBreakpoint.resize(1000, name: DESKTOP),
  //       //   ],
  //       //   child: child,
  //       // ),
  //       title: "Altea Care",
  //       initialRoute: AppPages.INITIAL,
  //       getPages: AppPages.routes,
  //       debugShowCheckedModeBanner: false,
  //       theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
  //       // unknownRoute: GetPage(
  //       //   name: '/err_404',
  //       //   page: () => Error404View(),
  //       // ),
  //     ),
  //   );
  // }, FirebaseCrashlytics.instance.recordError);

  // ? kalau di web pakai ini, krn di web tidak ada crashlytics
  runApp(
    GetMaterialApp(
      title: "Altea Care",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      // unknownRoute: GetPage(
      //   name: '/err_404',
      //   page: () => Error404View(),
      // ),
    ),
  );
}
