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
              controller: controller.cuboxUrlController,
              decoration: const InputDecoration(
                  labelText: 'Cubox API URL',
                  hintText: '输入 Cubox 接口地址',
                  prefixIcon: Icon(Icons.bookmark_add))),
        ),
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
        // Container(
        //   margin: const EdgeInsets.fromLTRB(30, 15, 30, 15),
        //   child: TextField(
        //       controller: controller.deeplxUrlController,
        //       decoration: const InputDecoration(
        //           labelText: 'Deeplx Service url',
        //           hintText: '输入 Deeplx 服务地址',
        //           prefixIcon: Icon(Icons.security))),
        // ),
        // Container(
        //   margin: const EdgeInsets.fromLTRB(30, 15, 30, 15),
        //   child: TextField(
        //       controller: controller.deeplxCodeController,
        //       decoration: const InputDecoration(
        //           labelText: 'Deeplx Service code',
        //           hintText: '输入 Deeplx 认证码',
        //           prefixIcon: Icon(Icons.security))),
        // ),
        Container(
            margin: const EdgeInsets.fromLTRB(30, 15, 30, 15),
            child: Column(
              children: [
                ElevatedButton.icon(
                    onPressed: controller.saveSetting,
                    icon: const Icon(Icons.save),
                    label: const Text('保存配置')),
                ElevatedButton.icon(
                    onPressed: controller.exportSettings,
                    icon: const Icon(Icons.save),
                    label: const Text('导出配置到剪切板')),
                ElevatedButton.icon(
                    onPressed: controller.importSettings,
                    icon: const Icon(Icons.save),
                    label: const Text('从剪切板导入配置')),
              ],
            )),
      ],
    );
  }
}
