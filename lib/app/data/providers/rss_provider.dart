import 'package:get/get.dart';
import 'package:waifspace/app/global.dart';

class RssProvider extends GetConnect {

  @override
  void onInit() {
    httpClient.timeout = const Duration(seconds: 20);
  }

  Future<String> getRssXmlString(String url) async {
    var response = await get(url);
    logger.i(response.toString());
    return response.body.toString();
  }
}
