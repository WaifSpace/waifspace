import 'package:get/get.dart';

import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/data/providers/setting_provider.dart';
import 'package:waifspace/app/services/ai_service.dart';
import 'package:waifspace/app/services/database_service.dart';
import 'package:waifspace/app/services/rss_service.dart';

Future<void> register() async {
  // 初始化数据库服务
  Get.put(await DatabaseService.build());

  // 初始化设置服务
  Get.put(await SettingProvider.build());

  // 初始化数据提供类
  Get.put(await ArticleProvider.build());
  Get.put(await ArticleSourceProvider.build());

  // 初始化一些具体的应用功能服务
  Get.put(RssService());
  Get.put(await AIService.build());
}
