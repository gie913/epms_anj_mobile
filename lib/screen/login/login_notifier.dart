import 'dart:developer';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/service/database_activity.dart';
import 'package:epms/database/service/database_attendance.dart';
import 'package:epms/database/service/database_cost_control.dart';
import 'package:epms/database/service/database_destination.dart';
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
import 'package:epms/database/service/database_mc_oph.dart';
import 'package:epms/database/service/database_mc_spb.dart';
import 'package:epms/database/service/database_oph.dart';
import 'package:epms/database/service/database_oph_supervise.dart';
import 'package:epms/database/service/database_spb.dart';
import 'package:epms/database/service/database_spb_detail.dart';
import 'package:epms/database/service/database_spb_loader.dart';
import 'package:epms/database/service/database_spb_supervise.dart';
import 'package:epms/database/service/database_t_abw.dart';
import 'package:epms/database/service/database_t_user_assignment.dart';
import 'package:epms/database/service/database_user_inspection_config.dart';
import 'package:epms/model/login_inspection_data.dart';
import 'package:epms/model/login_response.dart';
import 'package:epms/screen/login/login_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

class LoginNotifier extends ChangeNotifier {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GlobalKey<FormState> get formKey => _formKey;

  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  bool _obscureText = false;

  bool get obscureText => _obscureText;

  String appName = FlavorConfig.instance.variables["appName"];

  bool _loading = false;

  bool get loading => _loading;

  TextEditingController _username = TextEditingController();

  TextEditingController get username => _username;

  TextEditingController _password = TextEditingController();

  TextEditingController get password => _password;

  onInitLoginScreen() async {
    // String? apiServer = await StorageManager.readData('apiServer');
    // if(apiServer == null) {
    //   StorageManager.saveData("apiServer", APIEndPoint.BASE_URL);
    // }
    String? usernameTemp = await StorageManager.readData('userName');
    if (usernameTemp != null) {
      _username.text = usernameTemp;
    }
  }

  void toggle() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  doLogin(BuildContext context) async {
    String? apiServer = await StorageManager.readData('apiServer');
    if (apiServer != null) {
      log('Login Epms');
      if (_formKey.currentState!.validate()) {
        _loading = true;
        LoginRepository().doPostLogin(
          context,
          _username.text,
          _password.text,
          onSuccessLogin,
          (context, errorMessage) async {
            log('Error Login Epms');
            final errorLoginEpms = errorMessage;
            StorageManager.saveData('is_login_epms_success', false);
            await LoginRepository().loginInspection(
              context,
              _username.text,
              _password.text,
              false,
              onSuccessLoginInspection,
              (context, errorMessage) async {
                StorageManager.saveData('is_login_inspection_success', false);
                onErrorLogin(
                  context,
                  'Error Login Epms : $errorLoginEpms\nError Login Inspection : $errorMessage',
                );
                _loading = false;
                notifyListeners();
              },
            );
          },
        );
        notifyListeners();
      }
    } else {
      log('Login Inspection');
      if (_formKey.currentState!.validate()) {
        _loading = true;
        LoginRepository().loginInspection(
          context,
          _username.text,
          _password.text,
          false,
          onSuccessLoginInspection,
          (context, errorMessage) {
            StorageManager.saveData('is_login_inspection_success', false);
            _loading = false;
            _dialogService.showNoOptionDialog(
              subtitle: "Error Login Inspection : $errorMessage",
              title: 'Gagal Login',
              onPress: _dialogService.popDialog,
            );
            notifyListeners();
          },
        );
        notifyListeners();
      }
      // FlushBarManager.showFlushBarWarning(
      //     context, "Server", "Anda belum melakukan konfigurasi server");
    }
  }

  onSuccessLogin(BuildContext context, LoginResponse loginResponse) async {
    // _loading = false;
    StorageManager.saveData('is_login_epms_success', true);
    await saveDatabase(context, _username.text, loginResponse);
    await LoginRepository().loginInspection(
      context,
      _username.text,
      _password.text,
      true,
      onSuccessLoginInspection,
      (context, errorMessage) async {
        StorageManager.saveData('is_login_inspection_success', false);
        await saveDatabase(context, _username.text, loginResponse);

        final isLoginEpmsSuccess =
            await StorageManager.readData('is_login_epms_success');
        final isLoginInspectionSuccess =
            await StorageManager.readData('is_login_inspection_success');
        if (isLoginEpmsSuccess != false || isLoginInspectionSuccess != false) {
          _navigationService.push(Routes.SYNCH_PAGE);
        } else {
          onErrorLogin(context, errorMessage);
        }

        _loading = false;
        notifyListeners();
      },
    );
    // FlushBarManager.showFlushBarSuccess(
    //     context, "Login Berhasil", "Anda berhasil login");
    // _navigationService.push(Routes.SYNCH_PAGE);
    // notifyListeners();
  }

  onSuccessLoginInspection(
      BuildContext context, LoginInspectionData data) async {
    StorageManager.saveData('is_login_inspection_success', true);
    _loading = false;
    final username = await StorageManager.readData("userName");

    if (username != data.user.username) {
      DatabaseHelper().deleteActivityDataInspection();
      StorageManager.deleteData("lastSynchDateInspection");
      StorageManager.deleteData("lastSynchTimeInspection");
    }

    await saveDatabaseInspection(context, _username.text, data);
    FlushBarManager.showFlushBarSuccess(
        context, "Login Berhasil", "Anda berhasil login");
    _navigationService.push(Routes.SYNCH_PAGE);
    notifyListeners();
  }

  onErrorLogin(BuildContext context, String response) {
    _loading = false;
    _dialogService.showNoOptionDialog(
      subtitle: "$response",
      title: 'Gagal Login',
      onPress: _dialogService.popDialog,
    );
    notifyListeners();
  }

  saveDatabase(BuildContext context, String username,
      LoginResponse loginResponse) async {
    int count = await DatabaseMConfig.insertMConfig(loginResponse);
    if (count > 0) {
      StorageManager.saveData('millCode', loginResponse.millCode);
      StorageManager.saveData('userRoles', loginResponse.userRole);
      StorageManager.saveData("userName", username);
      StorageManager.saveData("userToken", loginResponse.userToken);
    }
  }

  Future<void> saveDatabaseInspection(
      BuildContext context, String username, LoginInspectionData data) async {
    StorageManager.saveData("inspectionToken", data.token);
    StorageManager.saveData('inspectionTokenExpired', data.tokenExpiredAt);
    StorageManager.saveData("userName", username);
    StorageManager.saveData('topic', 'development_user_${data.user.username}');
    DatabaseHelper().deleteMasterDataInspection();
    await DatabaseUserInspectionConfig.insetData(data.user);
    await DatabaseAccessInspection.insetData(data.access);
    await FirebaseMessaging.instance
        .subscribeToTopic('development_user_${data.user.username}');
  }

  onPressResetData(BuildContext context) {
    _dialogService.showOptionDialog(
      title: "Reset Data",
      subtitle: "Anda yakin ingin mereset data?",
      buttonTextYes: "Ya",
      buttonTextNo: "Batal",
      onPressYes: deleteMasterData,
      onPressNo: _dialogService.popDialog,
    );
  }

  onPressConfiguration(BuildContext context) {
    _navigationService.push(Routes.CONFIGURATION_PAGE);
  }

  deleteMasterData() {
    _dialogService.popDialog();
    _dialogService.showLoadingDialog(title: "Mereset Data");
    try {
      StorageManager.deleteData("lastSynchDate");
      StorageManager.deleteData("lastSynchTime");
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
      DatabaseTABWSchema().deleteTABWSchema();
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
      DatabaseOPH().deleteOPH();
      DatabaseOPHSupervise().deleteOPHSupervise();
      DatabaseSPB().deleteSPB();
      DatabaseSPBDetail().deleteSPBDetail();
      DatabaseSPBLoader().deleteSPBLoader();
      DatabaseSPBSupervise().deleteSPBSupervise();
      // Inspection
      StorageManager.deleteData("inspectionToken");
      StorageManager.deleteData("inspectionTokenExpired");
      DatabaseHelper().deleteMasterDataInspection();
      _dialogService.popDialog();
      FlushBarManager.showFlushBarSuccess(
        _navigationService.navigatorKey.currentContext!,
        "Reset Data",
        "Berhasil mereset data",
      );
    } catch (e) {
      _dialogService.popDialog();
      _dialogService.showNoOptionDialog(
        title: "Reset Data",
        subtitle: "Gagal melakukan reset data",
        onPress: _dialogService.popDialog,
      );
    }
  }
}
