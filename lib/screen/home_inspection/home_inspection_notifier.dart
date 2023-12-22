import 'dart:developer';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/inspection_service.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/database/helper/database_helper.dart';
import 'package:epms/database/service/database_subordinate_inspection.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/database/service/database_todo_inspection.dart';
import 'package:epms/database/service/database_user_inspection_config.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/model/user_inspection_config_model.dart';
import 'package:epms/screen/home/logout_repository.dart';
import 'package:epms/screen/inspection/inspection_repository.dart';
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

  List<TicketInspectionModel> _listMyInspection = [];
  List<TicketInspectionModel> get listMyInspection => _listMyInspection;

  List<TicketInspectionModel> _listTodoInspection = [];
  List<TicketInspectionModel> get listTodoInspection => _listTodoInspection;

  List<TicketInspectionModel> _listSubordinateInspection = [];
  List<TicketInspectionModel> get listSubordinateInspection =>
      _listSubordinateInspection;

  void initData(BuildContext context) async {
    await getDataUser();
    await DatabaseTicketInspection.deleteTicketThreeMonthAgo();
    await DatabaseSubordinateInspection.deleteSubordinateThreeMonthAgo();
    await getDataInspection(context);
    await updateCountInspection();
  }

  Future<void> updateMyInspectionFromLocal() async {
    final data = await DatabaseTicketInspection.selectData();
    _listMyInspection = data;
    notifyListeners();
  }

  Future<void> updateTodoInspectionFromLocal() async {
    final data = await DatabaseTodoInspection.selectData();
    _listTodoInspection = data;
    notifyListeners();
  }

  Future<void> updateSubordinateInspectionFromLocal() async {
    final data = await DatabaseSubordinateInspection.selectData();
    _listSubordinateInspection = data;
    notifyListeners();
  }

  Future<void> getDataInspection(BuildContext context) async {
    final isInternetExist = await InspectionService.isInternetConnectionExist();
    if (isInternetExist) {
      await InspectionRepository().getMyInspection(
        context,
        (context, data) async {
          await DatabaseTicketInspection.addAllData(data);
          await updateMyInspectionFromLocal();
          await InspectionRepository().getToDoInspection(
            context,
            (context, data) async {
              await DatabaseTodoInspection.addAllData(data);
              await updateTodoInspectionFromLocal();
              await InspectionRepository().getMySubordinate(
                context,
                (context, data) async {
                  await DatabaseSubordinateInspection.addAllData(data);
                  await updateSubordinateInspectionFromLocal();
                  FlushBarManager.showFlushBarSuccess(
                    context,
                    "Berhasil Synchronize",
                    "Data Inspection Berhasil Diperbaharui",
                  );
                  log('list My Inspection : $_listMyInspection');
                  log('list Todo Inspection : $_listTodoInspection');
                  log('list Subordinate Inspection : $_listSubordinateInspection');
                },
                (context, errorMessage) {
                  FlushBarManager.showFlushBarError(
                    context,
                    "Gagal Synchronize",
                    errorMessage,
                  );
                  log('list My Inspection : $_listMyInspection');
                  log('list Todo Inspection : $_listTodoInspection');
                  log('list Subordinate Inspection : $_listSubordinateInspection');
                },
              );
            },
            (context, errorMessage) async {
              await InspectionRepository().getMySubordinate(
                context,
                (context, data) async {
                  await DatabaseSubordinateInspection.addAllData(data);
                  await updateSubordinateInspectionFromLocal();
                  FlushBarManager.showFlushBarSuccess(
                    context,
                    "Berhasil Synchronize",
                    "Data Inspection Berhasil Diperbaharui",
                  );
                  log('list My Inspection : $_listMyInspection');
                  log('list Todo Inspection : $_listTodoInspection');
                  log('list Subordinate Inspection : $_listSubordinateInspection');
                },
                (context, errorMessage) {
                  FlushBarManager.showFlushBarError(
                    context,
                    "Gagal Synchronize",
                    errorMessage,
                  );
                  log('list My Inspection : $_listMyInspection');
                  log('list Todo Inspection : $_listTodoInspection');
                  log('list Subordinate Inspection : $_listSubordinateInspection');
                },
              );
            },
          );
        },
        (context, errorMessage) async {
          await InspectionRepository().getToDoInspection(
            context,
            (context, data) async {
              await DatabaseTodoInspection.addAllData(data);
              await updateTodoInspectionFromLocal();
              await InspectionRepository().getMySubordinate(
                context,
                (context, data) async {
                  await DatabaseSubordinateInspection.addAllData(data);
                  await updateSubordinateInspectionFromLocal();
                  FlushBarManager.showFlushBarSuccess(
                    context,
                    "Berhasil Synchronize",
                    "Data Inspection Berhasil Diperbaharui",
                  );
                  log('list My Inspection : $_listMyInspection');
                  log('list Todo Inspection : $_listTodoInspection');
                  log('list Subordinate Inspection : $_listSubordinateInspection');
                },
                (context, errorMessage) {
                  FlushBarManager.showFlushBarError(
                    context,
                    "Gagal Synchronize",
                    errorMessage,
                  );
                  log('list My Inspection : $_listMyInspection');
                  log('list Todo Inspection : $_listTodoInspection');
                  log('list Subordinate Inspection : $_listSubordinateInspection');
                },
              );
            },
            (context, errorMessage) async {
              await InspectionRepository().getMySubordinate(
                context,
                (context, data) async {
                  await DatabaseSubordinateInspection.addAllData(data);
                  await updateSubordinateInspectionFromLocal();
                  FlushBarManager.showFlushBarSuccess(
                    context,
                    "Berhasil Synchronize",
                    "Data Inspection Berhasil Diperbaharui",
                  );
                  log('list My Inspection : $_listMyInspection');
                  log('list Todo Inspection : $_listTodoInspection');
                  log('list Subordinate Inspection : $_listSubordinateInspection');
                },
                (context, errorMessage) {
                  FlushBarManager.showFlushBarError(
                    context,
                    "Gagal Synchronize",
                    errorMessage,
                  );
                  log('list My Inspection : $_listMyInspection');
                  log('list Todo Inspection : $_listTodoInspection');
                  log('list Subordinate Inspection : $_listSubordinateInspection');
                },
              );
            },
          );
        },
      );
    } else {
      await updateMyInspectionFromLocal();
      await updateTodoInspectionFromLocal();
      await updateSubordinateInspectionFromLocal();
      log('list My Inspection : $_listMyInspection');
      log('list Todo Inspection : $_listTodoInspection');
      log('list Subordinate Inspection : $_listSubordinateInspection');
    }
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
