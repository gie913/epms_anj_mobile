import 'package:epms/database/entity/laporan_spb_kemarin_entity.dart';
import 'package:epms/database/entity/spb_supervise_entity.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/helper/database_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseLocalUpdate {
  void addNewColumnOnVersion() async {
    Database db = await DatabaseHelper().database;
    try {
      await db.rawQuery(
          "ALTER TABLE $tSPBSuperviseSchemaListTable ADD COLUMN ${SPBSuperviseEntity.bunchesTangkaiPanjang} INT;");
    } catch (e) {
      print("Column received via exist");
    }
    try {
      await db.rawQuery(
          "ALTER TABLE $laporanSPBKemarinTable ADD COLUMN ${LaporanSPBKemarinEntity.createdTime} TEXT;");
    } catch (e) {
      print("Column received via exist");
    }
    try {
      await db.rawQuery(
          "ALTER TABLE $laporanSPBKemarinTable ADD COLUMN ${LaporanSPBKemarinEntity.createdDate} TEXT;");
    } catch (e) {
      print("Column received via exist");
    }
  }
}
