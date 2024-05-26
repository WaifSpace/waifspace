import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:waifspace/app/components/controllers/article_list_controller.dart';
import 'package:waifspace/app/data/models/article_model.dart';
import 'package:waifspace/app/data/models/article_source_model.dart';
import 'package:waifspace/app/data/models/universal_rss_feed.dart';
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
    var feed = await _getRssFeedByUrl(url);

    if(feed == null) {
      return null;
    }

    // TODO: 判断 URL 不能重复，另外name可以修改
    return await articleSourceProvider.create(ArticleSource(
      name: name.isEmpty ? feed.title : name,
      description: feed.description,
      url: url,
      homepage: feed.link,
      type: 'rss',
      // image: feed.image,
    ));
  }

  // 用于记录所有的任务
  List<Future<Null> Function()> tasks = [];
  int sourceCount = 0; // 用于记录源的总数
  int sourceIndex = 0; // 用于记录完成了的源的数量
  Future<void> fetchAllArticles() async {
    if(_isFetchAll) {
      logger.i("正在全量获取新闻，请稍后");
      return;
    }

    _isFetchAll = true; // 设置标志位，表明开始批量处理，避免调用多次后的重复执行
    tasks.clear(); // 清空任务
    progress.value = 0.01; // 先把进度条显示出来
    var articleSources = await ArticleSourceProvider.to.findAll();

    // 初始化索引，用于后面记录处理的进度
    sourceCount = articleSources.length;
    sourceIndex = 0;

    for(var articleSource in articleSources) {
      _fetchArticles(articleSource);
    }
  }

  int taskCount = 0; // 用于记录任务的总数
  int taskIndex = 0; // 用于记录完成了的任务数量
  Future<void> startTask() async {
    taskCount = tasks.length;
    taskIndex = 0;

    logger.i("一共获取 $taskCount 篇新文章");

    for(var task in tasks) {
      task();
    }
  }

  void taskDone() {
    // 重新初始化状态
    _isFetchAll = false;
    progress.value = 0.0;
    ArticleListController.to.reloadData();
  }

  void addTask(ArticleSource articleSource, UniversalRssItem item) {
    tasks.add(() async {
      try {
        await articleProvider.create(Article(
          title: item.title,
          content: item.description,
          imageUrl: await getRssItemImage(item),
          url: item.link,
          sourceId: articleSource.id,
          sourceName: articleSource.name,
          homepage: articleSource.homepage,
          isRead: 0,
          sourceUid: item.guid ?? item.link, // 有的 rss 订阅没有 guid 字段，就用 link 代替
          pubDate: item.pubDate != null ? AppTime.parseGMT(item.pubDate!).dbFormat() : AppTime.now().dbFormat(),
          // pubDate: AppTime.parseGMT(item.pubDate ?? "").dbFormat(),
        ));
      } catch (e, stack) {
        logger.i("保存文章错误 ${item.title} ${e.toString()} $stack");
      } finally {
        taskIndex += 1;
        // logger.i("保存文章 ${item.title} taskIndex => $taskIndex, taskCount => $taskCount");
        progress.value = taskIndex / taskCount * 0.8 + 0.2; // 子任务的处理占总数的 80%

        // 如果索引大于总任务，那就说明已经处理完了
        if (taskIndex >= taskCount) {
          taskDone();
        }
      }
    });
  }

  Future<void> _fetchArticles(ArticleSource? articleSource) async {
    logger.i("> 开始获取文章 ${articleSource?.name} ${articleSource?.url}");
    try {
      if (articleSource != null && articleSource.url != null) {
        var feed = await _getRssFeedByUrl(articleSource.url!);

        if (feed == null) {
          return;
        }

        for (var item in feed.items) {
          addTask(articleSource, item);
        }
      }
      logger.i("< 取文章完成 ${articleSource?.name} ${articleSource?.url}");
    } catch (e, _) {
      logger.i("获取文章错误 ${articleSource?.name} ${articleSource?.url} ${e.toString()}");
    } finally {
      sourceIndex += 1;
      progress.value = sourceIndex / sourceCount * 0.2; // 源地址的获取占总进度的 20%
      // 说明所有的 source 已经处理完了
      if(sourceIndex >= sourceCount) {
        startTask();
      }
    }
  }

  Future<String?> getRssItemImage(UniversalRssItem item) async {
    var imageUrl = getImageUrlFromContent(item.description);
    return imageUrl;
  }

  String? getImageUrlFromContent(String? content) {
    if(content == null || content.trim() == "") {
      return null;
    }
    var document = parse(content);
    var imageUrl =  document.querySelector("img")?.attributes['src'];

    // 从图片中如果取出来的不是链接，而是图片的内容就可能导致超长，从而导致数据库读取报错
    // 例如 infoq 里面的 《鲲鹏应用创新大赛 2023 金奖解读：openEuler 助力北大团队创新改进，网络性能再提升》的rss 地址就把二进制图片放在了 image 标签里面
    if(imageUrl != null && imageUrl.length >= 1000) {
      imageUrl = "";
    }
    return imageUrl;
  }

  Future<UniversalRssFeed?> _getRssFeedByUrl(String url) async {
    String? xmlString = await RssProvider().getRssXmlString(url);
    // 通过异常捕获，来兼容不同的 rss 类型。
    if(xmlString != null) {
      try {
        RssFeed rssFeed = RssFeed.parse(xmlString);
        return UniversalRssFeed.fromRssFeed(rssFeed);
      } catch (e) {
        AtomFeed atomFeed = AtomFeed.parse(xmlString);
        return UniversalRssFeed.fromAtomFeed(atomFeed);
      }
    }
    return null;
  }

//  用于更新网站的 logo
  Future<void> fetchAllLogos() async {
    var sources = await ArticleSourceProvider.to.findAll();

    for (var source in sources) {
      try {
        var feed = await _getRssFeedByUrl(source.url!);

        if(feed == null) {
          return;
        }

        source.image = feed.image;
        logger.i("获取网站 ${source.name} logo ${feed.image}");
        await ArticleSourceProvider.to.update(source);
      } catch (e) {
        logger.i("获取网站 ${source.name} logo 失败 ${e}");
      }
    }
  }
}
