import 'dart:developer';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/service/database_attendance.dart';
import 'package:epms/database/service/database_harvesting_plan.dart';
import 'package:epms/database/service/database_laporan_panen_kemarin.dart';
import 'package:epms/database/service/database_laporan_restan.dart';
import 'package:epms/database/service/database_laporan_spb_kemarin.dart';
import 'package:epms/database/service/database_m_ancak_employee.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_material.dart';
import 'package:epms/database/service/database_oph.dart';
import 'package:epms/database/service/database_oph_supervise.dart';
import 'package:epms/database/service/database_oph_supervise_ancak.dart';
import 'package:epms/database/service/database_spb.dart';
import 'package:epms/database/service/database_spb_supervise.dart';
import 'package:epms/database/service/database_supervisor.dart';
import 'package:epms/database/service/database_t_abw.dart';
import 'package:epms/database/service/database_t_auth.dart';
import 'package:epms/database/service/database_t_workplan_schema.dart';
import 'package:epms/database/service/database_tbs_luar.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/database/service/database_todo_inspection.dart';
import 'package:epms/database/service/database_user_inspection_config.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/user_inspection_config_model.dart';
import 'package:epms/screen/home/logout_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  UserInspectionConfigModel _dataUser = const UserInspectionConfigModel();

  UserInspectionConfigModel get dataUser => _dataUser;

  int _countInspection = 0;

  int get countInspection => _countInspection;

  doLogOut() async {
    _dialogService.popDialog();
    var mapList = [];
    var mapList2 = [];
    _role = await StorageManager.readData('userRoles');
    final isLoginInspectionSuccess =
        await StorageManager.readData('is_login_inspection_success');

    if (isLoginInspectionSuccess == true) {
      if (_role == "BC") {
        mapList = await DatabaseOPH().selectOPH();
        final dataMyInspection =
            await DatabaseTicketInspection.selectDataNeedUpload();
        final dataToDoInspection =
            await DatabaseTodoInspection.selectDataNeedUpload();

        final totalDataInspectionUnUpload =
            dataMyInspection.length + dataToDoInspection.length;

        if (mapList.isNotEmpty) {
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Upload data",
              "Anda belum mengupload data");
        } else if (totalDataInspectionUnUpload != 0) {
          FlushBarManager.showFlushBarWarning(
            _navigationService.navigatorKey.currentContext!,
            "Gagal Logout",
            "Anda memiliki inspection yang belum di upload",
          );
        } else {
          _dialogService.showLoadingDialog(title: "Logging Out");
          LogOutRepository().doPostLogOut(onSuccessLogOut, onErrorLogOut);
        }
      } else if (_role == "TP") {
        mapList = await DatabaseSPB().selectSPB();
        final dataMyInspection =
            await DatabaseTicketInspection.selectDataNeedUpload();
        final dataToDoInspection =
            await DatabaseTodoInspection.selectDataNeedUpload();

        final totalDataInspectionUnUpload =
            dataMyInspection.length + dataToDoInspection.length;

        if (mapList.isNotEmpty) {
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Upload data",
              "Anda belum mengupload data");
        } else if (totalDataInspectionUnUpload != 0) {
          FlushBarManager.showFlushBarWarning(
            _navigationService.navigatorKey.currentContext!,
            "Gagal Logout",
            "Anda memiliki inspection yang belum di upload",
          );
        } else {
          _dialogService.showLoadingDialog(title: "Logging Out");
          LogOutRepository().doPostLogOut(onSuccessLogOut, onErrorLogOut);
        }
      } else if (_role == "KR") {
        mapList = await DatabaseOPH().selectOPH();
        mapList2 = await DatabaseSPB().selectSPB();
        final dataMyInspection =
            await DatabaseTicketInspection.selectDataNeedUpload();
        final dataToDoInspection =
            await DatabaseTodoInspection.selectDataNeedUpload();

        final totalDataInspectionUnUpload =
            dataMyInspection.length + dataToDoInspection.length;

        // if (mapList.isEmpty && mapList2.isEmpty) {
        //   _dialogService.showLoadingDialog(title: "Logging Out");
        //   LogOutRepository().doPostLogOut(onSuccessLogOut, onErrorLogOut);
        // } else {
        //   FlushBarManager.showFlushBarWarning(
        //       _navigationService.navigatorKey.currentContext!,
        //       "Upload data",
        //       "Anda belum mengupload data");
        // }
        // pengecekan logout dua tombol upload OPH dan SPB
        if (mapList.isNotEmpty && mapList2.isNotEmpty) {
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Upload data",
              "Anda belum mengupload data OPH dan data SPB");
          return;
        }

        if (mapList.isNotEmpty) {
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Upload data",
              "Anda belum mengupload data OPH");
          return;
        }

        if (mapList2.isNotEmpty) {
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Upload data",
              "Anda belum mengupload data SPB");
          return;
        }

        if (totalDataInspectionUnUpload != 0) {
          FlushBarManager.showFlushBarWarning(
            _navigationService.navigatorKey.currentContext!,
            "Gagal Logout",
            "Anda memiliki inspection yang belum di upload",
          );
          return;
        }

        if (mapList.isEmpty && mapList2.isEmpty) {
          _dialogService.showLoadingDialog(title: "Logging Out");
          LogOutRepository().doPostLogOut(onSuccessLogOut, onErrorLogOut);
          return;
        }
      } else if (_role == "Supervisi") {
        mapList = await DatabaseOPHSupervise().selectOPHSupervise();
        mapList2 = await DatabaseOPHSuperviseAncak().selectOPHSuperviseAncak();

        final dataMyInspection =
            await DatabaseTicketInspection.selectDataNeedUpload();
        final dataToDoInspection =
            await DatabaseTodoInspection.selectDataNeedUpload();

        final totalDataInspectionUnUpload =
            dataMyInspection.length + dataToDoInspection.length;

        if (mapList.isNotEmpty && mapList2.isNotEmpty) {
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Upload data",
              "Anda belum mengupload data OPH dan data OPH Ancak");
          return;
        }

        if (mapList.isNotEmpty) {
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Upload data",
              "Anda belum mengupload data OPH");
          return;
        }

        if (mapList2.isNotEmpty) {
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Upload data",
              "Anda belum mengupload data OPH Ancak");
          return;
        }

        if (totalDataInspectionUnUpload != 0) {
          FlushBarManager.showFlushBarWarning(
            _navigationService.navigatorKey.currentContext!,
            "Gagal Logout",
            "Anda memiliki inspection yang belum di upload",
          );
          return;
        }

        if (mapList.isEmpty && mapList2.isEmpty) {
          _dialogService.showLoadingDialog(title: "Logging Out");
          LogOutRepository().doPostLogOut(onSuccessLogOut, onErrorLogOut);
          return;
        }
      } else {
        mapList = await DatabaseSPBSupervise().selectSPBSupervise();
        mapList2 = await DatabaseTBSLuar().selectTBSLuar();

        final dataMyInspection =
            await DatabaseTicketInspection.selectDataNeedUpload();
        final dataToDoInspection =
            await DatabaseTodoInspection.selectDataNeedUpload();

        final totalDataInspectionUnUpload =
            dataMyInspection.length + dataToDoInspection.length;

        if (mapList.isNotEmpty && mapList2.isNotEmpty) {
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Upload data",
              "Anda belum mengupload data SPB dan data SPB TBS Luar");
          return;
        }

        if (mapList.isNotEmpty) {
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Upload data",
              "Anda belum mengupload data SPB");
          return;
        }

        if (mapList2.isNotEmpty) {
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Upload data",
              "Anda belum mengupload data SPB TBS Luar");
          return;
        }

        if (totalDataInspectionUnUpload != 0) {
          FlushBarManager.showFlushBarWarning(
            _navigationService.navigatorKey.currentContext!,
            "Gagal Logout",
            "Anda memiliki inspection yang belum di upload",
          );
          return;
        }

        if (mapList.isEmpty && mapList2.isEmpty) {
          _dialogService.showLoadingDialog(title: "Logging Out");
          LogOutRepository().doPostLogOut(onSuccessLogOut, onErrorLogOut);
          return;
        }
      }
    } else {
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
      } else if (_role == "KR") {
        mapList = await DatabaseOPH().selectOPH();
        mapList2 = await DatabaseSPB().selectSPB();
        // if (mapList.isEmpty && mapList2.isEmpty) {
        //   _dialogService.showLoadingDialog(title: "Logging Out");
        //   LogOutRepository().doPostLogOut(onSuccessLogOut, onErrorLogOut);
        // } else {
        //   FlushBarManager.showFlushBarWarning(
        //       _navigationService.navigatorKey.currentContext!,
        //       "Upload data",
        //       "Anda belum mengupload data");
        // }
        // pengecekan logout dua tombol upload OPH dan SPB
        if (mapList.isNotEmpty && mapList2.isNotEmpty) {
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Upload data",
              "Anda belum mengupload data OPH dan data SPB");
          return;
        }

        if (mapList.isNotEmpty) {
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Upload data",
              "Anda belum mengupload data OPH");
          return;
        }

        if (mapList2.isNotEmpty) {
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Upload data",
              "Anda belum mengupload data SPB");
          return;
        }

        if (mapList.isEmpty && mapList2.isEmpty) {
          _dialogService.showLoadingDialog(title: "Logging Out");
          LogOutRepository().doPostLogOut(onSuccessLogOut, onErrorLogOut);
          return;
        }
      } else if (_role == "Supervisi") {
        mapList = await DatabaseOPHSupervise().selectOPHSupervise();
        mapList2 = await DatabaseOPHSuperviseAncak().selectOPHSuperviseAncak();
        if (mapList.isEmpty && mapList2.isEmpty) {
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
        mapList2 = await DatabaseTBSLuar().selectTBSLuar();
        if (mapList.isEmpty && mapList2.isEmpty) {
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
  }

  doLogOutSynch() {
    LogOutRepository().doPostLogOut(onSuccessLogOut, onErrorLogOut);
  }

  onSuccessLogOut() async {
    final isLoginInspectionSuccess =
        await StorageManager.readData('is_login_inspection_success');
    // getEstateCode();
    deleteMasterData();
    StorageManager.deleteData('userId');
    StorageManager.deleteData('userToken');
    StorageManager.deleteData("setTime");

    if (isLoginInspectionSuccess == true) {
      await LogOutRepository().doPostLogOutInspection(
        (successMessage) async {
          StorageManager.deleteData("inspectionToken");
          StorageManager.deleteData("inspectionTokenExpired");
          DatabaseHelper().deleteMasterDataInspection();
          final topic = await StorageManager.readData('topic');
          await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
          StorageManager.deleteData("topic");
          _dialogService.popDialog();
          _navigationService.push(Routes.LOGIN_PAGE);
        },
        onErrorLogOut,
      );
    }

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

  // getEstateCode() async {
  //   MConfigSchema mConfigSchema = await DatabaseMConfig().selectMConfig();
  //   StorageManager.saveData("estateCode", mConfigSchema.estateCode);
  // }

  getUser(BuildContext context) async {
    _configSchema = await DatabaseMConfig().selectMConfig();
    print(_configSchema.userToken);
    checkTime();
    notifyListeners();
  }

  onInitHome(BuildContext context) async {
    _role = await StorageManager.readData('userRoles');

    final isLoginInspectionSuccess =
        await StorageManager.readData('is_login_inspection_success');
    if (isLoginInspectionSuccess == true) {
      await initDataInspection(context);
    }

    log('Cek Role : $_role');
    notifyListeners();
  }

  Future<void> initDataInspection(BuildContext context) async {
    await getDataUser();
    await updateCountInspection();
  }

  Future<void> getDataUser() async {
    var data = await DatabaseUserInspectionConfig.selectData();
    _dataUser = data;
    notifyListeners();
  }

  Future<void> updateCountInspection() async {
    final listTodoInspection = await DatabaseTodoInspection.selectData();
    _countInspection = listTodoInspection.length;
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
    DatabaseTBSLuar().deleteTBSLuar();
    DatabaseLaporanRestan().deleteLaporanRestan();
    DatabaseLaporanPanenKemarin().deleteLaporanPanenKemarin();
    DatabaseLaporanSPBKemarin().deleteLaporanSPBKemarin();
    DatabaseTHarvestingPlan().deleteTHarvestingPlan();
    DatabaseAttendance().deleteEmployeeAttendance();
    DatabaseTWorkplanSchema().deleteTWorkPlan();
    DatabaseMaterial().deleteMaterial();
    DatabaseSupervisor().deleteSupervisor();
    DatabaseMAncakEmployee().deleteMAncakEmployeeSchema();
    DatabaseTABWSchema().deleteTABWSchema();
    DatabaseTAuth().deleteTAuth();
    // Inspection
    // DatabaseUserInspectionConfig.deleteTable();
    // DatabaseInspectionAccess.deleteTable();
  }
}
