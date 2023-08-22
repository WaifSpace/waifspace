import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/services/rss_service.dart';

class HomepageAppbarController extends GetxController {
  String get title => '新闻';
  var rssService = Get.find<RssService>();

  void reload() {
    rssService.fetchArticles(1);
  }

  Future<void> add(String url, String name) async {
    try {
      await rssService.addSource(url, name);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "添加网站错误 ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP
      );
    }
  }
}
