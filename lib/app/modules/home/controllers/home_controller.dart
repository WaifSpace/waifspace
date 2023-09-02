import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/components/controllers/bottom_navigation_bar_controller.dart';
import 'package:waifspace/app/components/controllers/dream_browser_controller.dart';
import 'package:waifspace/app/data/models/article_source_model.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/services/rss_service.dart';

class HomeController extends GetxController {
  BottomNavigationBarController navController = Get.find<BottomNavigationBarController>();
  ArticleListController articleListController = Get.find<ArticleListController>();
  DreamBrowserController dreamBrowserController = Get.find<DreamBrowserController>();

  ArticleProvider articleProvider = Get.find<ArticleProvider>();
  ArticleSourceProvider articleSourceProvider = Get.find<ArticleSourceProvider>();
  RssService rssService = Get.find<RssService>();

  int get currentNavIndex => navController.currentIndex;

  var cacheArticleSources = [].obs;

  @override
  onInit() {
    reloadArticleSources();
    super.onInit();
  }

  Future<void> reloadArticleSources() async {
    cacheArticleSources.assignAll(await articleSourceProvider.findAll());
  }

  void onDoubleTap() {
    switch(navController.currentIndex) {
      case 0: articleListController.jumpToTop(); break;
      case 1: dreamBrowserController.goHomePage(); break;
    }
  }

  Future<void> fetchAllArticles() async {
    await rssService.fetchAllArticles();
    await articleListController.reloadData();
  }

  Future<bool> onWillPop() async {
    if(articleProvider.filterSourceName.isNotEmpty) {
      articleProvider.updateSourceIDFilter(null, '');
      articleListController.reloadData();
    }
    return false;
  }
}
