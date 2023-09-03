import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/dream_browser_controller.dart';

class AppsController extends GetxController {
  DreamBrowserController dreamBrowserController = Get.find<DreamBrowserController>();

  Future<bool> onWillPop() async {
    dreamBrowserController.goBack();
    return false;
  }
}
