import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:waifspace/app/data/models/setting_model.dart';
import 'package:waifspace/app/services/database_service.dart';
import 'package:waifspace/app/services/hive_service.dart';

class SettingProvider {
  static String table = "settings";
  static String keyOpenAIUrl = "openai_url";
  static String keyOpenAIToken = "openai_token";

  static const _tokenConfigName = 'chatgpt_token';
  static const _urlConfigName = 'chatgpt_url';

  SettingProvider._build();

  static Future<SettingProvider> build() async {
    var articleSource = SettingProvider._build();
    await articleSource.migrateFromHive();
    return articleSource;
  }

  static SettingProvider get to => Get.find<SettingProvider>();

  final Database db = Get.find<DatabaseService>().db;

  Future<void> migrateFromHive() async {
    var hive = Get.find<HiveService>();
    var token = hive.box.get(_tokenConfigName);
    var url = hive.box.get(_urlConfigName);
    if (token != null && url != null) {
      await saveOpenAIToken(token);
      await saveOpenAIUrl(url);
    }
    // 清除 Hive 中的值
    hive.box.delete(_tokenConfigName);
    hive.box.delete(_urlConfigName);
  }

  Future<String?> getOpenAIUrl() async {
    var setting = await findByKey(keyOpenAIUrl);
    return setting?.value;
  }

  Future<String?> getOpenAIToken() async {
    var setting = await findByKey(keyOpenAIToken);
    return setting?.value;
  }

  Future<void> saveOpenAIUrl(String url) async {
    await addOrUpdate(keyOpenAIUrl, url);
  }

  Future<void> saveOpenAIToken(String token) async {
    await addOrUpdate(keyOpenAIToken, token);
  }

  Future<Setting?> findByKey(String key) async {
    var maps = await db.query(table, where: 'key = ?', whereArgs: [key]);
    if (maps.isEmpty) {
      return null;
    }
    return Setting.fromJson(maps[0]);
  }

  Future<void> addOrUpdate(String key, String value) async {
    var setting = await findByKey(key);
    if (setting == null) {
      await create(key, value);
    } else {
      await update(key, value);
    }
  }

  Future<Setting> create(String key, String value) async {
    var setting = Setting(key: key, value: value);
    await db.insert(table, setting.toJson());
    return setting;
  }

  Future<void> update(String key, String value) async {
    await db.update(table, {'value': value},
        where: 'key = ?', whereArgs: [key]);
  }
}
