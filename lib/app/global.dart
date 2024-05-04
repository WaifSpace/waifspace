import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:html/parser.dart' as html;

final dio = Dio();
final talker = Talker(
  settings: TalkerSettings(
    enabled: true,
    useHistory: true,
    maxHistoryItems: 100,
    useConsoleLogs: false,
  ),
  logger: TalkerLogger(),
);

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

String htmlToText(String htmlText) {
  // var text =
  //     Bidi.stripHtmlIfNeeded(html.replaceAll(RegExp(r'<br\s*/?>|</p>'), "\n"));

  var document = html.parse(htmlText);

  return document.body!.text.split("\n")
      .map((e) => e.trim())
      .where((element) => element.isNotEmpty)
      .join("\n\n");;
}

RegExp _exp = RegExp(r"[\u4e00-\u9fa5]");
bool isChinese(String input) {
  return _exp.hasMatch(input);
}

void showMsg(String msg, BuildContext context, {ToastificationType type = ToastificationType.success, int seconds = 3}) {
  if (!context.mounted) return;
  toastification.show(
    context: context,
    type: type,
    style: ToastificationStyle.fillColored,
    title: Text(msg),
    autoCloseDuration: Duration(seconds: seconds),
    showProgressBar: false,
    alignment: Alignment.topCenter,
  );
}
