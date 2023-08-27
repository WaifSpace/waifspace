import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/register.dart';

Future<void> initApp() async {
  _initGetX();
  register();
  await _initJiffy();
}

void _initGetX() {
  Get.config(
    enableLog: true,
    logWriterCallback: _localLogWriter,
  );
}

void _localLogWriter(String text, {bool isError = false}) {
  if (isError) {
    logger.e("[GETX] $text");
  } else {
    logger.d("[GETX] $text");
  }
}

Future<void> _initJiffy() async {
  await Jiffy.setLocale('zh_cn');
}