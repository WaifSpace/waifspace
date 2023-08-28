import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/components/views/article_list_view.dart';
import 'package:waifspace/app/components/views/bottom_navigation_bar_view.dart';
import 'package:waifspace/app/components/views/homepage_appbar_view.dart';
import 'package:waifspace/app/modules/apps/views/apps_view.dart';
import 'package:waifspace/app/modules/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: HomepageAppbarView(
        onDoubleTap: controller.onDoubleTap,
      ),
      bottomNavigationBar: const BottomNavigationBarView(),
      body: IndexedStack(
        alignment: Alignment.center,
        index: controller.currentNavIndex,
        children: const [
          ArticleListView(),
          AppsView(),
        ],
      ),
    ));// return const Scaffold(
  }
}