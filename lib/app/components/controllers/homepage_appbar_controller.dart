import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/bottom_navigation_bar_controller.dart';
import 'package:waifspace/app/components/controllers/dream_browser_controller.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/services/rss_service.dart';

class HomepageAppbarController extends GetxController {
  static HomepageAppbarController get to =>
      Get.find<HomepageAppbarController>();

  Future<void> reload() async {
    await RssService.to.fetchAllArticles();
  }

  String title() {
    switch (BottomNavigationBarController.to.currentIndex) {
      case 0:
        {
          return ArticleProvider.to.filterSourceName.isEmpty
              ? "新闻"
              : ArticleProvider.to.filterSourceName.value;
        }
        break;
      case 1:
        {
          return "应用";
        }
    }
    return 'WaifSpace';
  }

  Future<void> add(String url, String name) async {
    try {
      var article = await RssService.to.addSource(url, name);
      if (article != null) {
        showMsg("添加网站成功 ${article.name}");
        await ArticleSourceProvider.to.reloadArticleSources();
      } else {
        showMsg("添加网站错误 $url");
      }
    } catch (e) {
      showMsg("添加网站错误 ${e.toString()}");
    }
  }

  void doWebScript() {
    DreamBrowserController.to.doWebScript();
  }
}
