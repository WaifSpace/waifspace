import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:waifspace/app/data/models/article_source_model.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/helper/app_time.dart';
import 'package:waifspace/app/services/database_service.dart';

class ArticleSourceProvider {
  static String table = "article_sources";

  ArticleSourceProvider._build();

  static Future<ArticleSourceProvider> build() async {
    var articleSource = ArticleSourceProvider._build();
    await articleSource.reloadArticleSources();
    return articleSource;
  }

  static ArticleSourceProvider get to => Get.find<ArticleSourceProvider>();

  final _cacheArticleSources = <ArticleSource>[].obs;
  List<ArticleSource> get cacheArticleSources => _cacheArticleSources.value;

  final Database db = Get.find<DatabaseService>().db;

  reloadArticleSources() async {
    _cacheArticleSources.assignAll(await findAll());
  }

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
      articleSource.createdAt ??= AppTime.now().dbFormat();
      articleSource.updatedAt ??= AppTime.now().dbFormat();
      articleSource.id = await db.insert(table, articleSource.toJson());
      return articleSource;
    } else {
      return ArticleSource.fromJson(maps.first);
    }
  }

  Future<List<ArticleSource>> findAll() async {
    List<ArticleSource> articleSources = [];

    var articleSourcesMap = await db.query(table);
    for (var map in articleSourcesMap) {
      articleSources.add(ArticleSource.fromJson(map));
    }
    return articleSources;
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

  Future<void> delete(int id) async {
    if(id < 0) {
      return;
    }
    logger.i('删除 source => $id');
    await db.rawDelete('delete from $table where id = ?', [id]);
    await ArticleProvider.to.deleteBySourceID(id);
    await reloadArticleSources();
  }

  Future<int> update(ArticleSource source) async {
    if(source.id == null) {
      return 0;
    }
    return await db.update(table, source.toJson(), where: 'id = ?', whereArgs: [source.id]);
  }
}

