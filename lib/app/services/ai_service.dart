import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/services/hive_service.dart';

class AIService {
  static const _tokenConfigName = 'chatgpt_token';
  static const _urlConfigName = 'chatgpt_url';

  AIService._build();

  static Future<AIService> build() async {
    var aiService = AIService._build();
    aiService.init();
    return aiService;
  }

  static AIService get to => Get.find<AIService>();

  final openaiClient = Dio();
  void init() {
    openaiClient.options.connectTimeout = const Duration(seconds: 5);
    openaiClient.options.receiveTimeout = const Duration(seconds: 30);
  }

  String get token =>
      HiveService.to.box.get(_tokenConfigName, defaultValue: '');
  set token(String value) => HiveService.to.box.put(_tokenConfigName, value);

  String get url => HiveService.to.box.get(_urlConfigName, defaultValue: '');
  set url(String value) => HiveService.to.box.put(_urlConfigName, value);

  // 翻译默认使用 3.5, 能更节省钱
  Future<String> translate(String text,
      {String model = 'gpt-3.5-turbo'}) async {
    if (text.isEmpty) {
      return '';
    }
    // 控制文本长度，确保不要把token撑爆了
    if (text.length >= 200) {
      text = text.substring(0, 200);
    }
    var result = await openChatRequest(model,
        "翻译 $text 到中文, 注意: 如果是一个项目名或者是一个GitHub仓库，就不翻译，直接返回原始的内容就可以，不要输出任何其他的解释。");
    logger.i('[AI 翻译] $text => $result');
    return result;
  }

  Future<String> readAndTranslate(String text,
      {String model = 'gpt-4', int maxLength = 200}) async {
    if (text.isEmpty) {
      return '';
    }
    // 控制文本长度，确保不要把token撑爆了
    if (text.length >= maxLength) {
      text = text.substring(0, maxLength);
    }
    var result = await openChatRequest(
        model, "$text \n 提取上面文字的核心内容，并通过尽可能短的，不超过 $maxLength 个字的中文总结出来");
    return result;
  }

  Future<String> openChatRequest(String model, String content) async {
    try {
      final response = await openaiClient.post("$url/chat/completions",
          data: {
            "model": model,
            "messages": [
              {"role": "user", "content": content}
            ],
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }));

      if (response.statusCode == 200) {
        var result = response.data;
        var content = result["choices"][0]["message"]["content"];
        return content;
      }
    } catch (e) {
      logger.i("请求chatgpt 错误, $e");
    }
    return "";
  }
}
