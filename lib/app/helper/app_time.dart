import 'dart:io';

import 'package:timeago/timeago.dart' as timeago;

class AppTime {
  final String _gmtFormat = 'E, d MMM yyyy HH:mm:ss';
  late DateTime _datetime;

  AppTime.parseGMT(String datetimeStr) {
    try {
      _datetime = HttpDate.parse(datetimeStr);
    } catch (e) {
      // 如果文章的日期格式不对，默认使用 当前时间。但是这个逻辑处理不是合理
      // https://androidweekly.net/rss.xml, 他返回的日期格式是 Sun, 15 Oct 2023 10:14:41 +0000, 目前解析不了
      _datetime = DateTime.tryParse(datetimeStr) ?? DateTime.now();
    }
  }

  AppTime.parse(String datetimeStr) {
    _datetime = DateTime.parse(datetimeStr);
  }

  AppTime.now() {
    _datetime = DateTime.now();
  }

  AppTime.fromNow(int hours) {
    DateTime currentTime = DateTime.now();
    _datetime = currentTime.subtract(Duration(hours: hours));
  }

  String dbFormat() {
    return _datetime.toLocal().toString();
  }

  String viewFormat() {
    return timeago.format(_datetime, locale: 'zh_CN');
  }
}