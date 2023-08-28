import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

Logger debugLogger = Logger();
Logger logger = Logger(
  printer: SimplePrinter(),
);

bool get isProduction => const bool.fromEnvironment("dart.vm.product");

String htmlToText(String html) {
  var text =  Bidi.stripHtmlIfNeeded(html.replaceAll(RegExp(r'<br\s*/?>|</p>'), "\n"));
  return text.split("\n").map((e) => e.trim()).where((element) => element.isNotEmpty).join("\n\n");
}