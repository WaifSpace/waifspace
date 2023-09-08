import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:waifspace/app/modules/home/controllers/my_page_controller.dart';

class MyPageView extends GetView<MyPageController> {
  const MyPageView({Key? key}) : super(key: key);

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
                  hintText: '输入Cubox调用地址',
                  prefixIcon: Icon(Icons.bookmark_add))),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(30, 15, 30, 15),
          child: ElevatedButton.icon(
              onPressed: controller.saveSetting,
              icon: const Icon(Icons.save),
              label: const Text('保存配置')),
        ),
      ],
    );
  }
}
