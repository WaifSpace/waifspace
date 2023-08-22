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
    var articlesMap = await _db.query(_table, where: 'id > ?', whereArgs: [id]);
    for (var map in articlesMap) {
      articles.add(Article.fromJson(map));
    }
    return articles;
  }

  create(Article article) async {
    // 如果内容为空，就不存入数据库
    if (article.title == null &&
        article.sourceId == null &&
        article.sourceUid == null) {
      return;
    }
    // 判断数据库里是否存在
    var maps = await _db.query(
      _table,
      columns: ['id'],
      where: 'source_id = ? and source_uid = ?',
      whereArgs: [article.sourceId, article.sourceUid],
      limit: 1,
    );

    // 如果数据库里面没有重复的这条记录，才创建并写入
    if (maps.isEmpty) {
      article.createdAt ??= DateTime.now().toString();
      article.updatedAt ??= DateTime.now().toString();
      _db.insert(_table, article.toJson());
    }
  }
}
