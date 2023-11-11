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
        .where("a.source_id = ?", [_sourceIDCondition])
        .orderBy("a.id", desc: true)
        .like('(a.title like ? or a.cn_title like ? or a.content like ? or a.cn_content like ?)', [_searchCondition, _searchCondition, _searchCondition, _searchCondition]);
    if(id > 0) {
      sqlBuilder.where("a.id < ?", [id]);
    }

    // 如果是全部列表的时候，并且没有搜索条件的时候, 只显示未读的文章
    if(_sourceIDCondition == null && _searchCondition == null) {
      sqlBuilder.where("a.is_read = ?", [0]);
    }

    var (sql, arguments) = sqlBuilder.done();
    logger.i("执行sql => $sql");
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

  Future<void> create(Article article) async {
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
      logger.i("插入文章 ${article.title}");
      if(!isChinese(article.title ?? '')) { // 只对英文处理
        article.cnTitle = await AIService.to.translate(article.title ?? '');
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

  Future<int> readArticle(int articleID) async {
    // debug 环境下不把文章标记为已读
    if(!isProduction) {
      return 0;
    }
    if(articleID <= -1) {
      return 0;
    }
    logger.i('阅读文章ID => $articleID');
    return await _db.rawUpdate(
      'update $table set is_read = 1 where id = ?',
      [articleID]
    );
  }

  Future<Map> sourceCount() async {
    var countInfo = await _db.rawQuery('select source_id, count(id) as count from $table group by source_id');
    return { for (var e in countInfo) e['source_id'] : e['count'] };
  }

  Future<Map> sourceUnreadCount() async {
    var countInfo = await _db.rawQuery('select source_id, count(id) as count from $table where is_read = 0 group by source_id');
    return { for (var e in countInfo) e['source_id'] : e['count'] };
  }

  Future<int> makeAllRead() async {
    logger.i('标记所有文章已读');
    return await _db.rawUpdate('update $table set is_read = 1 where is_read = 0');
  }

  Future<int> makeAllReadBySourceID(int sourceID) async {
    if(sourceID <= -1) {
      return 0;
    }
    logger.i('标记所有source id 为 $sourceID 文章已读');
    return await _db.rawUpdate(
        'update $table set is_read = 1 where source_id = ? and is_read = 0',
        [sourceID]
    );
  }

  Future<int> deleteBySourceID(int sourceID) async {
    logger.i('删除所有source id 为 $sourceID 文章');
    return await _db.rawDelete(
        'delete from $table where source_id = ?',
        [sourceID]
    );
  }


  Future<void> refreshTitleTranslation(int sourceID) async {
    logger.i('刷新所有source id 为 $sourceID 文章, 标题的翻译');

    List<Map> maps = await _db.query(
        table,
        columns: ['id', 'title'],
        where: 'source_id = ?',
        whereArgs: [sourceID]);
    if (maps.isNotEmpty) {
      for(final articleMap in maps) {
        if(!isChinese(articleMap['title'] ?? '')) { // 只对英文处理
          logger.i("更新文章 ${articleMap['title']} 的中文翻译");
          var cnTitle = await AIService.to.translate(articleMap['title'] ?? '');
          await _db.rawUpdate(
              'update $table set cn_title = ? where id = ?',
              [cnTitle, articleMap['id']]
          );
        }
      }
    }
  }
}
