import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/bottom_navigation_bar_controller.dart';

class BottomNavigationBarView extends GetView<BottomNavigationBarController> {
  const BottomNavigationBarView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
        onTap: controller.selectScreen,
        currentIndex: controller.currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: '新闻',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: '应用',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '我的',
          ),
        ])
    );
  }
}
