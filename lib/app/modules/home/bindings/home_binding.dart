import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/article_controller.dart';
import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/components/controllers/bottom_navigation_bar_controller.dart';
import 'package:waifspace/app/components/controllers/dream_browser_controller.dart';
import 'package:waifspace/app/components/controllers/homepage_appbar_controller.dart';
import 'package:waifspace/app/modules/home/controllers/apps_controller.dart';
import 'package:waifspace/app/modules/home/controllers/left_drawer_controller.dart';
import 'package:waifspace/app/modules/home/controllers/my_page_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Binding {

  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => HomeController()),
      Bind.lazyPut(() => AppsController()),
      Bind.lazyPut(() => HomepageAppbarController()),
      Bind.lazyPut(() => BottomNavigationBarController()),
      Bind.lazyPut(() => ArticleListController()),
      Bind.lazyPut(() => ArticleController()),
      Bind.lazyPut(() => DreamBrowserController()),
      Bind.lazyPut(() => LeftDrawerController()),
      Bind.lazyPut(() => MyPageController()),
    ];
  }
}
