import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waifspace/init_app.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();

  runApp(
    GetMaterialApp(
      title: "Application",
      theme: ThemeData.dark(useMaterial3: true),
      enableLog: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
