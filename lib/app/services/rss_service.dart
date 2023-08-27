import 'package:dart_rss/dart_rss.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:waifspace/app/data/models/article_model.dart';
import 'package:waifspace/app/data/models/article_source_model.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/data/providers/rss_provider.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/helper/app_time.dart';

class RssService extends GetxService {
  var articleProvider = Get.find<ArticleProvider>();
  var articleSourceProvider = Get.find<ArticleSourceProvider>();

  Future<void> addSource(String url, String name) async {
    var rssFeed = await _getRssFeedByUrl(url);

    if(rssFeed == null) {
      return;
    }

    // TODO: 判断 URL 不能重复，另外name可以修改
    articleSourceProvider.create(ArticleSource(
      name: name.isEmpty ? rssFeed.title : name,
      description: rssFeed.description,
      url: url,
      homepage: rssFeed.link,
      type: 'rss',
      image: rssFeed.image?.link,
    ));
  }

  Future<void> fetchAllArticles() async {
    for(var articleSource in await ArticleSourceProvider().findAll()) {
      await _fetchArticles(articleSource);
    }
  }

  Future<void> fetchArticles(int id) async {
    ArticleSource? articleSource = await articleSourceProvider.findByID(id);
    await _fetchArticles(articleSource);
  }

  Future<void> _fetchArticles(ArticleSource? articleSource) async {
    if(articleSource != null && articleSource.url != null) {
      var rssFeed = await _getRssFeedByUrl(articleSource.url!);

      if(rssFeed == null) {
        return;
      }

      for(var item in rssFeed.items) {
        logger.i(item.title);
        await articleProvider.create(Article(
          title: item.title,
          content: item.description,
          imageUrl: _getImageUrlFromContent(item.description),
          url: item.link,
          sourceId: articleSource.id,
          sourceUid: item.guid,
          pubDate: item.pubDate != null ? AppTime.parseGMT(item.pubDate!).dbFormat() : '',
          // pubDate: AppTime.parseGMT(item.pubDate ?? "").dbFormat(),
        ));
      }
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
}
