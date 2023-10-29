import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/services/ai_service.dart';
import 'package:waifspace/app/services/cubox_service.dart';

class MyPageController extends GetxController {
  TextEditingController cuboxUrlController = TextEditingController();
  TextEditingController openAIUrlController = TextEditingController();
  TextEditingController openAITokenController = TextEditingController();

  @override
  void onInit() {
    cuboxUrlController.text = CuboxService.url;
    openAIUrlController.text = AIService.to.url;
    openAITokenController.text = AIService.to.token;
  }

  void saveSetting() {
    CuboxService.url = cuboxUrlController.text;
    AIService.to.url = openAIUrlController.text;
    AIService.to.token = openAITokenController.text;
  }
}
