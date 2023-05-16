import 'package:epms/database/entity/m_vendor_entity.dart';
import 'package:epms/model/m_vendor_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_table.dart';
import '../helper/database_helper.dart';

class DatabaseMVendorSchema {
  void createTableMVendorSchema(Database db) async {
    await db.execute('''
      CREATE TABLE $mVendorSchemaTable(
       ${MVendorEntity.vendorId} INT NOT NULL,
       ${MVendorEntity.vendorCode} TEXT,
       ${MVendorEntity.vendorName} TEXT,
       ${MVendorEntity.createdBy} TEXT,
       ${MVendorEntity.createdDate} TEXT,
       ${MVendorEntity.createdTime} TEXT,
       ${MVendorEntity.updatedBy} TEXT,
       ${MVendorEntity.updatedDate} TEXT,
       ${MVendorEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertMVendorSchema(List<MVendorSchema> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    for (int i = 0; i < object.length; i++) {
        int saved = await db.insert(mVendorSchemaTable, object[i].toJson());
        count = count + saved;
    }
    return count;
  }

  Future<List<MVendorSchema>> selectMVendorSchema() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mVendorSchemaTable);
    List<MVendorSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MVendorSchema mVendorSchema = MVendorSchema.fromJson(mapList[i]);
      list.add(mVendorSchema);
    }
    return list;
  }

  void deleteMVendorSchema() async {
    Database db = await DatabaseHelper().database;
    db.delete(mVendorSchemaTable);
  }
}
