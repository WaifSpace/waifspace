import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:waifspace/app/components/controllers/article_controller.dart';
import 'package:waifspace/app/data/models/article_model.dart';
import 'package:waifspace/app/global.dart';

class ArticleView extends GetView<ArticleController> {
  final Article article;

  const ArticleView({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("article_view_${article.id}"),
      onVisibilityChanged: (visibilityInfo) {
        if(article.isRead == 1) {
          return;
        }
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if(visiblePercentage >= 20) {
          controller.readArticle(article.id);
          article.isRead = 1;
        }
      },
      child: Column(
      children: [
        GestureDetector(
          onTap: () { controller.openBrowser(article.url); },
          child: article.imageUrl == null
              ? Image.asset("assets/images/blank_banner.jpeg", height: 200)
              : Image.network(
                  article.imageUrl!,
                  height: 200,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image.asset("assets/images/image_error.jpg");
                  },
                ),
        ),
        Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: GestureDetector(
              onTap: () { controller.openBrowser(article.url); },
              child: Text(
                _showArticleTitle(article),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RawChip(label: GestureDetector(
              onTap: () => controller.filterSource(article.sourceId!, article.sourceName ?? ''),
              child: Text(article.sourceName ?? ''),
            )),
            const SizedBox(width: 10),
            RawChip(label: Text(controller.articleTime(article))),
            const Spacer(),
            IconButton(onPressed: () => controller.bookmark(article), icon: const Icon(Icons.bookmark_add)),
            IconButton(onPressed: () => controller.share(article), icon: const Icon(Icons.share)),
            // IconButton(onPressed: () => controller.translate(htmlToText(article.content ?? '').trim()), icon: const Icon(Icons.translate)),
          ],
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          alignment: Alignment.topLeft,
          child: SelectableText(
            _showArticleContent(article),
            maxLines: 20,
            minLines: 2,
            textAlign: TextAlign.left,
            scrollPhysics: const NeverScrollableScrollPhysics(),
            style: const TextStyle(
              letterSpacing: 0.5,
              wordSpacing: 1,
              height: 1.6,
              fontSize: 16,
            ),
          ),
        ),
        const Divider(
          thickness: 2,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        ),
      ],
    )
    );
  }
}

String _showArticleContent(Article article) {
  var content = article.cnContent;
  if(content == null || content.trim().isEmpty) {
    content = article.content;
  }
  return htmlToText(content ?? '').trim();
}

String _showArticleTitle(Article article) {
  var title = article.cnTitle;
  if(title == null || title.trim().isEmpty) {
    title = article.title;
  }
  return htmlToText(title ?? '').trim();
}
