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

  Future<void> readAndTranslate(String text) async {
    if(text.isEmpty) {
      return;
    }
    // 控制文本长度，确保不要把token撑爆了
    if(text.length >= 500) {
      text = text.substring(0, 500);
    }
    OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
      // model: "gpt-3.5-turbo",
      model: "gpt-4",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: "假如我是一个编辑，我会读懂文章的内容然后以记者的角度把关键点重新用中文写出来，要求总数控制在300字以内，输出内容要简洁清晰, 语句通顺好读: 内容如下 $text",
          role: OpenAIChatMessageRole.user,
        ),
      ],
    );
    print(chatCompletion.choices.first.message.content);
  }
}
