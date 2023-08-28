import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/homepage_appbar_controller.dart';

class HomepageAppbarView extends GetView<HomepageAppbarController>
    implements PreferredSizeWidget {

  final VoidCallback onDoubleTap;

  const HomepageAppbarView({Key? key, required this.onDoubleTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: AppBar(
        title: Obx(() => Text("${controller.title}")),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: controller.reload,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var results =
                  await showTextInputDialog(context: context, textFields: [
                const DialogTextField(
                  hintText: '地址',
                ),
                const DialogTextField(
                  hintText: '名字',
                ),
              ]);
              if (results != null) {
                controller.add(results.first, results.last);
              }
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
