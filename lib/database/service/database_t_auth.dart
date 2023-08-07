import 'package:epms/database/entity/t_auth_entity.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/auth_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseTAuth {
  void createTableTAuth(Database db) async {
    await db.execute('''
      CREATE TABLE $tAuth(
       ${TAuthEntity.supervisiName} TEXT NOT NULL,
       ${TAuthEntity.pin} TEXT NOT NULL)
    ''');
  }

  static Future<void> insertTAuth(List<AuthModel> data) async {
    Database db = await DatabaseHelper().database;
    for (var element in data) {
      await db.insert(tAuth, element.toJson());
    }
  }

  Future<List<AuthModel>> selectTAuth() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(tAuth);
    final tAuthList =
        List<AuthModel>.from(mapList.map((e) => AuthModel.fromJson(e)));
    return tAuthList;
  }

  void deleteTAuth() async {
    Database db = await DatabaseHelper().database;
    db.delete(tAuth);
  }
}
