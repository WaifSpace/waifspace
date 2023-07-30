import 'package:dart_rss/dart_rss.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/data/models/article_model.dart';
import 'package:waifspace/app/data/models/article_source_model.dart';
import 'package:waifspace/app/data/providers/article_provider.dart';
import 'package:waifspace/app/data/providers/article_source_provider.dart';
import 'package:waifspace/app/data/providers/rss_provider.dart';

class RssService extends GetxService {
  var articleProvider = Get.find<ArticleProvider>();
  var articleSourceProvider = Get.find<ArticleSourceProvider>();

  add(String url, String name) async {
    String xmlString = await RssProvider().getRssXmlString(url);
    RssFeed rssFeed = RssFeed.parse(xmlString);

    // TODO: 判断 URL 不能重复，另外name可以修改
    articleSourceProvider.create(ArticleSource(
      name: name.isEmpty ? rssFeed.title : name,
      description: rssFeed.description,
      url: url,
      homepage: rssFeed.link,
      type: 'rss',
      image: rssFeed.image?.link,
    ));

    // for(var item in rssFeed.items) {
    //   logger.i(item.title);
    //   articleProvider.create(Article(
    //     title: item.title,
    //     content: item.description,
    //     url: item.link,
    //     sourceId: 1,
    //     sourceUid: item.guid,
    //   ));
    // }
  }
}
