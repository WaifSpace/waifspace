import 'package:waifspace/app/global.dart';

class RssProvider {
  Future<String?> getRssXmlString(String url) async {
    var response = await dio.get(url);
    if(response.statusCode == 200) {
      return response.data.toString();
    }
    logger.i("[$url] 获取错误 [${response.statusMessage}]");
    return null;
  }
}
