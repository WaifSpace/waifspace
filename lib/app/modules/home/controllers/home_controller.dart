import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/components/controllers/bottom_navigation_bar_controller.dart';
import 'package:waifspace/app/components/controllers/dream_browser_controller.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/services/rss_service.dart';

class HomeController extends GetxController {

  static HomeController get to => Get.find<HomeController>();

  int get currentNavIndex => BottomNavigationBarController.to.currentIndex;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  void onDoubleTap() {
    switch(BottomNavigationBarController.to.currentIndex) {
      case 0: ArticleListController.to.jumpToTop(); break;
      case 1: DreamBrowserController.to.goHomePage(); break;
    }
  }

  Future<void> fetchAllArticles() async {
    await RssService.to.fetchAllArticles();
    await ArticleListController.to.reloadData();
  }

  Future<bool> onWillPop() async {
    if(ArticleProvider.to.filterSourceName.isNotEmpty) {
      ArticleProvider.to.updateSourceIDFilter(null, '');
      ArticleListController.to.reloadData();
    }
    return true;
  }
}
