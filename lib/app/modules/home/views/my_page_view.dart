import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:waifspace/app/modules/home/controllers/my_page_controller.dart';

class MyPageView extends GetView<MyPageController> {
  const MyPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(30, 15, 30, 15),
          child: TextField(
              controller: controller.openAIUrlController,
              decoration: const InputDecoration(
                  labelText: 'OpenAI API URL',
                  hintText: '输入 OpenAI 接口地址',
                  prefixIcon: Icon(CupertinoIcons.rays))),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(30, 15, 30, 15),
          child: TextField(
              controller: controller.openAITokenController,
              decoration: const InputDecoration(
                  labelText: 'OpenAI API token',
                  hintText: '输入 OpenAI token',
                  prefixIcon: Icon(Icons.security))),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(30, 15, 30, 15),
          child: Column(children: [
            ElevatedButton.icon(
                onPressed: () => controller.saveSetting(context),
                icon: const Icon(Icons.save),
                label: const Text('保存配置')),
          ]),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(30, 15, 30, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => Text(
                    '备份目录: ${controller.backupDirectory ?? '未选择'}',
                    style: const TextStyle(fontSize: 16),
                  )),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => controller.selectBackupDirectory(context),
                    icon: const Icon(Icons.folder_open),
                    label: const Text('选择备份目录'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => controller.exportData(context),
                    icon: const Icon(Icons.backup_sharp),
                    label: const Text('备份数据'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
