import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

Logger debugLogger = Logger();
Logger logger = Logger(
  printer: SimplePrinter(),
);

bool get isProduction => const bool.fromEnvironment("dart.vm.product");

String htmlToText(String html) {
  return Bidi.stripHtmlIfNeeded(html.replaceAll('<br>', "\n"));
}