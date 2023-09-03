import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/components/views/article_list_view.dart';
import 'package:waifspace/app/components/views/bottom_navigation_bar_view.dart';
import 'package:waifspace/app/components/views/homepage_appbar_view.dart';
import 'package:waifspace/app/modules/home/views/apps_view.dart';
import 'package:waifspace/app/modules/home/controllers/home_controller.dart';
import 'package:waifspace/app/modules/home/views/left_drawer_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: Scaffold(
        key: controller.scaffoldKey,
        appBar: HomepageAppbarView(
          onDoubleTap: controller.onDoubleTap,
        ),
        drawer: const LeftDrawerView(),
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