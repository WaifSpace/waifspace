import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:waifspace/app/components/views/article_list_view.dart';
import 'package:waifspace/app/components/views/homepage_appbar_view.dart';
import 'package:waifspace/app/modules/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: HomepageAppbarView(),
        body: ArticleListView()
    );    // return const Scaffold(

    //   appBar: HomepageAppbarView(),
    //   // bottomNavigationBar: BottomNavigationBarView(),
    //   body: IndexedStack(
    //     alignment: Alignment.center,
    //     children: [
    //       ArticleListView(),
    //     ],
    //   ),
    // );
  }
}
