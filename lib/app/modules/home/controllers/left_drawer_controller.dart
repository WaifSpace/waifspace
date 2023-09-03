import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/data/models/article_source_model.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/modules/home/controllers/home_controller.dart';

class LeftDrawerController extends GetxController {
  static LeftDrawerController get to => Get.find<LeftDrawerController>();

  void fetchAllArticles() {
    HomeController.to.fetchAllArticles();
    Get.back();
  }

  void showAllArticles() {
    ArticleProvider.to.updateSourceIDFilter(null, '');
    ArticleListController.to.reloadData();
    Get.back();
  }

  void showArticlesFromSource(ArticleSource source) {
    ArticleProvider.to.updateSourceIDFilter(source.id, source.name!);
    ArticleListController.to.reloadData();
    Get.back();
  }
}
