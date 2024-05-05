import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/bottom_navigation_bar_controller.dart';
import 'package:waifspace/app/components/web_logo/view.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/modules/home/controllers/home_controller.dart';
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
          // 操作按钮
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
            child: Row(
              children: [
                IconButton(
                  iconSize: 30,
                  icon: const FaIcon(FontAwesomeIcons.newspaper),
                  onPressed: () {
                    BottomNavigationBarController.to.selectScreen(0);
                    HomeController.to.closeDrawer();
                  },
                ),
                IconButton(
                  iconSize: 30,
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    BottomNavigationBarController.to.selectScreen(1);
                    HomeController.to.closeDrawer();
                  },
                ),
                IconButton(
                  iconSize: 30,
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    BottomNavigationBarController.to.selectScreen(2);
                    HomeController.to.closeDrawer();
                  },
                ),
                Expanded(
                  child: Container(),
                ),
                IconButton(
                  iconSize: 30,
                  icon: const Icon(Icons.refresh),
                  onPressed: controller.fetchAllArticles,
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          // 查看24小时新闻
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Slidable(
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) => {controller.make24HoursRead()},
                    backgroundColor: const Color(0xFF21B7CA),
                    foregroundColor: Colors.white,
                    icon: Icons.mark_chat_read,
                    label: '已读',
                  ),
                ],
              ),
              child: ListTile(
                leading: const Icon(Icons.sunny, size: 35),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('24小时新闻'),
                    Obx(() => Text(controller.articleSourceCountInfo[-2] ?? "")),
                  ],
                ),
                onTap: controller.show24HoursArticles,
                selected: controller.selectedArticle == -2,
              ),
            ),
          ),
          // 查看所有新闻
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
                leading: const Icon(Icons.home_filled, size: 35),
                // title: Obx(() => Text('所有新闻\n(${controller.articleSourceCountInfo[-1]})')),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('所有新闻'),
                    Obx(() => Text(controller.articleSourceCountInfo[-1] ?? "")),
                  ],
                ),
                onTap: controller.showAllArticles,
                selected: controller.selectedArticle == -1,
              ),
            ),
          ),
          // 订阅源列表
          Expanded(
            child: Obx(() {
              return ListView(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                children: ArticleSourceProvider.to.cacheArticleSources
                    .map((articleSource) {
                  return Slidable(
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: 0.7,
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
                        SlidableAction(
                          onPressed: (context) async {
                            var results = await showTextInputDialog(context: context, textFields: [
                              DialogTextField(
                                hintText: '地址',
                                initialText: articleSource.url,
                              ),
                              DialogTextField(
                                hintText: '名字',
                                initialText: articleSource.name,
                              ),
                            ]);
                            if (results != null) {
                              articleSource.name = results.last;
                              articleSource.url = results.first;
                              controller.updateSourceInfo(articleSource);
                            }
                          },
                          backgroundColor: const Color(0xFF21CA8F),
                          foregroundColor: Colors.white,
                          icon: Icons.drive_file_rename_outline,
                          label: '改名',
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading:
                          WebLogoComponent(url: articleSource.homepage ?? ""),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(articleSource.name!),
                          ),
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
