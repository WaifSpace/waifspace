import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/bottom_navigation_bar_controller.dart';
import 'package:waifspace/app/components/controllers/homepage_appbar_controller.dart';

// 用于注册Getx用到的一些依赖
void register() {
  Get.lazyPut(()=>HomepageAppbarController());
  Get.lazyPut(()=>BottomNavigationBarController());
}