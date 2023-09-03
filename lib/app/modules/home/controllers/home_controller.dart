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

  bool closeDrawer() {
    if(scaffoldKey.currentState != null && scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState?.openEndDrawer();
      return true;
    }
    return false;
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
    // 先关闭左侧的划窗
    if(HomeController.to.closeDrawer()) {
      return false;
    }

    switch(BottomNavigationBarController.to.currentIndex) {
      case 0: { // 如果是新闻页面的时候，是去掉筛选标签
        if(ArticleProvider.to.filterSourceName.isNotEmpty) {
          ArticleProvider.to.updateSourceIDFilter(null, '');
          ArticleListController.to.reloadData();
          return false;
        }
      }
      break;
      case 1: { // 如果是应用页，目前主要是定位到浏览器的后退
        DreamBrowserController.to.goBack();
        return false;
      }
      break;
    }
    return false;
  }
}
