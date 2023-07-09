import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/homepage_appbar_controller.dart';

class HomepageAppbarView extends GetView<HomepageAppbarController> implements PreferredSizeWidget {
  const HomepageAppbarView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Obx(()=> Text(controller.title)),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {

        },
      ),
      actions: [
        IconButton(
          onPressed: () {

          },
          icon: const Icon(Icons.save),
        ),
        IconButton(
          onPressed: () {

          },
          icon: const Icon(Icons.share),
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
