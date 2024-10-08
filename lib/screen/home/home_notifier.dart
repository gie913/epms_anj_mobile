import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/database/service/database_attendance.dart';
import 'package:epms/database/service/database_harvesting_plan.dart';
import 'package:epms/database/service/database_laporan_panen_kemarin.dart';
import 'package:epms/database/service/database_laporan_restan.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_material.dart';
import 'package:epms/database/service/database_oph.dart';
import 'package:epms/database/service/database_oph_supervise.dart';
import 'package:epms/database/service/database_oph_supervise_ancak.dart';
import 'package:epms/database/service/database_spb.dart';
import 'package:epms/database/service/database_spb_supervise.dart';
import 'package:epms/database/service/database_t_workplan_schema.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/screen/home/logout_repository.dart';
import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';

class HomeNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  MConfigSchema _configSchema = MConfigSchema();

  MConfigSchema get configSchema => _configSchema;

  var _role;

  get role => _role;

  doLogOut() async {
    _dialogService.popDialog();
    var mapList = [];
    var mapList2 = [];
    _role = await StorageManager.readData('userRoles');
    if (_role == "BC") {
      mapList = await DatabaseOPH().selectOPH();
      if (mapList.isEmpty) {
        _dialogService.showLoadingDialog(title: "Logging Out");
        LogOutRepository().doPostLogOut(onSuccessLogOut, onErrorLogOut);
      } else {
        FlushBarManager.showFlushBarWarning(
            _navigationService.navigatorKey.currentContext!,
            "Upload data",
            "Anda belum mengupload data");
      }
    } else if (_role == "TP") {
      mapList = await DatabaseSPB().selectSPB();
      if (mapList.isEmpty) {
        _dialogService.showLoadingDialog(title: "Logging Out");
        LogOutRepository().doPostLogOut(onSuccessLogOut, onErrorLogOut);
      } else {
        FlushBarManager.showFlushBarWarning(
            _navigationService.navigatorKey.currentContext!,
            "Upload data",
            "Anda belum mengupload data");
      }
    } else if (_role == "Supervisi") {
      mapList = await DatabaseOPHSupervise().selectOPHSupervise();
      mapList2 = await DatabaseOPHSuperviseAncak().selectOPHSuperviseAncak();
      if (mapList.isEmpty || mapList2.isEmpty) {
        _dialogService.showLoadingDialog(title: "Logging Out");
        LogOutRepository().doPostLogOut(onSuccessLogOut, onErrorLogOut);
      } else {
        FlushBarManager.showFlushBarWarning(
            _navigationService.navigatorKey.currentContext!,
            "Upload data",
            "Anda belum mengupload data");
      }
    } else {
      mapList = await DatabaseSPBSupervise().selectSPBSupervise();
      if (mapList.isEmpty) {
        _dialogService.showLoadingDialog(title: "Logging Out");
        LogOutRepository().doPostLogOut(onSuccessLogOut, onErrorLogOut);
      } else {
        FlushBarManager.showFlushBarWarning(
            _navigationService.navigatorKey.currentContext!,
            "Upload data",
            "Anda belum mengupload data");
      }
    }
  }

  onSuccessLogOut() {
    getEstateCode();
    StorageManager.deleteData('userId');
    StorageManager.deleteData('userToken');
    StorageManager.deleteData("setTime");
    deleteMasterData();
    _dialogService.popDialog();
    _navigationService.push(Routes.LOGIN_PAGE);
  }

  onErrorLogOut(String response) {
    _dialogService.popDialog();
    _dialogService.showNoOptionDialog(
        title: "Gagal Log Out",
        subtitle: "$response",
        onPress: _dialogService.popDialog);
  }

  getEstateCode() async {
    MConfigSchema mConfigSchema = await DatabaseMConfig().selectMConfig();
    StorageManager.saveData("estateCode", mConfigSchema.estateCode);
  }

  getUser(BuildContext context) async {
    _configSchema = await DatabaseMConfig().selectMConfig();
    print(_configSchema.userToken);
    checkTime();
    notifyListeners();
  }

  onInitHome() async {
    _role = await StorageManager.readData('userRoles');
    notifyListeners();
  }

  checkTime() async {
    var setTime = await StorageManager.readData("setTime");
    if (setTime == null) {
      var dateTimeServer = DateTime.parse(
          "${_configSchema.serverDate} ${_configSchema.serverTime}");
      var now = DateTime.now();
      Duration diff = now.difference(dateTimeServer);
      if (diff.inMinutes > 30) {
        _dialogService.showNoOptionDialog(
            title: "Beda waktu dengan server",
            subtitle: "${diff.inHours} jam ${diff.inMinutes} menit",
            onPress: onSetTime);
      } else {
        StorageManager.saveData("setTime", "Done");
      }
    }
  }

  onSetTime() {
    StorageManager.saveData("setTime", "Done");
    _dialogService.popDialog();
    OpenSettings.openDateSetting();
  }

  deleteMasterData() async {
    StorageManager.deleteData("blockDefault");
    DatabaseMConfig().deleteMConfig();
    DatabaseLaporanRestan().deleteLaporanRestan();
    DatabaseLaporanPanenKemarin().deleteLaporanPanenKemarin();
    DatabaseTHarvestingPlan().deleteTHarvestingPlan();
    DatabaseAttendance().deleteEmployeeAttendance();
    DatabaseTWorkplanSchema().deleteTWorkPlan();
    DatabaseMaterial().deleteMaterial();
  }
}
