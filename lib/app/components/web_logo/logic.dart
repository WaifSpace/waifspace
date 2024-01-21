import 'package:get/get.dart';

import 'state.dart';

class WebLogoLogic extends GetxController {
  final WebLogoState state = WebLogoState();

  static const iconHorseBaseUrl = "https://icon.horse/icon/";
  static const googleLogoBaseUrl = "https://www.google.com/s2/favicons";
  static const localWebLogoPath = "assets/images/web_logo.png";

  String iconHorseImageUrl(String host) {
    return "$iconHorseBaseUrl$host";
  }

  String googleImageUrl(String host) {
     return "https://www.google.com/s2/favicons?sz=64&domain=$host";
  }
}
