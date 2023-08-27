import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/components/views/article_view.dart';

class ArticleListView extends GetView<ArticleListController> {
  const ArticleListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listView = Obx(() => ListView.builder(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      controller: controller.scrollController,
      itemCount: controller.articleCount(),
      itemBuilder: (_, index) {
        return ArticleView(
            article: controller.getArticle(index)
        );
      },
    ));

    return RefreshIndicator(
      onRefresh: controller.reloadData,
      child: listView,
    );
  }
}
