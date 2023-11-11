import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/components/views/article_view.dart';

class ArticleListView extends GetView<ArticleListController> {
  const ArticleListView({super.key});

  @override
  Widget build(BuildContext context) {
    var listView = Obx(() => ListView.builder(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      controller: controller.scrollController,
      itemCount: controller.articleCount(),
      itemBuilder: (_, index) {
        if(index == controller.articleCount() - 1) {
          controller.loadMore();
        }
        return ArticleView(
            article: controller.getArticle(index)
        );
      },
    ));

    var refreshIndicator = RefreshIndicator(
      onRefresh: controller.reloadData,
      child: listView,
    );

    var searchInput = Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextField(
        controller: controller.textEditingController,
        onSubmitted: controller.searchData,
        decoration: const InputDecoration(
            hintText: "Search",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))
            )
        ),
      ),
    );

    return Column(
      children: [
        Obx(() {
          if(controller.showSearch.value) {
            return searchInput;
          } else {
            return Container();
          }
        }),
        Expanded(
          child: refreshIndicator,
        ),
      ],
    );
  }
}
