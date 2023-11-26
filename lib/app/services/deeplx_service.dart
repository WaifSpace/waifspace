import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/services/hive_service.dart';

class DeeplxService  {
  static const _urlConfigName = 'deeplx_url';
  static const _codeConfigName = 'deeplx_code';

  String get url =>
      HiveService.to.box.get(_urlConfigName, defaultValue: '');
  set url(String value) => HiveService.to.box.put(_urlConfigName, value);

  String get code => HiveService.to.box.get(_codeConfigName, defaultValue: '');
  set code(String value) => HiveService.to.box.put(_codeConfigName, value);

  DeeplxService._build();

  static Future<DeeplxService> build() async {
    var service = DeeplxService._build();
    await service.init();
    return service;
  }

  static DeeplxService get to => Get.find<DeeplxService>();

  late Box box;

  Future<DeeplxService> init() async {
    return this;
  }

  Future<String> translate(String text) async {
    try {
      var response = await dio.post(
          url,
          data: {
            "text": text,
            // "source_lang": "EN", // 不传参数的时候，会自动检测
            "target_lang": "ZH",
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $code",
          })
      );
      if (response.statusCode == 200) {
        var result = response.data;
        if(result["code"] == 200) {
          var content = result["data"];
          logger.i("翻译的结果是: $content");
          return content;
        }
      }
    } catch (e) {
      logger.i("请求deeplx 错误, $e");
    }
    return "";
  }
}

