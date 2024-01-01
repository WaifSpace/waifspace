import 'package:rss_dart/dart_rss.dart';

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
      image: atomFeed.logo,
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