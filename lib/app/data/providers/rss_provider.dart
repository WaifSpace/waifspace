import 'package:get/get.dart';
import 'package:waifspace/app/global.dart';

class RssProvider extends GetConnect {

  @override
  void onInit() {
    httpClient.timeout = const Duration(seconds: 50);
  }

  Future<String?> getRssXmlString(String url) async {
    var response = await get(url);
    if(response.status.isOk) {
      return response.body.toString();
    }
    // 这个地方网络错误，可以加上一次retry
    logger.i("[$url] 获取错误");
    response.printError();
    return null;

  }
}
