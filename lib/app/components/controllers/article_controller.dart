import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/data/models/article_model.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/helper/app_time.dart';

class ArticleController extends GetxController {
  final ChromeSafariBrowser _browser = _NewsBrowser();
  ArticleProvider articleProvider = Get.find<ArticleProvider>();
  ArticleListController articleListController = Get.find<ArticleListController>();

  String articleTime(Article article) {
    if(article.pubDate != null && article.pubDate != "") {
      return AppTime.parse(article.pubDate!).viewFormat();
    }
    if(article.createdAt != null && article.createdAt != "") {
      return AppTime.parse(article.createdAt!).viewFormat();
    }
    return "";
  }

  Future<void> openBrowser(String? url) async {
    if(url == null || url.isEmpty) {
      return;
    }
    await _browser.open(
        url: Uri.parse(url),
        options: ChromeSafariBrowserClassOptions(
            android: AndroidChromeCustomTabsOptions(
                shareState: CustomTabsShareState.SHARE_STATE_OFF),
            ios: IOSSafariOptions(barCollapsingEnabled: true)));
  }

  void filterSource(int sourceID, String sourceName) {
    articleProvider.updateSourceIDFilter(sourceID, sourceName);
    articleListController.reloadData();
  }
}


class _NewsBrowser extends ChromeSafariBrowser {
}