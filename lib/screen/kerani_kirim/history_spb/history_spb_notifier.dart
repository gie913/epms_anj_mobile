
import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/database/service/database_spb.dart';
import 'package:epms/model/spb.dart';
import 'package:flutter/material.dart';

class HistorySPBNotifier extends ChangeNotifier {

  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  List<SPB> _listSPB = [];

  List<SPB> get listSPB => _listSPB;

  int _totalBunches = 0;

  int get totalBunches => _totalBunches;

  int _totalLooseFruits = 0;

  int get totalLooseFruits => _totalLooseFruits;

  getDataSPBHistory() async {
    _listSPB = await DatabaseSPB().selectSPB();
    for(int i = 0; i < _listSPB.length; i++) {
      _totalBunches = _totalBunches + _listSPB[i].spbTotalBunches!;
      _totalLooseFruits = _totalLooseFruits + _listSPB[i].spbTotalLooseFruit!;
    }
    notifyListeners();
  }

  void onClickSPB(SPB spb, String method) {
    _navigationService.push(Routes.SPB_DETAIL_PAGE, arguments: {
      "spb" : spb,
      "method" : method
    });
  }

}