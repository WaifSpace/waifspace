import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/components/controllers/bottom_navigation_bar_controller.dart';
import 'package:waifspace/app/components/controllers/homepage_appbar_controller.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/services/ai_service.dart';
import 'package:waifspace/app/services/rss_service.dart';

class HomepageAppbarView extends GetView<HomepageAppbarController>
    implements PreferredSizeWidget {
  final VoidCallback onDoubleTap;
  const HomepageAppbarView({super.key, required this.onDoubleTap});
  @override
  Widget build(BuildContext context) {
    var titleInfo = Obx(() {
      if (RssService.to.progress <= 0) {
        return GestureDetector(
          onDoubleTap: onDoubleTap,
          child: Text(controller.title()),
        );
      } else {
        return LinearProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: const AlwaysStoppedAnimation(Colors.blue),
          value: RssService.to.progress.value,
        );
      }
    });

    var addNewsBtn = IconButton(
      onPressed: () async {
        var results = await showTextInputDialog(context: context, textFields: [
          const DialogTextField(
            hintText: '地址',
          ),
          const DialogTextField(
            hintText: '名字',
          ),
        ]);
        if (results != null) {
          if (!context.mounted) return;
          controller.add(results.first, results.last, context);
        }
      },
      icon: const Icon(Icons.add),
    );

    var searchNewsBtn = IconButton(
      onPressed: () {
        ArticleListController.to.showSearch.value =
            !ArticleListController.to.showSearch.value;
      },
      icon: const Icon(Icons.search),
    );

    // var appBookmarkBtn = IconButton(
    //   onPressed: controller.doWebScript,
    //   icon: const Icon(Icons.bookmark_add),
    // );

    var debugIcon = IconButton(
      onPressed: () {
        // RssService.to.fetchAllLogos();
        logger.i("点击 debug");
        AIService.to.translate("hello world");
      },
      icon: const Icon(Icons.directions_run),
    );

    return AppBar(
      title: titleInfo,
      centerTitle: true,
      actions: [
        !isProduction ? debugIcon : Container(),
        Obx(() => BottomNavigationBarController.to.currentIndex == 0
            ? addNewsBtn
            : Container()),
        Obx(() => BottomNavigationBarController.to.currentIndex == 0
            ? searchNewsBtn
            : Container()),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
