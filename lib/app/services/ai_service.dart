import 'package:dart_openai/dart_openai.dart';
import 'package:get/get.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/services/hive_service.dart';

class AIService {
  static const _tokenConfigName = 'chatgpt_token';
  static const _urlConfigName = 'chatgpt_url';

  static String get token =>
      HiveService.to.box.get(_tokenConfigName, defaultValue: '');
  static set token(String value) =>
      HiveService.to.box.put(_tokenConfigName, value);

  static String get url =>
      HiveService.to.box.get(_urlConfigName, defaultValue: '');
  static set url(String value) => HiveService.to.box.put(_urlConfigName, value);

  AIService._build();

  static Future<AIService> build() async {
    var aiService = AIService._build();
    aiService.init();
    return aiService;
  }

  static AIService get to => Get.find<AIService>();

  void init() {
    OpenAI.apiKey = token;
    OpenAI.baseUrl = url;
    OpenAI.showLogs =false;
  }

  Future<String> translate(String text, {String model = 'gpt-4'}) async {
    if(text.isEmpty) {
      return '';
    }
    // 控制文本长度，确保不要把token撑爆了
    if(text.length >= 400) {
      text = text.substring(0, 400);
    }
    OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
      model: model,
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: "翻译 $text 到中文",
          role: OpenAIChatMessageRole.user,
        ),
      ],
    );
    var result = chatCompletion.choices.first.message.content;
    logger.i('[AI 翻译] $text => $result');
    return result;
  }


  Future<String> readAndTranslate(String text, {String model = 'gpt-4', int maxLength = 200 }) async {
    if(text.isEmpty) {
      return '';
    }
    // 控制文本长度，确保不要把token撑爆了
    if(text.length >= 400) {
      text = text.substring(0, 400);
    }

    OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
      // model: "gpt-3.5-turbo",
      // model: "gpt-4",
      model: model,
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: "$text \n 提取上面文字的核心内容，并通过尽可能短的，不超过 $maxLength 个字的中文总结出来",
          role: OpenAIChatMessageRole.user,
        ),
      ],
    );
    var result = chatCompletion.choices.first.message.content;
    return result;
  }
}