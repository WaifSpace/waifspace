import 'package:timeago/timeago.dart' as timeago;
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/register.dart';

Future<void> initApp() async {
  _initTimeago();
  await register();
}

void _initTimeago() {
  timeago.setLocaleMessages('zh_CN', timeago.ZhCnMessages());
}