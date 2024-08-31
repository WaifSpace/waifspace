import 'dart:isolate';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waifspace/init_app.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {

  FlutterError.onError = (FlutterErrorDetails details) {
    print(details);
  };

  WidgetsFlutterBinding.ensureInitialized();
  await initApp();

  final darkTheme = FlexThemeData.dark(scheme: FlexScheme.aquaBlue).copyWith(
    cupertinoOverrideTheme: const CupertinoThemeData(
      textTheme: CupertinoTextThemeData(), // This is required
    ),
  );

  runApp(
    GetMaterialApp(
      title: "WaifSpace",
      theme: FlexThemeData.light(scheme: FlexScheme.aquaBlue),
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      enableLog: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );

  performBackgroundTask();
}

void performBackgroundTask() async {
  Isolate.spawn(backgroundTask, 'Hello from the main thread');
}

void backgroundTask(String message) {
  print("backgroundTask");
}