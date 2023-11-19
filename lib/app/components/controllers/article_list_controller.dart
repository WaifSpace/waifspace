import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:waifspace/app/data/models/article_model.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/global.dart';

class ArticleListController extends GetxController {

  static ArticleListController get to => Get.find<ArticleListController>();

  bool _isLoadMore = false;
  var showSearch = false.obs;

  final ScrollController scrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();

  final List<Article> _articles = <Article>[].obs;
  ArticleProvider articleProvider = Get.find<ArticleProvider>();

  @override
  void onInit() {
    reloadData();
    super.onInit();
  }


  Future<void> searchData(String value) async {
    articleProvider.updateSearchFilter(value);
    await reloadData();
  }

  Future<void> reloadData() async {
    _articles.assignAll(await articleProvider.latestArticles(-1));
    jumpToTop();
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

  Future<void> loadMore() async {
    // 这里的触发机制有一个bug，如果只有一篇文章的时候，因为离列表的最后位置很近，所以会一直触发滑到底部加载更多文章的问题
    if (_isLoadMore == true) {
      return;
    }
    _isLoadMore = true;
    _articles
        .addAll(await articleProvider.latestArticles(_articles.last.id ?? -1));
    _isLoadMore = false;
  }


}
