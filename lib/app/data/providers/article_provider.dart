import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/helper/app_time.dart';
import 'package:waifspace/app/helper/sql_builder.dart';
import 'package:waifspace/app/services/ai_service.dart';
import 'package:waifspace/app/services/database_service.dart';
import '../models/article_model.dart';

class ArticleProvider {
  static String table = "articles";
  static const int _queryLimit = 20;

  ArticleProvider._build();

  static Future<ArticleProvider> build() async {
    var articleProvider = ArticleProvider._build();
    return articleProvider;
  }

  static ArticleProvider get to => Get.find<ArticleProvider>();

  var filterSourceName = "".obs; // 用于显示过滤的source的名字

  String? _searchCondition; // 用于搜索的条件，会根据 title 和 content 字段查询

  int? _sourceIDCondition; // 用于根据数据源来显示
  int? get sourceIDCondition => _sourceIDCondition;

  final Database _db = Get.find<DatabaseService>().db;

  // 获取比参数 ID 新的文章
  Future<List<Article>> latestArticles(int id) async {
    List<Article> articles = [];

    var sqlBuilder = SqlBuilder("SELECT a.*, b.name as source_name FROM $table as a left join ${ArticleSourceProvider.table} as b on a.source_id = b.id");
    sqlBuilder.limit(_queryLimit)
        .where("source_id = ?", [_sourceIDCondition])
        .orderBy("a.id", desc: true)
        .like('(a.title like ? or a.content like ?)', [_searchCondition, _searchCondition]);
    if(id > 0) {
      sqlBuilder.where("a.id < ?", [id]);
    }

    var (sql, arguments) = sqlBuilder.done();
    List<Map<String, Object?>> articlesMap = await _db.rawQuery(
      sql,
      arguments,
    );

    for (var map in articlesMap) {
      articles.add(Article.fromJson(map));
    }
    return articles;
  }

  void updateSourceIDFilter(int? sourceID, String sourceName) {
    _sourceIDCondition = sourceID;
    filterSourceName.value = sourceName;
  }

  void updateSearchFilter(String text) {
    _searchCondition = text;
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

      if(!isChinese(article.title ?? '')) { // 只对英文处理
        article.cnTitle = await AIService.to.readAndTranslate(article.title ?? '', maxLength: 20);
      }

      // 在保存进数据库的时候，调用chatgpt 提取文章的内容
      var textContent = htmlToText(article.content ?? '');
      if(!isChinese(textContent)) { // 只对英文处理
        article.cnContent = await AIService.to.readAndTranslate(textContent);
      }

      article.createdAt ??= AppTime.now().dbFormat();
      article.updatedAt ??= AppTime.now().dbFormat();
      // source_name 是链表查询获得的字段，保存的时候要删除
      var articleJson = article.toJson();
      articleJson.remove('source_name');
      await _db.insert(table, articleJson);
    }
  }
}
