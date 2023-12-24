import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/dream_browser_controller.dart';
import 'package:waifspace/app/global.dart';

class DreamBrowserView extends GetView<DreamBrowserController> {
  const DreamBrowserView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey webViewKey = GlobalKey();

    return InAppWebView(
      key: webViewKey,
      initialSettings: controller.settings,
      initialUrlRequest: URLRequest(url: WebUri(controller.initUrl)),
      onWebViewCreated: (c) {
        controller.webViewController = c;
      },
      onPermissionRequest: (controller, request) async {
        return PermissionResponse(
            resources: request.resources,
            action: PermissionResponseAction.GRANT);
      },
      onConsoleMessage: (controller, consoleMessage) {
        if (!isProduction) {
          print("[webview console] $consoleMessage");
        }
      },
      onLoadStop: (controller, url) async {
        await controller.injectJavascriptFileFromAsset(assetFilePath: "assets/javascripts/jquery-3.7.1.min.js");
        await controller.injectJavascriptFileFromAsset(assetFilePath: "assets/javascripts/twitter.js");
      },
    );
  }
}
