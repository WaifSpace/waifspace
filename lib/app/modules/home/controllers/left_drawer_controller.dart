import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/data/models/article_source_model.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/helper/app_time.dart';
import 'package:waifspace/app/modules/home/controllers/home_controller.dart';

class LeftDrawerController extends GetxController {
  static LeftDrawerController get to => Get.find<LeftDrawerController>();

  var selectedArticle = -2.obs;
  var articleSourceCountInfo = <int, String>{}.obs;

  void fetchAllArticles() {
    // RssService.to.fetchAllLogos();
    selectedArticle = -1;
    HomeController.to.fetchAllArticles();
    HomeController.to.closeDrawer();
  }

  void showAllArticles() {
    selectedArticle = -1;
    ArticleProvider.to.updateSourceIDFilter(null, '');
    ArticleProvider.to.updatePubDatedFilter(null);
    ArticleListController.to.reloadData();
    HomeController.to.closeDrawer();
  }

  void show24HoursArticles() {
    selectedArticle = -2;
    ArticleProvider.to.updatePubDatedFilter(AppTime.fromNow(24).dbFormat());
    ArticleListController.to.reloadData();
    HomeController.to.closeDrawer();
  }

  void showArticlesFromSource(ArticleSource source) {
    selectedArticle = source.id!;
    ArticleProvider.to.updatePubDatedFilter(null);
    ArticleProvider.to.updateSourceIDFilter(source.id, source.name!);
    ArticleListController.to.reloadData();
    HomeController.to.closeDrawer();
    // Get.back();
  }

  Future<void> updateArticleSourceCount() async {
    logger.i("重新加载文章的统计数量 => [Future<void> updateArticleSourceCount() async]");
    var countInfo = await ArticleProvider.to.sourceCount();
    var unreadCountInfo= await ArticleProvider.to.sourceUnreadCount();

    num allArticleCount = 0;
    num allUnreadArticleCount = 0;
    var info = <int, String>{-1: ''}; // -1 的索引用来保存所有文章的数量和未读的数量
    countInfo.forEach((key, value) {
      allArticleCount += value;
      allUnreadArticleCount += unreadCountInfo[key] ?? 0;
      info[key] = '${unreadCountInfo[key] ?? 0}/$value';
    });
    info[-1] = '$allUnreadArticleCount/$allArticleCount'; // -1 的索引用来保存所有文章的数量和未读的数量

    info[-2] = '${await ArticleProvider.to.source24HoursUnreadCount()}/${await ArticleProvider.to.source24HoursCount()}'; // -2 的索引用来保存24小时文章的数量和未读的数量
    articleSourceCountInfo.assignAll(info);
  }

  Future<void> makeAllRead() async {
    await ArticleProvider.to.makeAllRead();
    await updateArticleSourceCount();
  }

  Future<void> make24HoursRead() async {
    await ArticleProvider.to.make24HoursRead();
    await updateArticleSourceCount();
  }

  Future<void> makeSourceRead(int? sourceID) async {
    if(sourceID == null || sourceID < 0) {
      return;
    }
    await ArticleProvider.to.makeAllReadBySourceID(sourceID);
    await updateArticleSourceCount();
  }

  Future<void> updateSourceInfo(ArticleSource source) async {
    await ArticleSourceProvider.to.update(source);
  }

  void removeSource(int? sourceID) {
    if(sourceID == null || sourceID < 0) {
      return;
    }
    ArticleSourceProvider.to.delete(sourceID);
  }
}
