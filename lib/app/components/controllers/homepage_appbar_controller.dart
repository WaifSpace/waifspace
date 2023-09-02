import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/services/rss_service.dart';

class HomepageAppbarController extends GetxController {

  RssService rssService = Get.find<RssService>();
  ArticleListController articleListController = Get.find<ArticleListController>();
  ArticleProvider articleProvider = Get.find<ArticleProvider>();

  Future<void> reload() async {
    await rssService.fetchAllArticles();
  }

  String title() {
    return articleProvider.filterSourceName.isEmpty ? "新闻" : articleProvider.filterSourceName.value;
  }

  Future<void> add(String url, String name) async {
    try {
      var article = await rssService.addSource(url, name);
      if(article != null) {
        _showMsg("添加网站成功 ${article.name}");
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
