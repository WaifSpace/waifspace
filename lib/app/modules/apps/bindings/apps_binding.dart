import 'package:get/get.dart';

import '../controllers/apps_controller.dart';

class AppsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppsController>(
      () => AppsController(),
    );
  }
}
