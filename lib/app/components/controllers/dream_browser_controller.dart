import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class DreamBrowserController extends GetxController {
  final initUrl = 'https://twitter.com/home';


  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true
  );
}
