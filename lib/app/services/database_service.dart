import 'dart:collection';

import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:waifspace/app/global.dart';

class DatabaseService extends GetxService {
  late Database db;
  final String _database = 'waifspace.db';
  Future<DatabaseService> init() async {
    var dbPath = path.join(await getDatabasesPath(), _database);
    logger.i("打开数据库: $dbPath");
    db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        logger.d("创建数据库 version: $version");
        var batch = db.batch();
        _migrations.forEach((name, sqls) {
          logger.d("执行数据库迁移脚本: $name");
          for(var sql in sqls) {
            batch.execute(sql);
          }
        });
        await batch.commit();
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        logger.d("更新数据库 version: $oldVersion => $newVersion");
        var batch = db.batch();
        var index = 1;
        _migrations.forEach((name, sqls) {
          if(index > oldVersion && index <= newVersion) {
            logger.d("执行数据库迁移脚本: $name");
            for(var sql in sqls) {
              batch.execute(sql);
            }
          }
          index++;
        });
        await batch.commit();
      },
      onDowngrade: onDatabaseDowngradeDelete,
    );
    logger.i("数据库当前版本 ${await db.getVersion()}");
    return this;
  }

  final LinkedHashMap<String, List<String>> _migrations = LinkedHashMap<String, List<String>>.from({
    "01_初始化数据库": [
      '''CREATE TABLE IF NOT EXISTS Articles (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          cn_title TEXT,
          content TEXT,
          cn_content TEXT,
          url TEXT,
          image_url TEXT,  -- 文章banner图片URL
          image_path TEXT, -- 图片本地保存路径 
          is_read INTEGER DEFAULT 0,
          is_favorite INTEGER DEFAULT 0,
          source_id INTEGER,
          source_uid TEXT, -- 原始文章的唯一ID，用来避免重复抓取，一般用URL 和 source_id一起构成唯一索引
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
          updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (source_id) REFERENCES ArticleSources(id)
      )''',
      '''CREATE TABLE IF NOT EXISTS ArticleSources (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          url TEXT,
          type TEXT, -- 数据源的类型，例如 RSS 未来还可以支持更多的
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
          updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )'''
    ],
  });
}
