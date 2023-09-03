import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/components/views/article_list_view.dart';
import 'package:waifspace/app/components/views/bottom_navigation_bar_view.dart';
import 'package:waifspace/app/components/views/homepage_appbar_view.dart';
import 'package:waifspace/app/modules/home/views/apps_view.dart';
import 'package:waifspace/app/modules/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var drawer = Drawer(
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
              onTap: () {
                controller.fetchAllArticles();
                Get.back();
              },
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
              onTap: () {
                controller.articleProvider.updateSourceIDFilter(null, '');
                controller.articleListController.reloadData();
                Get.back();
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                children: controller.cacheArticleSources.value.map((e) {
                  return ListTile(
                    leading: const Icon(Icons.web_stories),
                    title: Text(e.name!),
                    onTap: () {
                      controller.articleProvider.updateSourceIDFilter(e.id, e.name!);
                      controller.articleListController.reloadData();
                      Get.back();
                    },
                  );
                }).toList(),
              );
            }),
          ),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: Scaffold(
        appBar: HomepageAppbarView(
          onDoubleTap: controller.onDoubleTap,
        ),
        drawer: drawer,
        bottomNavigationBar: const BottomNavigationBarView(),
        body: Obx(() => IndexedStack(
          alignment: Alignment.center,
          index: controller.currentNavIndex,
          children: const [
            ArticleListView(),
            AppsView(),
          ],
        )),
      ),
    );// return const Scaffold(
  }
}