import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/data/providers/setting_provider.dart';
import 'package:waifspace/app/global.dart';

class AIService {
  // 配置
  String url = ''; // 地址
  String token = ''; // 令牌

  AIService._build();

  static Future<AIService> build() async {
    var aiService = AIService._build();
    aiService.init();
    return aiService;
  }

  static AIService get to => Get.find<AIService>();

  final openaiClient = Dio();
  Future<void> init() async {
    openaiClient.options.connectTimeout = const Duration(seconds: 5);
    openaiClient.options.receiveTimeout = const Duration(seconds: 10);
    openaiClient.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print, // specify log function (optional)
      retries: 3, // retry count (optional)
    ));

    await reloadConfig();
  }

  Future<void> reloadConfig() async {
    url = await SettingProvider.to.getOpenAIUrl() ?? '';
    token = await SettingProvider.to.getOpenAIToken() ?? '';
  }

  Future<void> saveConfig(String newUrl, String newToken) async {
    logger.i("保存配置: $newUrl $newToken");
    await SettingProvider.to.saveOpenAIUrl(newUrl);
    await SettingProvider.to.saveOpenAIToken(newToken);
    url = newUrl;
    token = newToken;
  }

  // 翻译默认使用 gpt-4o-mini, 能更节省钱
  Future<String> translate(String text, {String model = 'gpt-4o-mini'}) async {
    if (!isProduction) {
      return text;
    }

    if (text.isEmpty) {
      return '';
    }
    // 控制文本长度，确保不要把token撑爆了
    if (text.length >= 200) {
      text = text.substring(0, 200);
    }
    var result =
        await openChatRequest(model, "翻译 $text 到中文, 直接给翻译结果就行，不要给其他任何的解释");
    // var result = await DeeplxService.to.translate(text);
    logger.i('[AI 翻译] $text => $result');
    return result;
  }

  Future<String> readAndTranslate(String text,
      {String model = 'gpt-4o-mini', int maxLength = 200}) async {
    if (!isProduction) {
      return text;
    }

    if (text.isEmpty) {
      return '';
    }
    // 控制文本长度，确保不要把token撑爆了
    if (text.length >= maxLength) {
      text = text.substring(0, maxLength);
    }
    // var result = await DeeplxService.to.translate(text);
    var result = await openChatRequest(model,
        "$text \n 提取上面文字的核心内容，并通过尽可能短的，不超过 $maxLength 个字的中文总结出来, 直接给结果，不要给其他任何的解释");
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
