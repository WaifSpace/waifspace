import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:waifspace/app/data/models/article_source_model.dart';
import 'package:waifspace/app/helper/app_time.dart';
import 'package:waifspace/app/services/database_service.dart';

class ArticleSourceProvider {
  static String table = "article_sources";
  final Database db = Get.find<DatabaseService>().db;

  // ArticleSource 添加 lang 字段，用来判断这个rss的语言, 例如 feed.language
  Future<ArticleSource> create(ArticleSource articleSource) async {

    // 判断数据库里面是否已经存在这个URL的订阅
    var maps = await db.query(
      table,
      columns: ['id'],
      where: 'url = ?',
      whereArgs: [articleSource.url]
    );

    // 只有数据库里面不存在的时候才保存
    if(maps.isEmpty) {
      articleSource.createdAt ??= AppTime.now().dbFormat();;
      articleSource.updatedAt ??= AppTime.now().dbFormat();;
      articleSource.id = await db.insert(table, articleSource.toJson());
      return articleSource;
    } else {
      return ArticleSource.fromJson(maps.first);
    }
  }

  Future<ArticleSource?> findByID(int id) async {
    List<Map<String, dynamic>> maps = await db.query(table,
      where: 'id = ?',
      whereArgs: [id],
    );
    if(maps.isNotEmpty) {
      return ArticleSource.fromJson(maps.first);
    }
    return null;
  }
}

