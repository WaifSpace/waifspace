import 'package:logger/logger.dart';

Logger debugLogger = Logger();
Logger logger = Logger(
  printer: SimplePrinter(),
);

bool get isProduction => const bool.fromEnvironment("dart.vm.product");
