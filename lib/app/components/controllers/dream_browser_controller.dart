import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/global.dart';

class DreamBrowserController extends GetxController {
  static DreamBrowserController get to => Get.find<DreamBrowserController>();

  final initUrl = 'https://twitter.com/home';

  final ChromeSafariBrowser _browser = _Browser();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: false,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true,
  );

  late Timer _timer;

  @override
  void onReady() {
    if(isProduction) {
      _timer = Timer.periodic(const Duration(milliseconds: 1000), onTimer);
    } else {
      _timer = Timer.periodic(const Duration(milliseconds: 5000), onTimer);
    }
  }

  @override
  void onClose() {
    _timer.cancel();
  }

  Future<void> onTimer(Timer timer) async {
    // logger.i("DreamBrowserController timer callback");
    await webViewController?.evaluateJavascript(source: "registerBookmarkClickEvent();");
  }

  void goBack() {
    webViewController?.goBack();
  }
  
  void goHomePage() {
    webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(initUrl)));
  }

  void doWebScript() async {
    if (isProduction) {
      return;
    }
    var result = await webViewController?.evaluateJavascript(source: "getFistArticle()");
    print(result.runtimeType); // int
    print(result); // 2
  }

  Future<void> openBrowser(String? url) async {
    if(url == null || url.isEmpty) {
      return;
    }
    await _browser.open(
        url: WebUri(url),
        settings: ChromeSafariBrowserSettings(
            shareState: CustomTabsShareState.SHARE_STATE_OFF,
            barCollapsingEnabled: true));
  }


}

class _Browser extends ChromeSafariBrowser {
}