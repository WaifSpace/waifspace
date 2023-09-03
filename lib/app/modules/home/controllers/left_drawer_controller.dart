import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/data/models/article_source_model.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/modules/home/controllers/home_controller.dart';

class LeftDrawerController extends GetxController {
  static LeftDrawerController get to => Get.find<LeftDrawerController>();

  var selectedArticle = -1.obs;

  void fetchAllArticles() {
    selectedArticle = -1;
    HomeController.to.fetchAllArticles();
    HomeController.to.closeDrawer();
  }

  void showAllArticles() {
    selectedArticle = -1;
    ArticleProvider.to.updateSourceIDFilter(null, '');
    ArticleListController.to.reloadData();
    HomeController.to.closeDrawer();
  }

  void showArticlesFromSource(ArticleSource source) {
    selectedArticle = source.id!;
    ArticleProvider.to.updateSourceIDFilter(source.id, source.name!);
    ArticleListController.to.reloadData();
    HomeController.to.closeDrawer();
    // Get.back();
  }
}
