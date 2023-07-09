import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:waifspace/app/services/init_service.dart';
import 'package:waifspace/init_app.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initApp();
  await initServices();
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
