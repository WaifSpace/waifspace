import 'package:get/get.dart';

class BottomNavigationBarController extends GetxController {
  final _currentIndex = 0.obs;

  void selectScreen(int index) {
    _currentIndex.value = index;
  }

  int get currentIndex => _currentIndex.value;
}
