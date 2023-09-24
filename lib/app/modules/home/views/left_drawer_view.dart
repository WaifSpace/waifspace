import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/modules/home/controllers/left_drawer_controller.dart';

class LeftDrawerView extends GetView<LeftDrawerController> {
  const LeftDrawerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    controller.updateArticleSourceCount();

    return Drawer(
      width: Get.width * .9,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('设置'),
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('获取所有新闻'),
              onTap: controller.fetchAllArticles,
            ),
          ),
          const Divider(
            thickness: 2,
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ListTile(
              leading: const Icon(Icons.home_filled),
              // title: Obx(() => Text('所有新闻\n(${controller.articleSourceCountInfo[-1]})')),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('所有新闻'),
                  Obx(() => Text(controller.articleSourceCountInfo[-1]!)),
                ],
              ),
              onTap: controller.showAllArticles,
              selected: controller.selectedArticle == -1,
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              children: ArticleSourceProvider.to.cacheArticleSources.map((e) {
                return ListTile(
                  leading: const Icon(Icons.web_stories),
                  // title: Obx( () => Text('${e.name!}\n(${controller.articleSourceCountInfo[e.id!] ?? '0/0'})') ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.name!),
                      Obx(() => Text(controller.articleSourceCountInfo[e.id!] ?? '0/0')),
                    ],
                  ),
                  onTap: () => controller.showArticlesFromSource(e),
                  selected: controller.selectedArticle == e.id,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
