import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/base/constants/globals.dart' as globals;
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/common_manager/value_service.dart';
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
import 'package:epms/database/service/database_m_config.dart';
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
import 'package:epms/database/service/database_t_workplan_schema.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/sync_response_revamp.dart';
import 'package:epms/screen/home/home_notifier.dart';
import 'package:epms/screen/synch/synch_repository.dart';
import 'package:flutter/material.dart';

class SynchNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  String _dataText = "";

  String get dataText => _dataText;

  doSynchMasterData(BuildContext context) async {
    MConfigSchema mConfigSchema = await DatabaseMConfig().selectMConfig();
    SynchRepository().doPostSynch(
        context, mConfigSchema.estateCode!, onSuccessSynch, onErrorSynch);
  }

  onSuccessSynch(BuildContext context, SynchResponse synchResponse) {
    saveDatabase(context, synchResponse);
  }

  onErrorSynch(BuildContext context, String message) {
    print(message);
    _dialogService.showOptionDialog(
        title: "Gagal Synch",
        subtitle: "Gagal pada saat sinkronisasi",
        buttonTextYes: "Ulang",
        buttonTextNo: "Log Out",
        onPressYes: onClickReSynch,
        onPressNo: HomeNotifier().doLogOut);
  }

  onClickReSynch() {
    _dialogService.popDialog();
    _navigationService.push(Routes.SYNCH_PAGE);
  }

  saveDatabase(BuildContext context, SynchResponse synchResponse) async {
    StorageManager.saveData(
        "userRoles", synchResponse.global!.rolesSchema![0].userRoles);
    globals.globalRevamp = synchResponse.global!;
    try {
      _dataText = "Synch data vendor";
      await DatabaseMVendorSchema()
          .insertMVendorSchema(globals.globalRevamp.mVendorSchema ?? []);
      notifyListeners();
      _dataText = "Synch data Estate";
      await DatabaseMEstateSchema()
          .insertMEstateSchema(globals.globalRevamp.mEstateSchema ?? []);
      notifyListeners();
      _dataText = "Synch data Pekerja";
      await DatabaseMEmployeeSchema()
          .insertMEmployeeSchema(globals.globalRevamp.mEmployeeSchema ?? []);
      notifyListeners();
      _dataText = "Synch data Activity";
      await DatabaseMActivitySchema()
          .insertMActivitySchema(globals.globalRevamp.mActivitySchema ?? []);
      _dataText = "Synch data Cost Control";
      notifyListeners();
      await DatabaseMCostControlSchema().insertMCostControlSchema(
          globals.globalRevamp.mCostControlSchema ?? []);
      _dataText = "Synch data Customer";
      notifyListeners();
      await DatabaseMCustomerCodeSchema().insertMCustomerCodeSchema(
          globals.globalRevamp.mCustomerCodeSchema ?? []);
      _dataText = "Synch data Divisi";
      notifyListeners();
      await DatabaseMDivisionSchema()
          .insertMDivisionSchema(globals.globalRevamp.mDivisionSchema ?? []);
      _dataText = "Synch data Material";
      notifyListeners();
      await DatabaseMMaterialSchema()
          .insertMMaterialSchema(globals.globalRevamp.mMaterialSchema ?? []);
      _dataText = "Synch data Blok";
      notifyListeners();
      await DatabaseMBlockSchema()
          .insertMBlockSchema(globals.globalRevamp.mBlockSchema ?? []);
      _dataText = "Synch data Kartu OPH";
      notifyListeners();
      await DatabaseMCOPHSchema()
          .insertMCOPHSchema(globals.globalRevamp.mCOPHCardSchema ?? []);
      _dataText = "Synch data TPH";
      notifyListeners();
      await DatabaseMTPHSchema()
          .insertMTPHSchema(globals.globalRevamp.mTPHSchema ?? []);
      _dataText = "Synch data Penugasan";
      notifyListeners();
      await DatabaseTUserAssignment().insertTUserAssignment(
          globals.globalRevamp.tUserAssignmentSchema ?? []);
      _dataText = "Synch data Kartu SPB";
      notifyListeners();
      await DatabaseMCSPBCardSchema()
          .insertMCSPBCardSchema(globals.globalRevamp.mCSPBCardSchema ?? []);
      _dataText = "Synch data Absensi";
      notifyListeners();
      await DatabaseMAttendance()
          .insertAttendance(globals.globalRevamp.mAttendanceSchema ?? []);
      _dataText = "Synch data Tujuan";
      notifyListeners();
      await DatabaseMDestinationSchema().insertMDestinationSchema(
          globals.globalRevamp.mDestinationSchema ?? []);
      _dataText = "Synch data Kehadiran";
      notifyListeners();
      await DatabaseAttendance()
          .insertAttendance(globals.globalRevamp.tAttendanceSchema ?? []);
      _dataText = "Synch data Kendaraan";
      await DatabaseMVRASchema()
          .insertMVRASchema(globals.globalRevamp.mVRASchema ?? []);

      notifyListeners();
      if (synchResponse.keraniPanen != null) {
        _dataText = "Synch data Laporan Panen Kemarin";
        await DatabaseLaporanPanenKemarin().insertLaporanPanenKemarin(
            synchResponse.keraniPanen?.laporanPanenKemarin ?? []);
        notifyListeners();
        _dataText = "Synch data Estimasi Berat";
        await DatabaseTABWSchema()
            .insertTABWSchema(synchResponse.keraniPanen!.tABWSchema ?? []);
        notifyListeners();
        _dataText = "Synch data Rencana Panen";
        await DatabaseTHarvestingPlan().insertTHarvestingPlan(
            synchResponse.keraniPanen?.tHarvestingPlanSchema ?? []);
        notifyListeners();
        _dataText = "Synch data Laporan Restan";
        await DatabaseLaporanRestan().insertLaporanRestan(
            synchResponse.keraniPanen?.laporanRestan ?? []);
        notifyListeners();
      } else if (synchResponse.keraniKirim != null) {
        _dataText = "Synch data Laporan Restan";
        await DatabaseLaporanRestan().insertLaporanRestan(
            synchResponse.keraniKirim?.laporanRestan ?? []);
        notifyListeners();
        _dataText = "Synch data Laporan SPB Kemarin";
        await DatabaseLaporanSPBKemarin().insertLaporanSPBKemarin(
            synchResponse.keraniKirim?.laporanSPBKemarin ?? []);
        notifyListeners();
      } else if (synchResponse.supervisi != null) {
        _dataText = "Synch data Pekerja Ancak";
        await DatabaseMAncakEmployee().insertMAncakEmployeeSchema(
            synchResponse.supervisi?.mAncakEmployee ?? []);
        _dataText = "Synch data Rencana Panen";
        await DatabaseTHarvestingPlan().insertTHarvestingPlan(
            synchResponse.supervisi?.tHarvestingPlanSchema ?? []);
        _dataText = "Synch data Rencana Kerja";
        await DatabaseTWorkplanSchema()
            .insertTWorkPlan(synchResponse.supervisi?.tWorkplanSchema ?? []);
        _dataText = "Synch data Laporan Restan";
        await DatabaseLaporanRestan()
            .insertLaporanRestan(synchResponse.supervisi?.laporanRestan ?? []);
        _dataText = "Synch data Laporan Panen Kemarin";
        await DatabaseLaporanPanenKemarin().insertLaporanPanenKemarin(
            synchResponse.supervisi?.laporanPanenKemarin ?? []);
        notifyListeners();
      }
      onSuccessSaveLocal(context, synchResponse);
    } catch (e) {
      print(e);
      _dialogService.showOptionDialog(
          title: "Gagal Synch",
          subtitle: "Gagal pada saat sinkronisasi \n e",
          buttonTextYes: "Ulang",
          buttonTextNo: "Log Out",
          onPressYes: onClickReSynch,
          onPressNo: HomeNotifier().doLogOut);
    }
  }

  onSuccessSaveLocal(BuildContext context, SynchResponse synchResponse) {
    DateTime now = DateTime.now();
    StorageManager.saveData("lastSynchTime", TimeManager.timeWithColon(now));
    StorageManager.saveData("lastSynchDate", TimeManager.dateWithDash(now));
    _navigationService.push(ValueService.getMenuFirst(
        synchResponse.global!.rolesSchema![0].userRoles!));
  }
}
