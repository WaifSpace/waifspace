import 'package:get/get.dart';
import 'package:waifspace/app/global.dart';

void initApp() {
  _initGetX();
}

void _initGetX() {
  Get.config(
    enableLog: true,
    logWriterCallback: _localLogWriter,
  );
}

void _localLogWriter(String text, {bool isError = false}) {
  if(isError) {
    logger.e("[GETX] $text");
  } else {
    logger.d("[GETX] $text");
  }
}