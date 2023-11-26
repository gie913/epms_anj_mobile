import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/inspection_service.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/database/service/database_todo_inspection.dart';
import 'package:epms/database/service/database_user_inspection_config.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/model/user_inspection_config_model.dart';
import 'package:epms/screen/home/logout_repository.dart';
import 'package:epms/screen/inspection/inspection_repository.dart';
import 'package:flutter/material.dart';

class HomeInspectionNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  UserInspectionConfigModel _dataUser = const UserInspectionConfigModel();

  UserInspectionConfigModel get dataUser => _dataUser;

  List<TicketInspectionModel> _listMyInspection = [];
  List<TicketInspectionModel> get listMyInspection => _listMyInspection;

  List<TicketInspectionModel> _listTodoInspection = [];
  List<TicketInspectionModel> get listTodoInspection => _listTodoInspection;

  bool _isInternetExist = false;

  bool get isInternetExist => _isInternetExist;

  int _countInspection = 0;

  int get countInspection => _countInspection;

  void initData(BuildContext context) async {
    await checkInternetConnection();
    await getDataUser();
    await getDataInspection(context);
    await updateCountInspection();
  }

  Future<void> checkInternetConnection() async {
    final data = await InspectionService.isInternetConnectionExist();
    _isInternetExist = data;
    notifyListeners();
  }

  Future<void> updateCountInspection() async {
    await updateMyInspectionFromLocal();
    await updateTodoInspectionFromLocal();
    _countInspection = _listMyInspection.length + _listTodoInspection.length;
    notifyListeners();
  }

  Future<void> getDataUser() async {
    var data = await DatabaseUserInspectionConfig.selectData();
    _dataUser = data;
    notifyListeners();
  }

  Future<void> getDataInspection(BuildContext context) async {
    if (isInternetExist) {
      await InspectionRepository().getMyInspection(
        context,
        (context, data) async {
          await DatabaseTicketInspection.addAllData(data);
          await updateMyInspectionFromLocal();
          await getTodoInspection(context);
        },
        (context, errorMessage) async {
          await getTodoInspection(context);
        },
      );
    } else {
      await updateMyInspectionFromLocal();
      await updateTodoInspectionFromLocal();
    }
  }

  Future<void> updateMyInspectionFromLocal() async {
    final data = await DatabaseTicketInspection.selectData();
    _listMyInspection = data;
    notifyListeners();
  }

  Future<void> getTodoInspection(BuildContext context) async {
    if (isInternetExist) {
      await InspectionRepository().getToDoInspection(
        context,
        (context, data) async {
          await DatabaseTodoInspection.addAllData(data);
          await updateTodoInspectionFromLocal();
        },
        (context, errorMessage) {},
      );
    } else {
      await updateTodoInspectionFromLocal();
    }
  }

  Future<void> updateTodoInspectionFromLocal() async {
    final data = await DatabaseTodoInspection.selectData();
    _listTodoInspection = data;
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

  onSuccessLogOut(String successMsg) {
    StorageManager.deleteData("inspectionToken");
    StorageManager.deleteData("inspectionTokenExpired");
    DatabaseHelper().deleteMasterDataInspection();
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
