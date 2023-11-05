import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waifspace/init_app.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();

  runApp(
    GetMaterialApp(
      title: "WaifSpace",
      // 暂时下你使用明亮模式，避免rss 添加输入框的文字颜色错误
      theme: FlexThemeData.light(scheme: FlexScheme.aquaBlue),
      enableLog: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
