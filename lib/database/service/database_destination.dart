import 'package:epms/database/entity/m_destination_entity.dart';
import 'package:epms/model/m_destination_schema.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database_table.dart';
import '../helper/database_helper.dart';

class DatabaseMDestinationSchema {
  void createTableMDestinationSchema(Database db) async {
    await db.execute('''
      CREATE TABLE $mDestinationSchemaTable(
       ${MDestinationEntity.destinationId} INT NOT NULL,
       ${MDestinationEntity.destinationCode} TEXT,
       ${MDestinationEntity.destinationName} TEXT,
       ${MDestinationEntity.createdBy} TEXT,
       ${MDestinationEntity.createdDate} TEXT,
       ${MDestinationEntity.createdTime} TEXT,
       ${MDestinationEntity.updatedBy} TEXT,
       ${MDestinationEntity.updatedDate} TEXT,
       ${MDestinationEntity.updatedTime} TEXT)
    ''');
  }

  Future<int> insertMDestinationSchema(List<MDestinationSchema> object) async {
    Database db = await DatabaseHelper().database;
    int count = 0;
    for (int i = 0; i < object.length; i++) {
        int saved =
            await db.insert(mDestinationSchemaTable, object[i].toJson());
        count = count + saved;
    }
    return count;
  }

  Future<List<MDestinationSchema>> selectMDestinationSchema() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mDestinationSchemaTable);
    List<MDestinationSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MDestinationSchema mDestinationSchema =
          MDestinationSchema.fromJson(mapList[i]);
      list.add(mDestinationSchema);
    }
    return list;
  }

  void deleteMDestinationSchema() async {
    Database db = await DatabaseHelper().database;
    db.delete(mDestinationSchemaTable);
  }
}
