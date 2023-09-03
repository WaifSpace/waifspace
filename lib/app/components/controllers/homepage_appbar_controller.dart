import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/modules/home/controllers/home_controller.dart';
import 'package:waifspace/app/services/rss_service.dart';

class HomepageAppbarController extends GetxController {

  static HomepageAppbarController get to => Get.find<HomepageAppbarController>();

  Future<void> reload() async {
    await RssService.to.fetchAllArticles();
  }

  String title() {
    return ArticleProvider.to.filterSourceName.isEmpty ? "新闻" : ArticleProvider.to.filterSourceName.value;
  }

  Future<void> add(String url, String name) async {
    try {
      var article = await RssService.to.addSource(url, name);
      if(article != null) {
        _showMsg("添加网站成功 ${article.name}");
        await ArticleSourceProvider.to.reloadArticleSources();
      } else {
        _showMsg("添加网站错误 $url");
      }
    } catch (e) {
      _showMsg("添加网站错误 ${e.toString()}");
    }
  }

  void _showMsg(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP
    );
  }
}
