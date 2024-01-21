import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class WebLogoComponent extends StatelessWidget {
  final String url;

  WebLogoComponent({super.key, required this.url});

  final logic = Get.put(WebLogoLogic());
  final state = Get.find<WebLogoLogic>().state;

  @override
  Widget build(BuildContext context) {

    final uri = Uri.parse(url);

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image(
          image: CachedNetworkImageProvider(logic.googleImageUrl(uri.host)),
          height: 30,
          fit: BoxFit.fill,
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Image.asset("assets/images/web_logo.png", height: 30, fit: BoxFit.fill);
          }
      ),
    );

    // return Image(
    //   image: CachedNetworkImageProvider(logic.iconHorseImageUrl(uri.host)),
    //   height: 30,
    //   fit: BoxFit.fill,
    //   errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
    //     return Image(
    //       image: CachedNetworkImageProvider(logic.googleImageUrl(uri.host)),
    //       height: 30,
    //       fit: BoxFit.fill,
    //       errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
    //         return Image.asset("assets/images/web_logo.png", height: 30, fit: BoxFit.fill);
    //       }
    //     );
    //   },
    // );
  }
}
