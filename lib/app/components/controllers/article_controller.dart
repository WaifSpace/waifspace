import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/data/models/article_model.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/helper/app_time.dart';
import 'package:waifspace/app/services/cubox_service.dart';

class ArticleController extends GetxController {
  static ArticleController get to => Get.find<ArticleController>();

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

  void bookmark(Article article) {
    if(article.title != null && article.url != null) {
      CuboxService.save(article.title ?? '', article.url ?? '', htmlToText(article.content ?? "").trim());
    }
  }
}


class _NewsBrowser extends ChromeSafariBrowser {
}