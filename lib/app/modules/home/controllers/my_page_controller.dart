import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/data/models/article_source_model.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/helper/app_time.dart';
import 'package:waifspace/app/services/ai_service.dart';
import 'package:waifspace/app/services/cubox_service.dart';
import 'package:waifspace/app/services/rss_service.dart';

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

    debugApp();
  }

  Future<void> debugApp() async {
    if (isProduction) {
      return;
    }
    var url = await RssService.to.getImageUrlFromUrl("https://www.bbc.co.uk/news/world-67396773?at_medium=RSS&at_campaign=KARANGA");
    logger.i("获取到的图片是 $url");
  }

  Future<void> exportSettings() async {
    var sources = await ArticleSourceProvider.to.findAll();
    var settings = {
      "cubox_url": CuboxService.url,
      "openai_url": AIService.to.url,
      "openai_token": AIService.to.token,
      "article_sources": sources.map((e) => e.toJson()).toList(),
    };
    var settingsStr = base64Encode(utf8.encode(jsonEncode(settings)));
    logger.i("导出配置到剪切板: $settingsStr");
    Clipboard.setData(ClipboardData(text: settingsStr));
    showMsg("导出配置到剪切板成功");
  }

  Future<void> importSettings() async {
    var value = await Clipboard.getData(Clipboard.kTextPlain);
    if (value != null) {
      var settingsStr = base64Decode(value.text ?? "");
      var settings = jsonDecode(utf8.decode(settingsStr));

      // TODO: 需要加上一些配置检查，确保格式是正确的
      if (settings["cubox_url"] == null || settings["cubox_url"] == "") {
        showMsg("配置信息格式错误");
        return;
      }
      CuboxService.url = settings["cubox_url"];
      AIService.to.url = settings["openai_url"];
      AIService.to.token = settings["openai_token"];
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
      showMsg("从剪切板导入配置成功");
    } else {
      showMsg("读取剪切板失败");
    }
  }
}
