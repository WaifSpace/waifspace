import 'package:dio/dio.dart';
import 'package:waifspace/app/global.dart';

class RssProvider {
  final dio = Dio();

  Future<String?> getRssXmlString(String url) async {
    var response = await dio.get(url);
    if(response.statusCode == 200) {
      return response.data.toString();
    }
    // 这个地方网络错误，可以加上一次retry
    logger.i("[$url] 获取错误 [${response.statusMessage}]");
    return null;
  }
}
