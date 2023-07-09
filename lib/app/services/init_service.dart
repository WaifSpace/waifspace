
import 'package:get/get.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/services/database_service.dart';

Future<void> initServices()  async {
  logger.i("开始启动服务");
  await Get.putAsync(() => DatabaseService().init());
  logger.i("服务启动完成");
}
