import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/components/controllers/bottom_navigation_bar_controller.dart';

class HomeController extends GetxController {
  BottomNavigationBarController navController = Get.find<BottomNavigationBarController>();
  ArticleListController articleListController = Get.find<ArticleListController>();

  int get currentNavIndex => navController.currentIndex;

  void onDoubleTap() {
    articleListController.jumpToTop();
  }
}
