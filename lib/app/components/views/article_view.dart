import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/article_controller.dart';
import 'package:waifspace/app/data/models/article_model.dart';
import 'package:waifspace/app/global.dart';

class ArticleView extends GetView<ArticleController> {
  final Article article;

  const ArticleView({Key? key, required this.article}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
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
                article.title ?? "",
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
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
            RawChip(label: Text(article.sourceName ?? '')),
            const SizedBox(width: 10),
            RawChip(label: Text(controller.articleTime(article))),
          ],
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          alignment: Alignment.topLeft,
          child: SelectableText(
            htmlToText(article.content ?? "").trim(),
            maxLines: 10,
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
    );
  }
}
