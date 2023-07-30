import 'package:get/get.dart';

class RssProvider extends GetConnect {
  Future<String> getRssXmlString(String url) async {
    var response = await get(url);
    return response.body.toString();
  }
}
