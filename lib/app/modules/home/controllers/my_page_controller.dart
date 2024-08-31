import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import 'package:waifspace/app/data/models/article_source_model.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/services/ai_service.dart';

class MyPageController extends GetxController {
  TextEditingController openAIUrlController = TextEditingController();
  TextEditingController openAITokenController = TextEditingController();

  @override
  void onInit() {
    openAIUrlController.text = AIService.to.url;
    openAITokenController.text = AIService.to.token;
    super.onInit();
  }

  Future<void> saveSetting(BuildContext context) async {
    logger.i("读取配置: ${openAIUrlController.text} ${openAITokenController.text}");
    await AIService.to
        .saveConfig(openAIUrlController.text, openAITokenController.text);

    showMsg("配置保存成功", context, type: ToastificationType.success);
  }

  Future<void> exportSettings(BuildContext context) async {
    var sources = await ArticleSourceProvider.to.findAll();
    var settings = {
      "openai_url": AIService.to.url,
      "openai_token": AIService.to.token,
      "article_sources": sources.map((e) => e.toJson()).toList(),
    };
    var settingsStr = base64Encode(utf8.encode(jsonEncode(settings)));
    logger.i("导出配置到剪切板: $settingsStr");
    Clipboard.setData(ClipboardData(text: settingsStr));
    if (!context.mounted) return;
    showMsg("导出配置到剪切板成功", context);
  }

  Future<void> importSettings(BuildContext context) async {
    var value = await Clipboard.getData(Clipboard.kTextPlain);
    if (value != null) {
      var settingsStr = base64Decode(value.text ?? "");
      var settings = jsonDecode(utf8.decode(settingsStr));

      // 检查配置信息格式是否正确
      if (settings["openai_url"] == null || settings["openai_token"] == "") {
        if (!context.mounted) return;
        showMsg("配置信息格式错误", context, type: ToastificationType.error);
        return;
      }

      // 导入配置信息
      openAIUrlController.text = settings["openai_url"];
      openAITokenController.text = settings["openai_token"];

      await saveSetting(context); // 保存配置信息

      // 导入文章源信息
      for (final source in settings["article_sources"]) {
        await ArticleSourceProvider.to.create(ArticleSource(
          name: source["name"],
          description: source["description"],
          url: source["url"],
          homepage: source["homepage"],
          type: source["type"],
          image: source["image"],
        ));
      }
      if (!context.mounted) return;
      showMsg("从剪切板导入配置成功", context);
    } else {
      if (!context.mounted) return;
      showMsg("读取剪切板失败", context, type: ToastificationType.error);
    }
  }
}
