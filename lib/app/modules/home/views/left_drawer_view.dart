import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/modules/home/controllers/left_drawer_controller.dart';

class LeftDrawerView extends GetView<LeftDrawerController> {

  const LeftDrawerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircleAvatar(
                  child: Text(
                    'W',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('设置'),
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListTile(
              leading: const Icon(Icons.home_filled),
              title: const Text('所有新闻'),
              onTap: controller.showAllArticles,
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                children: ArticleSourceProvider.to.cacheArticleSources.map((e) {
                  return ListTile(
                    leading: const Icon(Icons.web_stories),
                    title: Text(e.name!),
                    onTap: () => controller.showArticlesFromSource(e),
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
