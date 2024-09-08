import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:waifspace/app/components/controllers/article_controller.dart';
import 'package:waifspace/app/components/web_logo/view.dart';
import 'package:waifspace/app/data/models/article_model.dart';
import 'package:waifspace/app/global.dart';

class ArticleView extends GetView<ArticleController> {
  final Article article;

  const ArticleView({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final articleImageComponent = GestureDetector(
      onTap: () {
        controller.openBrowser(article.url);
      },
      child: article.imageUrl == null
          // ? Image.asset("assets/images/blank_banner.jpeg", height: 200)
          ? Container()
          : Image(
              image: CachedNetworkImageProvider(article.imageUrl!),
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Container();
              },
            ),
    );

    final articleTitleComponent = GestureDetector(
      onTap: () {
        controller.openBrowser(article.url);
      },
      child: Text(
        _showArticleTitle(article),
        softWrap: true,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );

    final logoComponent = GestureDetector(
      onTap: () =>
          controller.filterSource(article.sourceId!, article.sourceName ?? ''),
      child: WebLogoComponent(url: article.homepage ?? ""),
    );

    final articleActionsComponent = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            "@${article.sourceName} -- ${controller.articleTime(article)}",
            style: const TextStyle(color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // IconButton(
        //   onPressed: () => controller.bookmark(article, context),
        //   padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        //   icon: const Icon(Icons.bookmark_add_outlined, size: 20),
        //   constraints: const BoxConstraints(),
        //   color: Colors.grey,
        // ),
        IconButton(
          onPressed: () => controller.share(article),
          icon: const FaIcon(
            FontAwesomeIcons.shareNodes,
            size: 15,
          ),
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          constraints: const BoxConstraints(),
          color: Colors.grey,
        ),
        // IconButton(onPressed: () => controller.translate(htmlToText(article.content ?? '').trim()), icon: const Icon(Icons.translate)),
      ],
    );

    // 文章的内容
    final readMoreArticleContentComponent = ReadMoreText(
      _showArticleContent(article),
      trimMode: TrimMode.Line,
      trimLines: 10,
      trimCollapsedText: ' 更多',
      trimExpandedText: ' 收起',
      style: const TextStyle(
        letterSpacing: 0.5,
        wordSpacing: 1,
        height: 1.6,
        fontSize: 14,
      ),
      moreStyle: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
      lessStyle: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
    );

    final articleContentComponent = GestureDetector(
      onTap: () {
        controller.openBrowser(article.url);
      },
      child: readMoreArticleContentComponent,
    );

    return VisibilityDetector(
      key: Key("article_view_${article.id}"),
      onVisibilityChanged: (visibilityInfo) {
        if (article.isRead == 1) {
          return;
        }
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage >= 20) {
          controller.readArticle(article.id);
          article.isRead = 1;
        }
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                alignment: Alignment.topLeft,
                child: logoComponent,
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      alignment: Alignment.topLeft,
                      child: articleTitleComponent,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      alignment: Alignment.topLeft,
                      child: articleContentComponent,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 5, 10, 15),
                      alignment: Alignment.topLeft,
                      child: articleImageComponent,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      alignment: Alignment.topLeft,
                      child: articleActionsComponent,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 2,
          ),
        ],
      ),
    );
  }
}

String _showArticleContent(Article article) {
  var content = article.cnContent;
  if (content == null || content.trim().isEmpty) {
    content = article.content;
  }
  return htmlToText(content ?? '').trim();
}

String _showArticleTitle(Article article) {
  var title = article.cnTitle;
  if (title == null || title.trim().isEmpty) {
    title = article.title;
  }
  return htmlToText(title ?? '').trim();
}

CachedNetworkImage _cacheImage(String url) {
  return CachedNetworkImage(
    imageUrl: url,
    placeholder: (context, url) => const CircularProgressIndicator(),
    errorWidget: (context, url, error) =>
        Image.asset("assets/images/image_error.jpg"),
  );
}
