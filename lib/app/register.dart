import 'package:get/get.dart';

import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/services/database_service.dart';
import 'package:waifspace/app/services/rss_service.dart';

// 用于注册Getx用到的一些依赖
Future<void> register() async {

  // 初始化数据库服务
  Get.put(await DatabaseService().init());

  // 初始化数据提供类
  Get.put(ArticleProvider());
  Get.put(ArticleSourceProvider());

  // 初始化一些具体的应用功能服务
  Get.put<RssService>(RssService());
}
