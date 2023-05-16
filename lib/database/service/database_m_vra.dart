import 'package:epms/database/entity/m_vra_entity.dart';
import 'package:epms/model/m_vras_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_helper.dart';
import '../helper/database_table.dart';

class DatabaseMVRASchema {
  void createTableMVRASchema(Database db) async {
    await db.execute('''
      CREATE TABLE $mVRASchemaTable(
       ${MVRAEntity.vraId} INT NOT NULL,
       ${MVRAEntity.vraLicenseNumber} TEXT,
       ${MVRAEntity.vraMaxCap} REAL,
       ${MVRAEntity.vraValidFrom} TEXT,
       ${MVRAEntity.vraValidTo} TEXT,
       ${MVRAEntity.createdBy} TEXT,
       ${MVRAEntity.createdDate} TEXT,
       ${MVRAEntity.createdTime} TEXT,
       ${MVRAEntity.updatedBy} TEXT,
       ${MVRAEntity.updatedDate} TEXT,
       ${MVRAEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertMVRASchema(List<MVRASchema> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    for (int i = 0; i < object.length; i++) {
      int saved = await db.insert(mVRASchemaTable, object[i].toJson());
      count = count + saved;
    }
    return count;
  }

  Future<List<MVRASchema>> selectMVRASchema() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mVRASchemaTable);
    List<MVRASchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MVRASchema mVRASchema = MVRASchema.fromJson(mapList[i]);
      list.add(mVRASchema);
    }
    return list;
  }

  Future<MVRASchema?> selectMVRASchemaByNumber(String number) async {
    MVRASchema? mVRASchema;
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mVRASchemaTable,
        where: "${MVRAEntity.vraLicenseNumber} = ?", whereArgs: [number]);
    if (mapList.isNotEmpty) {
      mVRASchema = MVRASchema.fromJson(mapList[0]);
    }
    return mVRASchema;
  }

  void deleteMVRASchema() async {
    Database db = await DatabaseHelper().database;
    db.delete(mVRASchemaTable);
  }
}
