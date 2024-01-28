import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:waifspace/app/global.dart';
import 'package:waifspace/app/services/hive_service.dart';

class CuboxService {
  static const _urlConfigName = 'cubox_url';
  static String get url => HiveService.to.box.get(_urlConfigName, defaultValue: '');
  static set url(String value) => HiveService.to.box.put(_urlConfigName, value);

  static final _dio = Dio();

  static save(String title, String articleUrl, String description, BuildContext context) async {
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
        if (!context.mounted) return;
        showMsg("Cubox 保存成功 $title ", context);
      } else {
        if (!context.mounted) return;
        showMsg("Cubox 保存失败 $title ", context, type: ToastificationType.error);
      }
    } catch (e) {
      if (!context.mounted) return;
      showMsg("Cubox 保存失败 $title ", context, type: ToastificationType.error);
    }
  }

}