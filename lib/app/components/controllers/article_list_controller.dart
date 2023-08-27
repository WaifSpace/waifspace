import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:waifspace/app/data/models/article_model.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/global.dart';

class ArticleListController extends GetxController {
  bool _isLoadMore = false;

  final ScrollController scrollController = ScrollController();
  final List<Article> _articles = <Article>[].obs;
  ArticleProvider articleProvider = Get.find<ArticleProvider>();

  @override
  void onInit() {
    reloadData().then((value) => scrollController.addListener(_loadMore));
    super.onInit();
  }


  @override
  void onClose() {
    scrollController.removeListener(_loadMore);
    super.onClose();
  }

  Future<void> reloadData() async {
    _articles.assignAll(await articleProvider.latestArticles(-1));
  }

  Article getArticle(index) {
    return _articles[index];
  }

  int articleCount() {
    return _articles.length;
  }

  void jumpToTop() {
    scrollController.jumpTo(0);
  }

  Future<void> _loadMore() async {
    // 暂停1秒，避免重复触发事件
    await Future.delayed(const Duration(seconds: 1));
    if (_isLoadMore == false && scrollController.position.extentAfter <= 300) {
      _isLoadMore = true;
      _articles.addAll(await articleProvider.latestArticles(_articles.last.id ?? -1));
      _isLoadMore = false;
    }
  }
}
