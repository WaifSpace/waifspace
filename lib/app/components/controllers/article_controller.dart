import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/data/models/article_model.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/helper/app_time.dart';
import 'package:waifspace/app/services/ai_service.dart';
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
    url = url.trim();

    if(!url.startsWith("http")) {
      return;
    }
    await _browser.open(
        url: WebUri(url),
        settings: ChromeSafariBrowserSettings(
            shareState: CustomTabsShareState.SHARE_STATE_OFF,
            barCollapsingEnabled: true));
  }

  void filterSource(int sourceID, String sourceName) {
    articleProvider.updateSourceIDFilter(sourceID, sourceName);
    articleListController.reloadData();
  }

  void bookmark(Article article, BuildContext context) {
    if(article.title != null && article.url != null) {
      CuboxService.save(article.title ?? '', article.url ?? '', htmlToText(article.content ?? "").trim(), context);
    }
  }

  Future<void> translate(String text) async {
    await AIService.to.translate(text);
  }

  Future<void> readArticle(int? articleID) async {
    if(articleID == null) {
      return;
    }
    await ArticleProvider.to.readArticle(articleID);
  }

  void share(Article article) {
    var url = article.url ?? '';
    var title = article.cnTitle ?? article.title;
    Share.share('$title: $url', subject: title);
  }
}


class _NewsBrowser extends ChromeSafariBrowser {
}