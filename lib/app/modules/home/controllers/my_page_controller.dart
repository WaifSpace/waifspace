import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:toastification/toastification.dart';
import 'package:waifspace/app/data/models/article_source_model.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/services/ai_service.dart';
import 'package:waifspace/app/services/database_service.dart';
import 'package:waifspace/app/services/hive_service.dart';
import 'package:permission_handler/permission_handler.dart';

class MyPageController extends GetxController {
  var backupDirectory = "".obs;
  TextEditingController openAIUrlController = TextEditingController();
  TextEditingController openAITokenController = TextEditingController();

  @override
  void onInit() {
    openAIUrlController.text = AIService.to.url;
    openAITokenController.text = AIService.to.token;
    reloadBackupDirectory();
    super.onInit();
  }

  Future<void> saveSetting(BuildContext context) async {
    if (!context.mounted) return;
    logger.i("读取配置: ${openAIUrlController.text} ${openAITokenController.text}");
    await AIService.to
        .saveConfig(openAIUrlController.text, openAITokenController.text);

    showMsg("配置保存成功", context, type: ToastificationType.success);
  }

  Future<void> selectBackupDirectory(BuildContext context) async {
    if (!context.mounted) return;

    // 请求存储权限
    var status = await Permission.storage.request();
    if (status.isGranted) {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory != null) {
        try {
          HiveService.to.box.put('backupDirectory', selectedDirectory);
          backupDirectory.value = selectedDirectory; // 更新备份目录
          showMsg("备份目录设置成功", context, type: ToastificationType.success);
        } catch (e) {
          logger.e("保存备份目录失败: $e");
          showMsg("备份目录设置失败", context, type: ToastificationType.error);
        }
      } else {
        showMsg("未选择备份目录", context, type: ToastificationType.warning);
      }
    } else {
      showMsg("存储权限被拒绝", context, type: ToastificationType.error);
    }
  }

  Future<void> exportData(BuildContext context) async {
    if (!context.mounted) return;
    if (backupDirectory.value.isEmpty) {
      showMsg("请先选择备份目录", context, type: ToastificationType.warning);
      return;
    }

    try {
      final dbPath = await DatabaseService.to.getDatabasePath();
      final sourceFile = File(dbPath);
      final destinationFile =
          File(path.join(backupDirectory.value, _backupFileName()));

      await sourceFile.copy(destinationFile.path);

      showMsg("数据备份成功", context, type: ToastificationType.success);
    } catch (e) {
      logger.i("数据备份失败: $e");
      showMsg("数据备份失败", context, type: ToastificationType.error);
    }
  }

  void reloadBackupDirectory() {
    backupDirectory.value = HiveService.to.box.get('backupDirectory');
  }

  String _backupFileName() {
    final now = DateTime.now();
    final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String fileName = '${formattedTime}_waifspace_backup.db';
    return fileName;
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
