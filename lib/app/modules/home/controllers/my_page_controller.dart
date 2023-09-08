import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/services/hive_service.dart';

class MyPageController extends GetxController {
  TextEditingController cuboxUrlController = TextEditingController();

  @override
  void onInit() {
    cuboxUrlController.text = HiveService.to.box.get('cubox_url', defaultValue: '');
  }

  void saveSetting() {
    HiveService.to.box.put("cubox_url", cuboxUrlController.text);
  }
}
