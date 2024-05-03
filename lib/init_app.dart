import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/register.dart';

Future<void> initApp() async {
  _initTimeago();
  _initDio();
  await register();
  await initFlutterDownloader();

  // 关闭 inappwebview 的调试信息的输出
  if(!isProduction) {
    PlatformInAppWebViewController.debugLoggingSettings.enabled = false;
  }
}

void _initTimeago() {
  timeago.setLocaleMessages('zh_CN', timeago.ZhCnMessages());
}

void _initDio() {
  dio.interceptors.add(TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: false,
        printResponseHeaders: false,
        printResponseData: false,
      )
  ));
  dio.interceptors.add(RetryInterceptor(
    dio: dio,
    logPrint: null, // specify log function (optional)
    retries: 3, // retry count (optional)
  ));
  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.options.receiveTimeout = const Duration(seconds: 5);
}

Future<void> initFlutterDownloader() async {
  await FlutterDownloader.initialize(
      debug: !isProduction, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl: false      // option: set to false to disable working with http links (default: false)
  );
}