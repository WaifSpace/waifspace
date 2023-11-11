import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/modules/home/controllers/left_drawer_controller.dart';

class LeftDrawerView extends GetView<LeftDrawerController> {
  const LeftDrawerView({super.key});

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
            child: Slidable(
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) => {controller.makeAllRead()},
                    backgroundColor: const Color(0xFF21B7CA),
                    foregroundColor: Colors.white,
                    icon: Icons.mark_chat_read,
                    label: '已读',
                  ),
                ],
              ),
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
          ),
          Expanded(
            child: Obx(() {
              return ListView(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                children: ArticleSourceProvider.to.cacheArticleSources
                    .map((articleSource) {
                  return Slidable(
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) =>
                              {controller.removeSource(articleSource.id)},
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: '删除',
                        ),
                        SlidableAction(
                          onPressed: (context) =>
                              {controller.makeSourceRead(articleSource.id)},
                          backgroundColor: const Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.mark_chat_read,
                          label: '已读',
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.web_stories),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(articleSource.name!),
                          Obx(() => Text(controller
                                  .articleSourceCountInfo[articleSource.id!] ??
                              '0/0')),
                        ],
                      ),
                      onTap: () =>
                          controller.showArticlesFromSource(articleSource),
                      selected: controller.selectedArticle == articleSource.id,
                    ),
                  );
                }).toList(),
              );
            }),
          ),
        ],
      ),
    );
  }
}
