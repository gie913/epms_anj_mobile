import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/database/service/database_tbs_luar.dart';
import 'package:epms/model/tbs_luar.dart';
import 'package:flutter/material.dart';

class SupervisorTBSLuarHistoryNotifier extends ChangeNotifier {

  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  List<TBSLuar> _listTBSLuarSupervise = [];

  List<TBSLuar> get listTBSLuarSupervise => _listTBSLuarSupervise;

  List<TBSLuar> _listTBSLuarSuperviseResult = [];

  List<TBSLuar> get listTBSLuarSuperviseResult => _listTBSLuarSuperviseResult;

  onInit() async {
    _listTBSLuarSupervise = await DatabaseTBSLuar().selectTBSLuar();
    notifyListeners();
  }

  onSelectedTBSLuar(TBSLuar tbsLuar, String method) {
    _navigationService.push(Routes.TBS_LUAR_DETAIL_PAGE,
        arguments: {"tbs_luar": tbsLuar, "method": method});
  }

}
