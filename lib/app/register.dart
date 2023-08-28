import 'package:get/get.dart';

import 'package:waifspace/app/components/controllers/article_controller.dart';
import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/components/controllers/bottom_navigation_bar_controller.dart';
import 'package:waifspace/app/components/controllers/dream_browser_controller.dart';
import 'package:waifspace/app/components/controllers/homepage_appbar_controller.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/modules/apps/controllers/apps_controller.dart';

// 用于注册Getx用到的一些依赖
void register() {
  // components
  Get.lazyPut(() => HomepageAppbarController());
  Get.lazyPut(() => BottomNavigationBarController());
  Get.lazyPut(() => ArticleListController());
  Get.lazyPut(() => ArticleController());
  Get.lazyPut(() => DreamBrowserController());

  // 奇怪，这个地方应该是不用注册才对的，不知道为什么
  Get.lazyPut(() => AppsController());

  // data/providers
  Get.lazyPut(() => ArticleProvider());
  Get.lazyPut(() => ArticleSourceProvider());
}
