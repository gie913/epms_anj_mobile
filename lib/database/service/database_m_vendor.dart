import 'package:epms/database/entity/m_vendor_entity.dart';
import 'package:epms/model/m_vendor_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_table.dart';
import '../helper/database_helper.dart';

class DatabaseMVendorSchema {
  void createTableMVendorSchema(Database db) async {
    // await db.execute('''
    //   CREATE TABLE $mVendorSchemaTable(
    //    ${MVendorEntity.vendorId} INT NOT NULL,
    //    ${MVendorEntity.vendorCode} TEXT,
    //    ${MVendorEntity.vendorName} TEXT,
    //    ${MVendorEntity.createdBy} TEXT,
    //    ${MVendorEntity.createdDate} TEXT,
    //    ${MVendorEntity.createdTime} TEXT,
    //    ${MVendorEntity.updatedBy} TEXT,
    //    ${MVendorEntity.updatedDate} TEXT,
    //    ${MVendorEntity.updatedTime} TEXT)
    // ''');
    await db.execute('''
      CREATE TABLE $mVendorSchemaTable(
       ${MVendorEntity.vendorId} INT NOT NULL,
       ${MVendorEntity.vendorCode} TEXT,
       ${MVendorEntity.vendorName} TEXT)
    ''');
  }

  Future<int> insertMVendorSchema(List<MVendorSchema> object) async {
    Database db = await DatabaseHelper().database;
    // List<MVendorSchema> listVendor  = await selectMVendorSchema();
    // int count = 0;
    // for (int i = 0; i < object.length; i++) {
    //    if(!(listVendor.contains(object[i]))) {
    //      int saved = await db.insert(mVendorSchemaTable, object[i].toJson());
    //      count = count + saved;
    //    }
    // }
    // return count;
    Batch batch = db.batch();
    object.forEach((val) {
      MVendorSchema mVendorSchema = val;
      batch.insert(mVendorSchemaTable, mVendorSchema.toJson());
    });
    List<Object?> i = await batch.commit();
    return i.length;
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

  Future<MVendorSchema> selectMVendorSchemaByCode(String code) async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(
      mVendorSchemaTable,
      where: '${MVendorEntity.vendorCode}=?',
      whereArgs: [code],
    );

    if (mapList.isNotEmpty) {
      MVendorSchema data = MVendorSchema.fromJson(mapList.first);

      return data;
    } else {
      return MVendorSchema();
    }
  }

  void deleteMVendorSchema() async {
    Database db = await DatabaseHelper().database;
    db.delete(mVendorSchemaTable);
  }
}
