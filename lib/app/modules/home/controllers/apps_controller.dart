import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/dream_browser_controller.dart';

class AppsController extends GetxController {

  static AppsController get to => Get.find<AppsController>();

  DreamBrowserController dreamBrowserController = Get.find<DreamBrowserController>();

  Future<bool> onWillPop() async {
    dreamBrowserController.goBack();
    return true; // 等于true的时候会把事件持续往下传, 确保每个组件都能做出自己正确的响应
  }
}
