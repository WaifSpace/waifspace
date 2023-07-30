import 'package:get/get.dart';

import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/services/database_service.dart';
import 'package:waifspace/app/services/rss_service.dart';

Future<void> initServices() async {
  logger.i("开始启动服务");
  await Get.putAsync(() => DatabaseService().init());
  Get.put<RssService>(RssService());
  logger.i("服务启动完成");
}
