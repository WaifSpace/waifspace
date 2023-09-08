import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService  {
  HiveService._build();

  static Future<HiveService> build() async {
    var hiveService = HiveService._build();
    await hiveService.init();
    return hiveService;
  }

  static HiveService get to => Get.find<HiveService>();

  late Box box;

  Future<HiveService> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.defaultDirectory = dir.path;

    box = Hive.box();
    return this;
  }
}