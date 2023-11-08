import 'dart:io';

import 'package:epms/database/service/database_action_inspection.dart';
import 'package:epms/database/service/database_activity.dart';
import 'package:epms/database/service/database_attendance.dart';
import 'package:epms/database/service/database_company_inspection.dart';
import 'package:epms/database/service/database_cost_control.dart';
import 'package:epms/database/service/database_destination.dart';
import 'package:epms/database/service/database_division_inspection.dart';
import 'package:epms/database/service/database_harvesting_plan.dart';
import 'package:epms/database/service/database_access_inspection.dart';
import 'package:epms/database/service/database_laporan_panen_kemarin.dart';
import 'package:epms/database/service/database_laporan_restan.dart';
import 'package:epms/database/service/database_laporan_spb_kemarin.dart';
import 'package:epms/database/service/database_m_ancak_employee.dart';
import 'package:epms/database/service/database_m_attendance.dart';
import 'package:epms/database/service/database_m_block.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_m_customer_code.dart';
import 'package:epms/database/service/database_m_division.dart';
import 'package:epms/database/service/database_m_employee.dart';
import 'package:epms/database/service/database_m_estate.dart';
import 'package:epms/database/service/database_m_material.dart';
import 'package:epms/database/service/database_m_tph.dart';
import 'package:epms/database/service/database_m_vendor.dart';
import 'package:epms/database/service/database_m_vra.dart';
import 'package:epms/database/service/database_material.dart';
import 'package:epms/database/service/database_mc_oph.dart';
import 'package:epms/database/service/database_mc_spb.dart';
import 'package:epms/database/service/database_member_inspection.dart';
import 'package:epms/database/service/database_oph.dart';
import 'package:epms/database/service/database_oph_supervise.dart';
import 'package:epms/database/service/database_oph_supervise_ancak.dart';
import 'package:epms/database/service/database_spb.dart';
import 'package:epms/database/service/database_spb_detail.dart';
import 'package:epms/database/service/database_spb_loader.dart';
import 'package:epms/database/service/database_spb_supervise.dart';
import 'package:epms/database/service/database_supervisor.dart';
import 'package:epms/database/service/database_t_abw.dart';
import 'package:epms/database/service/database_t_auth.dart';
import 'package:epms/database/service/database_t_user_assignment.dart';
import 'package:epms/database/service/database_t_workplan_schema.dart';
import 'package:epms/database/service/database_tbs_luar.dart';
import 'package:epms/database/service/database_tbs_luar_one_month.dart';
import 'package:epms/database/service/database_team_inspection.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/database/service/database_user_inspection.dart';
import 'package:epms/database/service/database_user_inspection_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _dbHelper;
  static Database? _database;

  DatabaseHelper._createObject();

  factory DatabaseHelper() {
    if (_dbHelper == null) {
      _dbHelper = DatabaseHelper._createObject();
    }
    return _dbHelper!;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'db_epms.db';
    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return todoDatabase;
  }

  void _createDb(Database db, int version) async {
    DatabaseMConfig().createTableMConfig(db);
    DatabaseMEmployeeSchema().createTableMEmployeeSchema(db);
    DatabaseAttendance().createTableAttendance(db);
    DatabaseSupervisor().createTableSupervisor(db);
    DatabaseMActivitySchema().createTableMActivity(db);
    DatabaseMAttendance().createTableMAttendance(db);
    DatabaseMBlockSchema().createTableMBlockSchema(db);
    DatabaseMCostControlSchema().createMCostControlSchema(db);
    DatabaseMCustomerCodeSchema().createCustomerCodeSchemaTable(db);
    DatabaseMDestinationSchema().createTableMDestinationSchema(db);
    DatabaseMDivisionSchema().createTableMDivisionSchema(db);
    DatabaseMEstateSchema().createTableMEstateSchema(db);
    DatabaseMMaterialSchema().createTableMMaterialSchema(db);
    DatabaseMTPHSchema().createTableMTPHSchema(db);
    DatabaseMVendorSchema().createTableMVendorSchema(db);
    DatabaseMVRASchema().createTableMVRASchema(db);
    DatabaseMCOPHSchema().createTableMCOPHSchema(db);
    DatabaseMCSPBCardSchema().createTableMCSPBSchema(db);
    DatabaseLaporanSPBKemarin().createTableLaporanSPBKemarin(db);
    DatabaseOPH().createTableOPH(db);
    DatabaseLaporanRestan().createLaporanRestan(db);
    DatabaseLaporanPanenKemarin().createLaporanPanenKemarin(db);
    DatabaseTHarvestingPlan().createTHarvestingPlan(db);
    DatabaseTUserAssignment().createTableUserAssignmentSchema(db);
    DatabaseTABWSchema().createTableTABWSchema(db);
    DatabaseSPB().createTableSPB(db);
    DatabaseSPBDetail().createTableSPBDetail(db);
    DatabaseSPBLoader().createTableSPBLoader(db);
    DatabaseMAncakEmployee().createTableMAncakEmployeeSchema(db);
    DatabaseOPHSupervise().createTableOPHSupervise(db);
    DatabaseOPHSuperviseAncak().createTableOPH(db);
    DatabaseSPBSupervise().createTableSPB(db);
    DatabaseTWorkplanSchema().createTWorkPlan(db);
    DatabaseMaterial().createMaterial(db);
    DatabaseTBSLuar().createTableTBSLuar(db);
    DatabaseTBSLuarOneMonth().createTableTBSLuarOneMonth(db);
    DatabaseTAuth().createTableTAuth(db);
    // Inspection
    DatabaseTicketInspection().createTable(db);
    DatabaseUserInspectionConfig().createTable(db);
    DatabaseUserInspection().createTable(db);
    DatabaseTeamInspection().createTable(db);
    DatabaseMemberInspection().createTable(db);
    DatabaseAccessInspection().createTable(db);
    DatabaseActionInspection().createTable(db);
    DatabaseCompanyInspection().createTable(db);
    DatabaseDivisionInspection().createTable(db);
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database!;
  }

  void deleteMasterDataInspection() {
    DatabaseTicketInspection.deleteTable();
    DatabaseUserInspectionConfig.deleteTable();
    DatabaseUserInspection.deleteTable();
    DatabaseTeamInspection.deleteTable();
    DatabaseMemberInspection.deleteTable();
    DatabaseAccessInspection.deleteTable();
    DatabaseActionInspection.deleteTable();
    DatabaseCompanyInspection.deleteTable();
    DatabaseDivisionInspection.deleteTable();
  }
}
