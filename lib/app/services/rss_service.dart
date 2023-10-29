import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:rss_dart/dart_rss.dart';
import 'package:waifspace/app/data/models/article_model.dart';
import 'package:waifspace/app/data/models/article_source_model.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/data/providers/rss_provider.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/helper/app_time.dart';

class RssService extends GetxService {

  static RssService get to => Get.find<RssService>();

  var _isFetchAll = false;
  var progress = 0.0.obs; // 获取全部文章的进度, 用于对外暴露处理进度

  var articleProvider = Get.find<ArticleProvider>();
  var articleSourceProvider = Get.find<ArticleSourceProvider>();

  Future<ArticleSource?> addSource(String url, String name) async {
    var rssFeed = await _getRssFeedByUrl(url);

    if(rssFeed == null) {
      return null;
    }

    // TODO: 判断 URL 不能重复，另外name可以修改
    return await articleSourceProvider.create(ArticleSource(
      name: name.isEmpty ? rssFeed.title : name,
      description: rssFeed.description,
      url: url,
      homepage: rssFeed.link,
      type: 'rss',
      image: rssFeed.image?.link,
    ));
  }

  // 用于记录所有的任务
  List<Future<Null> Function()> tasks = [];
  var sourceCount = 0;
  Future<void> fetchAllArticles() async {
    if(_isFetchAll) {
      logger.i("正在全量获取新闻，请稍后");
      return;
    }

    _isFetchAll = true; // 设置标志位，表明开始批量处理，避免调用多次后的重复执行
    tasks.clear(); // 清空任务
    progress.value = 0.01; // 先把进度条显示出来
    var articleSources = await ArticleSourceProvider.to.findAll();
    sourceCount = articleSources.length;

    for(var articleSource in articleSources) {
      _fetchArticles(articleSource);
    }

  }

  // Future<void> fetchArticles(int id) async {
  //   ArticleSource? articleSource = await articleSourceProvider.findByID(id);
  //   await _fetchArticles(articleSource);
  // }

  int taskCount = 0;
  int taskIndex = 0;
  void startTask() {
    taskCount = tasks.length;
    taskIndex = 0;

    logger.i("一共获取 $taskCount 篇新文章");

    for(var task in tasks) {
      task();
    }
  }

  void addTask(ArticleSource articleSource, RssItem item) {
    tasks.add(() async {
      try {
        await articleProvider.create(Article(
          title: item.title,
          content: item.description,
          imageUrl: _getImageUrlFromContent(item.description),
          url: item.link,
          sourceId: articleSource.id,
          isRead: 0,
          sourceUid: item.guid,
          pubDate: item.pubDate != null ? AppTime.parseGMT(item.pubDate!)
              .dbFormat() : '',
          // pubDate: AppTime.parseGMT(item.pubDate ?? "").dbFormat(),
        ));
      } catch (e, stack) {
        logger.i("保存文章错误 ${e.toString()}");
      }
      logger.i("保存文章 ${item.title} taskIndex => $taskIndex, taskCount => $taskCount");
      taskIndex += 1;
      progress.value = taskIndex / taskCount;

      // 如果索引大于总任务，那就说明已经处理完了
      if(taskIndex >= taskCount) {
        _isFetchAll = false;
        progress.value = 0.0;
      }
    });
  }

  Future<void> _fetchArticles(ArticleSource? articleSource) async {
    logger.i("> 开始获取文章 ${articleSource?.name} ${articleSource?.url}");
    try {
      if (articleSource != null && articleSource.url != null) {
        var rssFeed = await _getRssFeedByUrl(articleSource.url!);

        if (rssFeed == null) {
          return;
        }

        for (var item in rssFeed.items) {
          addTask(articleSource, item);
        }
      }
      logger.i("< 取文章完成 ${articleSource?.name} ${articleSource?.url}");
    } catch (e, _) {
      logger.i("获取文章错误 ${articleSource?.name} ${articleSource?.url} ${e.toString()}");
    }
    sourceCount -= 1;
    // 说明所有的 source 已经处理完了
    if(sourceCount <= 0) {
      startTask();
    }
  }

  String? _getImageUrlFromContent(String? content) {
    if(content == null || content.trim() == "") {
      return null;
    }
    var document = parse(content);
    return document.querySelector("img")?.attributes['src'];
  }

  Future<RssFeed?> _getRssFeedByUrl(String url) async {
    String? xmlString = await RssProvider().getRssXmlString(url);
    if(xmlString != null) {
      RssFeed rssFeed = RssFeed.parse(xmlString);
      return rssFeed;
    }
    return null;

  }

// 用于更新网站的logo
// Future<void> fetchAllLogos() async {
//   var sources = await ArticleSourceProvider.to.findAll();
//
//   for (var source in sources) {
//     if(source.image == null || source.image!.isEmpty) {
//       var response = await dio.get(source.url!);
//       var doc = html_parser.parse(response.data.toString());
//       source.image = doc.querySelector('selector');
//       logger.i('更新 ${source.name} 的 logo => ${source.image}');
//       await ArticleSourceProvider.to.update(source);
//     }
//   }
// }
}
