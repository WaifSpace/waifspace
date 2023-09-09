import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waifspace/app/services/hive_service.dart';

class CuboxService {
  static const _urlConfigName = 'cubox_url';
  static String get url => HiveService.to.box.get(_urlConfigName, defaultValue: '');
  static set url(String value) => HiveService.to.box.put(_urlConfigName, value);

  static final _dio = Dio();

  static save(String title, String articleUrl, String description) async {
    try {
      var response = await _dio.post(
          url,
          options: Options(
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
          ),
          data: jsonEncode({
            'type': 'url',
            'content': articleUrl,
            'description': description,
            'title': title,
            'folder': 'waifspace',
          }));
      if (response.statusCode == 200 && response.data['code'] == 200) {
        _showMsg("Cubox 保存成功 $title ");
      } else {
        _showMsg("Cubox 保存失败 $title ");
      }
    } catch (e) {
      _showMsg("Cubox 保存失败 $title ");
    }
  }

  static void _showMsg(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP
    );
  }
}