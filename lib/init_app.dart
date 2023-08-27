import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/register.dart';

Future<void> initApp() async {
  _initGetX();
  register();
  _initTimeago();
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

void _initTimeago() {
  timeago.setLocaleMessages('zh_CN', timeago.ZhCnMessages());
}