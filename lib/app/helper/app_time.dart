import 'package:jiffy/jiffy.dart';

class AppTime {
  final String _gmtFormat = 'E, d MMM yyyy HH:mm:ss';
  late Jiffy _datetime;

  AppTime.parseGMT(String datetimeStr) {
    _datetime = Jiffy.parse(datetimeStr, pattern: _gmtFormat);
  }

  AppTime.now() {
    _datetime = Jiffy.now();
  }

  String format() {
    return _datetime.format();
  }
}