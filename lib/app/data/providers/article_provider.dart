import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/helper/app_time.dart';
import 'package:waifspace/app/services/database_service.dart';

import '../models/article_model.dart';

class ArticleProvider {
  static String table = "articles";
  static int queryLimit = 10;
  final Database _db = Get.find<DatabaseService>().db;

  // 获取比参数 ID 新的文章
  Future<List<Article>> latestArticles(int id) async {
    List<Article> articles = [];
    List<Map<String, Object?>> articlesMap;
    if(id < 0 ) {
      articlesMap = await _db.rawQuery(
        "SELECT a.*, b.name as source_name FROM $table as a left join ${ArticleSourceProvider.table} as b on a.source_id = b.id order by a.id desc limit $queryLimit",
      );
    } else {
      articlesMap = await _db.rawQuery(
        "SELECT a.*, b.name as source_name FROM $table as a left join ${ArticleSourceProvider.table} as b on a.source_id = b.id where a.id < ? order by a.id desc limit $queryLimit",
        [id],
      );
    }

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
      table,
      columns: ['id'],
      where: 'source_id = ? and source_uid = ?',
      whereArgs: [article.sourceId, article.sourceUid],
      limit: 1,
    );

    // 如果数据库里面没有重复的这条记录，才创建并写入
    if (maps.isEmpty) {
      article.createdAt ??= AppTime.now().dbFormat();
      article.updatedAt ??= AppTime.now().dbFormat();
      // source_name 是链表查询获得的字段，保存的时候要删除
      var articleJson = article.toJson();
      articleJson.remove('source_name');
      await _db.insert(table, articleJson);
    }
  }
}
