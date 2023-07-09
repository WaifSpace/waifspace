import 'package:get/get.dart';

class HomepageAppbarController extends GetxController {
  final _titles = ['热点新闻', '我的'];
  final _currentIndex = 0.obs;

  void changeIndex(int index) => _currentIndex.value = index;

  String get title => _titles[_currentIndex.value];
}
