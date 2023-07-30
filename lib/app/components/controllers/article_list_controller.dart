import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:waifspace/app/data/models/article_model.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';

class ArticleListController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final List<Article> _articles = [];
  ArticleProvider articleProvider = Get.find<ArticleProvider>();

  @override
  void onInit() {
    reloadData();
    super.onInit();
  }

  Future<void> reloadData() async {
    _articles.clear();
    _articles.addAll(await articleProvider.latestArticles(-1));
  }

  Article getArticle(index) {
    return _articles[index];
  }

  int articleCount() {
    return _articles.length;
  }
}
