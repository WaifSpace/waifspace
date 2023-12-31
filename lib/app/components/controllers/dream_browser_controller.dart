import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/global.dart';

class DreamBrowserController extends GetxController {
  static DreamBrowserController get to => Get.find<DreamBrowserController>();

  final initUrl = 'https://twitter.com/home';
  // final initUrl = 'https://www.163.com/';

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: false,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

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
}
  