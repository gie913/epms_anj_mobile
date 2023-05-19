
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:epms/model/m_customer_code_schema.dart';
import 'package:sqflite/sqflite.dart';
import '../entity/m_customer_code_entity.dart';

class DatabaseMCustomerCodeSchema {

  void createCustomerCodeSchemaTable(Database db) async {
    // await db.execute('''
    //   CREATE TABLE $mCustomerCodeSchemaTable(
    //    ${MCustomerCodeEntity.customerCodeId} INT NOT NULL,
    //    ${MCustomerCodeEntity.customerPlantCode} TEXT,
    //    ${MCustomerCodeEntity.customerCode} TEXT,
    //    ${MCustomerCodeEntity.createdBy} TEXT,
    //    ${MCustomerCodeEntity.createdDate} TEXT,
    //    ${MCustomerCodeEntity.createdTime} TEXT,
    //    ${MCustomerCodeEntity.updatedBy} TEXT,
    //    ${MCustomerCodeEntity.updatedDate} TEXT,
    //    ${MCustomerCodeEntity.updatedTime} TEXT)
    // ''');
    await db.execute('''
      CREATE TABLE $mCustomerCodeSchemaTable(
       ${MCustomerCodeEntity.customerCodeId} INT NOT NULL,
       ${MCustomerCodeEntity.customerPlantCode} TEXT,
       ${MCustomerCodeEntity.customerCode} TEXT)
    ''');
  }
  Future<int> insertMCustomerCodeSchema(List<MCustomerCodeSchema> object) async {
    Database db = await DatabaseHelper().database;
    // int count = 0;
    // List<MCustomerCodeSchema> listCustomer = await selectMCustomerCodeSchema();
    // for (int i = 0; i < object.length; i++) {
    //     if(!(listCustomer.contains(object[i]))) {
    //       int saved = await db.insert(mCustomerCodeSchemaTable, object[i].toJson());
    //       count = count + saved;
    //     }
    // }
    // return count;
    Batch batch = db.batch();
    object.forEach((val) {
      MCustomerCodeSchema mCustomerCodeSchema =  val;
      batch.insert(mCustomerCodeSchemaTable, mCustomerCodeSchema.toJson());
    });
    List<Object?> i = await batch.commit();
    return i.length;
  }

  Future<List<MCustomerCodeSchema>> selectMCustomerCodeSchema() async {
    Database db = await DatabaseHelper().database;
    var mapList = await db.query(mCustomerCodeSchemaTable);
    List<MCustomerCodeSchema> list = [];
    for (int i = 0; i < mapList.length; i++) {
      MCustomerCodeSchema mCustomerCodeSchema = MCustomerCodeSchema.fromJson(mapList[i]);
      list.add(mCustomerCodeSchema);
    }
    return list;
  }

  void deleteMCustomerCodeSchema() async {
    Database db = await DatabaseHelper().database;
    db.delete(mCustomerCodeSchemaTable);
  }
}
