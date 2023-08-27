import 'package:get/get.dart';
import 'package:waifspace/app/data/models/article_model.dart';
import 'package:waifspace/app/helper/app_time.dart';

class ArticleController extends GetxController {
  String articleTime(Article article) {
    if(article.pubDate != null && article.pubDate != "") {
      return AppTime.parse(article.pubDate!).viewFormat();
    }
    if(article.createdAt != null && article.createdAt != "") {
      return AppTime.parse(article.createdAt!).viewFormat();
    }
    return "";
  }
}
