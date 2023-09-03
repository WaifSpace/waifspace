import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/dream_browser_controller.dart';

class AppsController extends GetxController {
  static AppsController get to => Get.find<AppsController>();

  Future<String> get title async => await DreamBrowserController.to.webViewController?.getTitle() ?? "Twitter";
}
