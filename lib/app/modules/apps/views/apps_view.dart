import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/components/views/dream_browser_view.dart';
import '../controllers/apps_controller.dart';

class AppsView extends GetView<AppsController> {
  const AppsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        DreamBrowserView(),
      ],
    );
  }
}
