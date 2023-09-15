import 'package:dart_openai/dart_openai.dart';
import 'package:get/get.dart';
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
  }

  Future<String> readAndTranslate(String text) async {
    if(text.isEmpty) {
      return '';
    }
    // 控制文本长度，确保不要把token撑爆了
    if(text.length >= 200) {
      text = text.substring(0, 200);
    }
    OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      // model: "gpt-4",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: "请将文章的核心内容总结出来并转成中文，要求总数控制在200字以内，输出内容要简洁清晰, 语句通顺好读, 内容如下: $text",
          role: OpenAIChatMessageRole.user,
        ),
      ],
    );
    return chatCompletion.choices.first.message.content;
  }
}
