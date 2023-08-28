import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/components/controllers/dream_browser_controller.dart';

class DreamBrowserView extends GetView<DreamBrowserController> {
  const DreamBrowserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey webViewKey = GlobalKey();

    return InAppWebView(
      key: webViewKey,
      initialOptions: controller.options,
      initialUrlRequest: URLRequest(url: Uri.parse(controller.initUrl)),
      onWebViewCreated: (c) {
        controller.webViewController = c;
      },
      androidOnPermissionRequest: (controller, origin, resources) async {
        return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT);
      },
    );
  }
}


