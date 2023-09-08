import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waifspace/app/services/hive_service.dart';

class CuboxService {
  static save(String title, String url, String description) async {
    try {
      var response = await http.post(
          Uri.parse(HiveService.to.box.get('cubox_url')),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'type': 'url',
            'content': url,
            'description': description,
            'title': title,
            'folder': 'waifspace',
          }));
      var jsonResponse =
      json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      if (response.statusCode == 200 && jsonResponse['code'] == 200) {
        _showMsg("Cubox $title 保存成功");
      } else {
        _showMsg("Cubox $title 保存失败");
      }
    } catch (e) {
      _showMsg("Cubox $title 保存失败");
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