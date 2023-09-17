import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

final dio = Dio();

Logger logger = Logger(
  printer: SimplePrinter(colors: false),
  output: _ConsoleOutput(),
);

class _ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      log(line, name: 'WaifSpace');
    }
  }
}

bool get isProduction => const bool.fromEnvironment("dart.vm.product");

String htmlToText(String html) {
  var text =
      Bidi.stripHtmlIfNeeded(html.replaceAll(RegExp(r'<br\s*/?>|</p>'), "\n"));
  return text
      .split("\n")
      .map((e) => e.trim())
      .where((element) => element.isNotEmpty)
      .join("\n\n");
}

RegExp _exp = RegExp(r"[\u4e00-\u9fa5]");
bool isChinese(String input) {
  return _exp.hasMatch(input);
}
