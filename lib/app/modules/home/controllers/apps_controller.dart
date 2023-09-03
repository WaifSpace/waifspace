import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/dream_browser_controller.dart';

class AppsController extends GetxController {

  static AppsController get to => Get.find<AppsController>();

  DreamBrowserController dreamBrowserController = Get.find<DreamBrowserController>();

  Future<bool> onWillPop() async {
    dreamBrowserController.goBack();
    return false;
  }
}
