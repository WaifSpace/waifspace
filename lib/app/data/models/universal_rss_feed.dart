import 'package:dart_rss/dart_rss.dart';
import 'package:dart_rss/util/helpers.dart';

class UniversalRssFeed {
  final String? title;
  final String? description;
  final String? link;
  final String? image;
  final List<UniversalRssItem> items;

  UniversalRssFeed({
    required this.title,
    required this.description,
    required this.link,
    required this.image,
    this.items = const <UniversalRssItem>[],
  });

  static fromRssFeed(RssFeed rssFeed) {
    return UniversalRssFeed(
        title: rssFeed.title,
        description: rssFeed.description,
        link: rssFeed.link,
        image: rssFeed.image?.link,
        items: rssFeed.items.map<UniversalRssItem>((e) => UniversalRssItem.fromRssItem(e)).toList(),
    );
  }

  static fromAtomFeed(AtomFeed atomFeed) {
    return UniversalRssFeed(
      title: atomFeed.title,
      description: atomFeed.subtitle,
      link: atomFeed.links.firstWhere((element) => element.type == 'application/atom+xml').href,
      // 好像 atom 2.0 的标准，网站的 logo 是 image 下面的 url 字段，具体可以参考 https://rsshub.app/wechat/wechat2rss/9685937b45fe9c7a526dbc32e4f24ba879a65b9a
      // TODO: 但是默认的这个库不支持 获取这个信息，要修改
      image: atomFeed.icon,
      items: atomFeed.items.map<UniversalRssItem>((e) => UniversalRssItem.fromAtomItem(e)).toList(),
    );
  }
}

class UniversalRssItem {
  final String? title;
  final String? description;
  final String? link;
  final String? guid;
  final String? pubDate;

  UniversalRssItem({
    required this.title,
    required this.description,
    required this.link,
    required this.guid,
    required this.pubDate
  });

  static fromRssItem(RssItem rssItem) {
    return UniversalRssItem(
        title: rssItem.title,
        description: rssItem.description,
        link: rssItem.link,
        guid: rssItem.guid,
        pubDate: rssItem.pubDate,
    );
  }

  static fromAtomItem(AtomItem atomItem) {
    return UniversalRssItem(
      title: atomItem.title,
      description: atomItem.content,
      link: atomItem.links.firstOrNull?.href,
      guid: atomItem.id,
      pubDate: atomItem.published,
    );
  }
}