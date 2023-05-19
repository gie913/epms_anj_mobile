import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/database/service/database_activity.dart';
import 'package:epms/database/service/database_attendance.dart';
import 'package:epms/database/service/database_cost_control.dart';
import 'package:epms/database/service/database_destination.dart';
import 'package:epms/database/service/database_harvesting_plan.dart';
import 'package:epms/database/service/database_laporan_panen_kemarin.dart';
import 'package:epms/database/service/database_laporan_restan.dart';
import 'package:epms/database/service/database_laporan_spb_kemarin.dart';
import 'package:epms/database/service/database_m_ancak_employee.dart';
import 'package:epms/database/service/database_m_attendance.dart';
import 'package:epms/database/service/database_m_block.dart';
import 'package:epms/database/service/database_m_customer_code.dart';
import 'package:epms/database/service/database_m_division.dart';
import 'package:epms/database/service/database_m_employee.dart';
import 'package:epms/database/service/database_m_estate.dart';
import 'package:epms/database/service/database_m_material.dart';
import 'package:epms/database/service/database_m_tph.dart';
import 'package:epms/database/service/database_m_vendor.dart';
import 'package:epms/database/service/database_m_vra.dart';
import 'package:epms/database/service/database_mc_oph.dart';
import 'package:epms/database/service/database_mc_spb.dart';
import 'package:epms/database/service/database_t_abw.dart';
import 'package:epms/database/service/database_t_user_assignment.dart';

class DeleteMaster {

  Future<bool> deleteMasterData() async {
    try {
      StorageManager.deleteData("lastSynchTime");
      StorageManager.deleteData("lastSynchDate");
      DatabaseMActivitySchema().deleteMActivitySchema();
      DatabaseMCOPHSchema().deleteMCOPHSchema();
      DatabaseMCSPBCardSchema().deleteMCSPBCardSchema();
      DatabaseMCostControlSchema().deleteMCostControlSchema();
      DatabaseMCustomerCodeSchema().deleteMCustomerCodeSchema();
      DatabaseMDivisionSchema().deleteMDivisionSchema();
      DatabaseMDestinationSchema().deleteMDestinationSchema();
      DatabaseMMaterialSchema().deleteMMaterialSchema();
      DatabaseMTPHSchema().deleteMTPHSchema();
      DatabaseMVRASchema().deleteMVRASchema();
      DatabaseTUserAssignment().deleteEmployeeTUserAssignment();
      DatabaseLaporanPanenKemarin().deleteLaporanPanenKemarin();
      DatabaseTHarvestingPlan().deleteTHarvestingPlan();
      DatabaseLaporanRestan().deleteLaporanRestan();
      DatabaseLaporanSPBKemarin().deleteLaporanSPBKemarin();
      DatabaseMVendorSchema().deleteMVendorSchema();
      DatabaseMEstateSchema().deleteMEstateSchema();
      DatabaseMEmployeeSchema().deleteMEmployeeSchema();
      DatabaseAttendance().deleteEmployeeAttendance();
      DatabaseMAttendance().deleteEmployeeAttendance();
      DatabaseMBlockSchema().deleteMBlockSchema();
      DatabaseMAncakEmployee().deleteMAncakEmployeeSchema();
      DatabaseTABWSchema().deleteTABWSchema();
      return true;
    } catch (E) {
      return false;
    }
  }
}