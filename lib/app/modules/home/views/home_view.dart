import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:waifspace/app/components/views/bottom_navigation_bar_view.dart';
import 'package:waifspace/app/components/views/homepage_appbar_view.dart';
import 'package:waifspace/app/modules/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomepageAppbarView(),
      bottomNavigationBar: const BottomNavigationBarView(),
      body: Center(
        child: GestureDetector(
          onTap: () {
            controller.increment();
          },
          child: const Text(
            'HomeView is working',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
