import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:waifspace/app/services/database_service.dart';

import '../models/article_model.dart';

class ArticleProvider {
  final String _table = "articles";
  final Database _db = Get.find<DatabaseService>().db;

  // 获取比参数 ID 新的文章
  Future<List<Article>> latestArticles(int id) async {
    List<Article> articles = [];
    var articlesMap = await _db.query(_table,
        where: 'id > ?',
        whereArgs: [id]);
    for(var map in articlesMap) {
      articles.add(Article.fromJson(map));
    }
    return articles;
  }

  create(Article article) {
    article.createdAt ??= DateTime.now().toString();
    article.updatedAt ??= DateTime.now().toString();
    _db.insert(_table, article.toJson());
  }
}
