import 'dart:convert';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/database/service/database_laporan_restan.dart';
import 'package:epms/model/laporan_restan.dart';
import 'package:epms/model/oph.dart';
import 'package:flutter/material.dart';

class RestanReportNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  List<LaporanRestan> _listRestan = [];

  List<LaporanRestan> get listRestan => _listRestan;

  List<LaporanRestan> _listRestanResult = [];

  List<LaporanRestan> get listRestanResult => _listRestanResult;

  List<String> _listBlock = ["Semua"];

  List<String> get listBlock => _listBlock;

  String _blockValue = "Semua";

  String get blockValue => _blockValue;

  dynamic _totalBunches = 0;

  dynamic get totalBunches => _totalBunches;

  dynamic _totalLooseFruits = 0;

  dynamic get totalLooseFruits => _totalLooseFruits;

  dynamic _countOPHRestan = 0;

  dynamic get countOPHRestan => _countOPHRestan;

  getListLaporanRestan() async {
    List<String> listBlockTemp = [];
    _listRestan = await DatabaseLaporanRestan().selectLaporanRestan();
    _listRestan.forEach((element) {
      _totalBunches = _totalBunches + element.bunchesTotal;
      _totalLooseFruits = _totalLooseFruits + element.looseFruits;
      if (!listBlockTemp.contains(element.ophBlockCode)) {
        if(element.ophBlockCode == null) {
          print(element.ophId);
        } else {
          listBlockTemp.add(element.ophBlockCode!);
          listBlockTemp.sort((a, b) => a.toString().compareTo(b.toString()));
        }
      }
    });
    _listBlock.addAll(listBlockTemp);
    _countOPHRestan = listRestan.length;
    notifyListeners();
  }

  onClickRestan(String method, LaporanRestan laporanRestan) {
    if (method == "LIHAT") {
      _navigationService.push(Routes.RESTAN_DETAIL, arguments: laporanRestan);
    } else {
      String json = jsonEncode(laporanRestan);
      OPH oph = OPH.fromJson(jsonDecode(json));
      _navigationService.push(Routes.OPH_DETAIL_PAGE,
          arguments: {"method": method, "oph": oph, "restan": true});
    }
  }

  onSetBlockValue(String value) {
    _blockValue = value;
    _totalBunches = 0;
    _totalLooseFruits = 0;
    _listRestanResult.clear();
    if (value == "Semua") {
      _listRestan.forEach((element) {
        _totalBunches = _totalBunches + element.bunchesTotal;
        _totalLooseFruits = _totalLooseFruits + element.looseFruits;
      });
      _countOPHRestan = _listRestan.length;
      notifyListeners();
      return;
    } else {
      _listRestan.forEach((laporanRestan) {
        if(laporanRestan.ophBlockCode != null) {
          if (laporanRestan.ophBlockCode!
              .toLowerCase()
              .contains(value.toLowerCase()))
            _listRestanResult.add(laporanRestan);
        }
      });
      _listRestanResult.forEach((element) {
        _totalBunches = _totalBunches + element.bunchesTotal;
        _totalLooseFruits = _totalLooseFruits + element.looseFruits;
      });
      _countOPHRestan = listRestanResult.length;
    }
    notifyListeners();
  }
}
