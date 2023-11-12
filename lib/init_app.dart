import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/register.dart';

Future<void> initApp() async {
  _initTimeago();
  _initDio();
  await register();
}

void _initTimeago() {
  timeago.setLocaleMessages('zh_CN', timeago.ZhCnMessages());
}

void _initDio() {
  dio.interceptors.add(
    TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: true,
        printResponseMessage: false,
      ),
    ),
  );
  dio.interceptors.add(RetryInterceptor(
    dio: dio,
    logPrint: print, // specify log function (optional)
    retries: 3, // retry count (optional)
  ));
  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 10);
}
