import 'package:get/get.dart';

import 'package:waifspace/app/components/controllers/article_controller.dart';
import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/components/controllers/bottom_navigation_bar_controller.dart';
import 'package:waifspace/app/components/controllers/homepage_appbar_controller.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';

// 用于注册Getx用到的一些依赖
void register() {
  // components
  Get.lazyPut(() => HomepageAppbarController());
  Get.lazyPut(() => BottomNavigationBarController());
  Get.lazyPut(() => ArticleListController());
  Get.lazyPut(() => ArticleController());

  // data/providers
  Get.lazyPut(() => ArticleProvider());
  Get.lazyPut(() => ArticleSourceProvider());
}
