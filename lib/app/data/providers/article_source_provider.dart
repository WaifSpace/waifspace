import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:waifspace/app/data/models/article_source_model.dart';
import 'package:waifspace/app/services/database_service.dart';

class ArticleSourceProvider {
  final String _table = "article_sources";
  final Database db = Get.find<DatabaseService>().db;

  Future<ArticleSource> create(ArticleSource articleSource) async {

    // 判断数据库里面是否已经存在这个URL的订阅
    var maps = await db.query(
      _table,
      columns: ['id'],
      where: 'url = ?',
      whereArgs: [articleSource.url]
    );

    // 只有数据库里面不存在的时候才保存
    if(maps.isEmpty) {
      articleSource.createdAt ??= DateTime.now().toString();
      articleSource.updatedAt ??= DateTime.now().toString();
      articleSource.id = await db.insert(_table, articleSource.toJson());
      return articleSource;
    } else {
      return ArticleSource.fromJson(maps.first);
    }
  }
}

