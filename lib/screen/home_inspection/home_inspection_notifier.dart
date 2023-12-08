import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/service/database_todo_inspection.dart';
import 'package:epms/database/service/database_user_inspection_config.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/user_inspection_config_model.dart';
import 'package:epms/screen/home/logout_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomeInspectionNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  UserInspectionConfigModel _dataUser = const UserInspectionConfigModel();

  UserInspectionConfigModel get dataUser => _dataUser;

  int _countInspection = 0;

  int get countInspection => _countInspection;

  void initData(BuildContext context) async {
    await getDataUser();
    await updateCountInspection();
  }

  Future<void> updateCountInspection() async {
    final listTodoInspection = await DatabaseTodoInspection.selectData();
    _countInspection = listTodoInspection.length;
    notifyListeners();
  }

  Future<void> getDataUser() async {
    var data = await DatabaseUserInspectionConfig.selectData();
    _dataUser = data;
    notifyListeners();
  }

  goToMenuBacaKartuOPH() {
    _navigationService.push(Routes.OPH_DETAIL_PAGE,
        arguments: {"method": "BACA", "oph": OPH(), "restan": false});
  }

  Future<void> goToMenuInspection() async {
    await _navigationService.push(Routes.INSPECTION);
    await updateCountInspection();
  }

  void showPopUpLogOut() {
    _dialogService.showOptionDialog(
        title: "Log Out",
        subtitle: "Anda yakin ingin Log Out?",
        buttonTextYes: "Ya",
        buttonTextNo: "Tidak",
        onPressYes: logOut,
        onPressNo: _dialogService.popDialog);
  }

  Future<void> logOut() async {
    _dialogService.popDialog();

    _dialogService.showLoadingDialog(title: "Logging Out");

    await LogOutRepository()
        .doPostLogOutInspection(onSuccessLogOut, onErrorLogOut);
  }

  onSuccessLogOut(String successMsg) async {
    StorageManager.deleteData("inspectionToken");
    StorageManager.deleteData("inspectionTokenExpired");
    DatabaseHelper().deleteMasterDataInspection();
    final topic = await StorageManager.readData('topic');
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    StorageManager.deleteData("topic");
    _dialogService.popDialog();
    _navigationService.push(Routes.LOGIN_PAGE);
  }

  onErrorLogOut(String errorMsg) {
    _dialogService.popDialog();
    _dialogService.showNoOptionDialog(
        title: "Gagal Log Out",
        subtitle: "$errorMsg",
        onPress: _dialogService.popDialog);
  }
}
