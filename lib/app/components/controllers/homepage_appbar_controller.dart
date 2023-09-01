import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/services/rss_service.dart';

class HomepageAppbarController extends GetxController {
  final title = "新闻".obs;

  var rssService = Get.find<RssService>();

  Future<void> reload() async {
    await rssService.fetchAllArticles();
    // await rssService.fetchArticles(2);
  }

  Future<void> add(String url, String name) async {
    try {
      var article = await rssService.addSource(url, name);
      if(article != null) {
        showMsg("添加网站成功 ${article.name}");
      } else {
        showMsg("添加网站错误 $url");
      }
    } catch (e) {
      showMsg("添加网站错误 ${e.toString()}");
    }
  }

  void showMsg(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP
    );
  }
}
