import 'package:get/get.dart';
import 'package:html/parser.dart';
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

  String? _pubDateCondition; // 用于根据时间范围来显示

  final Database _db = Get.find<DatabaseService>().db;

  // 获取比参数 ID 新的文章
  Future<List<Article>> latestArticles(int id) async {
    List<Article> articles = [];

    var sqlBuilder = SqlBuilder("SELECT a.*, b.name as source_name, b.homepage as homepage FROM $table as a left join ${ArticleSourceProvider.table} as b on a.source_id = b.id");
    sqlBuilder.limit(_queryLimit)
        .where("a.source_id = ?", [_sourceIDCondition])
        .like('(a.title like ? or a.cn_title like ? or a.content like ? or a.cn_content like ?)', [_searchCondition, _searchCondition, _searchCondition, _searchCondition]);
    if(id > 0) {
      sqlBuilder.where("a.id < ?", [id]);
    }

    // 当选择某一个具体的分类或者 24小时的新闻时候，按照日期排序
    if((_sourceIDCondition == -1 || _sourceIDCondition == null) && _pubDateCondition == null) {
      sqlBuilder.orderBy("a.id", desc: true);
    } else {
      sqlBuilder.orderBy("a.pub_date", desc: true);
    }

    // 如果是全部列表的时候，并且没有搜索条件的时候, 只显示未读的文章
    if(_sourceIDCondition == null && _searchCondition == null) {
      sqlBuilder.where("a.is_read = ?", [0]);
    }

    // 根据时间字段筛选
    if(_pubDateCondition != null) {
      sqlBuilder.where("a.pub_date > ?", [_pubDateCondition]);
    }

    var (sql, arguments) = sqlBuilder.done();
    logger.i("执行sql => $sql, $arguments");
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

  void updatePubDatedFilter(String? date) {
    _pubDateCondition = date;
    if(date != null) {
      filterSourceName.value = "24小时新闻";
    } else {
      filterSourceName.value = "";
    }
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
      logger.i("[插入文章] ${article.title}");

      // 把内容里面的 html 和 css 都去掉
      var textContent = htmlToText(article.content ?? '');

      article.content = textContent;

      // 处理特殊情况，防止文章的内容过大， infoq 有一个文章 《鲲鹏应用创新大赛 2023 金奖解读：openEuler 助力北大团队创新改进，网络性能再提升》
      // 里面竟然把一个二进制的图片包含了进去，导致数据库的存储的内容过大，最后 查询的时候会查询不出来报错。
      if(article.content != null && article.content!.length >= 2000) {
        article.content = article.content?.substring(0, 2000);
      }

      if(!isChinese(article.title ?? '') && !article.sourceName!.toLowerCase().contains("github")) { // 只对英文处理, github的标题不处理
        article.cnTitle = await AIService.to.translate(article.title ?? '');
      }

      // 在保存进数据库的时候，调用chatgpt 提取文章的内容
      if(!isChinese(article.content ?? "")) { // 只对英文处理
        article.cnContent = await AIService.to.readAndTranslate(article.content ?? "");
      }

      if(article.imageUrl == null || article.imageUrl == '') {
        var imageUrl = await _getImageUrlFromUrl(article.url);
        logger.i("从网页直接获取了图片  ${article.title} => $imageUrl");
        // 从图片中如果取出来的不是链接，而是图片的内容就可能导致超长，从而导致数据库读取报错
        // 例如 infoq 里面的 《鲲鹏应用创新大赛 2023 金奖解读：openEuler 助力北大团队创新改进，网络性能再提升》的rss 地址就把二进制图片放在了 image 标签里面
        if(imageUrl != null && imageUrl.length >= 1000) {
          imageUrl = "";
        }
        article.imageUrl = imageUrl;
      }

      article.createdAt ??= AppTime.now().dbFormat();
      article.updatedAt ??= AppTime.now().dbFormat();
      // source_name 是链表查询获得的字段，保存的时候要删除
      var articleJson = article.toJson();

      // 删除表里面没有的字段
      articleJson.remove('source_name');
      articleJson.remove('homepage');

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

  Future<String> source24HoursCount() async {
    var countInfo = await _db.rawQuery('select count(id) as count from $table where pub_date > ?', [AppTime.fromNow(24).dbFormat()]);
    return countInfo.first['count'].toString();
  }

  Future<String> source24HoursUnreadCount() async {
    var countInfo = await _db.rawQuery('select count(id) as count from $table where is_read = 0 and pub_date > ?', [AppTime.fromNow(24).dbFormat()]);
    return countInfo.first['count'].toString();
  }

  Future<int> makeAllRead() async {
    logger.i('标记所有文章已读');
    return await _db.rawUpdate('update $table set is_read = 1 where is_read = 0');
  }

  Future<int> make24HoursRead() async {
    logger.i('标记24小时文章已读');
    return await _db.rawUpdate('update $table set is_read = 1 where is_read = 0 and pub_date > ?', [AppTime.fromNow(24).dbFormat()]);
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

  // TODO: 文章的内容，我可以自己来解析，不一定要用 rss 返回的
  Future<String?> _getImageUrlFromUrl(String? url) async {
    if(url == null || url.trim() == "") {
      return null;
    }
    try {
      var html = await dio.get(url);
      if (html.statusCode == 200) {
        var document = parse(html.data.toString());

        // 针对 github 特殊处理，直接找 readme-toc 下面的 第二张img
        var githubImages = document.querySelectorAll("readme-toc img");
        if(githubImages.isNotEmpty) {
          if(githubImages.length >= 2) {
            return githubImages[1].attributes['src'];
          } else {
            return githubImages[0].attributes['src'];
          }
        }

        // // 针对 infoq 特殊处理，直接找 class=article-cover 下面的 img, 目前还不行，infoq 的文章用 js 渲染的，有反扒
        // var coverImage = document.querySelector(".article-cover img");
        // if(coverImage != null) {
        //   return coverImage.attributes["src"];
        // }

        // 先找标准的 og:image 内容
        var metaImage = document.querySelector("meta[property='og:image']");
        if(metaImage != null) {
          var image =  metaImage.attributes["content"];
          // infoq 的文章返回的都是他们网站的 icon，而不是网页的内容，这种情况的需要特殊处理
          if(image != null && !image.contains("icon")) {
            return image;
          }
        }

        // 默认选网站中间的图
        var images = document.querySelectorAll("body img");
        if(images.isNotEmpty) {
          return images[images.length ~/ 2].attributes['src'];
        }
      }
    } catch (e) {
      logger.i("获取网页信息错误 $url $e");
    }
    return null;
  }
}
