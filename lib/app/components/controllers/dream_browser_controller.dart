import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class DreamBrowserController extends GetxController {
  final initUrl = 'https://twitter.com/home';
  // final initUrl = 'https://www.163.com/';

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  void goBack() {
    webViewController?.goBack();
  }
  
  void goHomePage() {
    webViewController?.loadUrl(urlRequest: URLRequest(url: Uri.parse(initUrl)));
  }
}
