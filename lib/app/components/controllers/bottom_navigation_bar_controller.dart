import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/homepage_appbar_controller.dart';

class BottomNavigationBarController extends GetxController {
  final _currentIndex = 0.obs;
  var appbarController = Get.find<HomepageAppbarController>();

  void selectScreen(int index) {
    _currentIndex.value = index;
    appbarController.changeIndex(index);
  }

  int get currentIndex => _currentIndex.value;
}
