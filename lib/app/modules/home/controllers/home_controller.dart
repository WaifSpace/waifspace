import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/components/controllers/bottom_navigation_bar_controller.dart';
import 'package:waifspace/app/components/controllers/dream_browser_controller.dart';

class HomeController extends GetxController {
  BottomNavigationBarController navController = Get.find<BottomNavigationBarController>();
  ArticleListController articleListController = Get.find<ArticleListController>();
  DreamBrowserController dreamBrowserController = Get.find<DreamBrowserController>();

  int get currentNavIndex => navController.currentIndex;

  void onDoubleTap() {
    switch(navController.currentIndex) {
      case 0: articleListController.jumpToTop(); break;
      case 1: dreamBrowserController.goHomePage(); break;
    }

  }
}
