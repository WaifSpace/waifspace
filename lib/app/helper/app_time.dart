import 'package:jiffy/jiffy.dart';

class AppTime {
  final String _gmtFormat = 'E, d MMM yyyy HH:mm:ss';
  late Jiffy _datetime;

  AppTime.parseGMT(String datetimeStr) {
    _datetime = Jiffy.parse(datetimeStr, pattern: _gmtFormat);
  }

  AppTime.parse(String datetimeStr) {
    _datetime = Jiffy.parse(datetimeStr);
  }

  AppTime.now() {
    _datetime = Jiffy.now();
  }

  String dbFormat() {
    return _datetime.format();
  }

  String viewFormat() {
    return _datetime.fromNow();
  }
}