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

  List<String> _listDivision = ["Semua"];

  List<String> get listDivision => _listDivision;

  String _divisionValue = "Semua";

  String get divisionValue => _divisionValue;

  dynamic _totalBunches = 0;

  dynamic get totalBunches => _totalBunches;

  dynamic _totalLooseFruits = 0;

  dynamic get totalLooseFruits => _totalLooseFruits;

  dynamic _countOPHRestan = 0;

  dynamic get countOPHRestan => _countOPHRestan;

  getListLaporanRestan() async {
    List<String> listBlockTemp = [];
    List<String> listDivisionTemp = [];
    _listRestan = await DatabaseLaporanRestan().selectLaporanRestan();
    _listRestan.forEach((element) {
      _totalBunches = _totalBunches + element.bunchesTotal;
      _totalLooseFruits = _totalLooseFruits + element.looseFruits;
      if (!listBlockTemp.contains(element.ophBlockCode)) {
        if (element.ophBlockCode == null) {
          print(element.ophId);
        } else {
          listBlockTemp.add(element.ophBlockCode!);
          listBlockTemp.sort((a, b) => a.toString().compareTo(b.toString()));
        }
      }
      if (!listDivisionTemp.contains(element.ophDivisionCode)) {
        if (element.ophDivisionCode == null) {
          print(element.ophId);
        } else {
          listDivisionTemp.add(element.ophDivisionCode!);
          listDivisionTemp.sort((a, b) => a.toString().compareTo(b.toString()));
        }
      }
    });
    _listBlock.addAll(listBlockTemp);
    _listDivision.addAll(listDivisionTemp);
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

  onSetDivisionValue(String value) {
    _blockValue = "Semua";
    _divisionValue = value;
    _totalBunches = 0;
    _totalLooseFruits = 0;
    _listRestanResult.clear();
    _listBlock = ["Semua"];
    List<String> listBlockTemp = [];
    if (value == "Semua" && _blockValue == "Semua") {
      for (int i = 0; i < _listRestan.length; i++) {
        _totalBunches = _totalBunches + _listRestan[i].bunchesTotal;
        _totalLooseFruits = _totalLooseFruits + _listRestan[i].looseFruits;
      }
      _countOPHRestan = _listRestan.length;
      notifyListeners();
    } else if (_blockValue == "Semua") {
      for (int i = 0; i < _listRestan.length; i++) {
        if (_listRestan[i].ophDivisionCode != null) {
          if (_listRestan[i]
              .ophDivisionCode!
              .toLowerCase()
              .contains(value.toLowerCase()))
            _listRestanResult.add(_listRestan[i]);
        }
      }
      for (int i = 0; i < _listRestanResult.length; i++) {
        _totalBunches = _totalBunches + _listRestanResult[i].bunchesTotal;
        _totalLooseFruits =
            _totalLooseFruits + _listRestanResult[i].looseFruits;
        if (!listBlockTemp.contains(_listRestanResult[i].ophBlockCode)) {
          if (_listRestanResult[i].ophBlockCode == null) {
            print(_listRestanResult[i].ophId);
          } else {
            listBlockTemp.add(_listRestanResult[i].ophBlockCode!);
            listBlockTemp.sort((a, b) => a.toString().compareTo(b.toString()));
          }
        }
      }
      _listBlock = ["Semua"];
      _listBlock.addAll(listBlockTemp);
      _countOPHRestan = listRestanResult.length;
    } else {
      for (int i = 0; i < _listRestan.length; i++) {
        if (_listRestan[i].ophDivisionCode != null) {
          if (_listRestan[i]
                  .ophDivisionCode!
                  .toLowerCase()
                  .contains(value.toLowerCase()) &&
              _listRestan[i]
                  .ophBlockCode!
                  .toLowerCase()
                  .contains(value.toLowerCase()))
            _listRestanResult.add(_listRestan[i]);
        }
      }
      for (int i = 0; i < _listRestanResult.length; i++) {
        _totalBunches = _totalBunches + _listRestanResult[i].bunchesTotal;
        _totalLooseFruits =
            _totalLooseFruits + _listRestanResult[i].looseFruits;
        if (!listBlockTemp.contains(_listRestanResult[i].ophBlockCode)) {
          if (_listRestanResult[i].ophBlockCode == null) {
            print(_listRestanResult[i].ophId);
          } else {
            listBlockTemp.add(_listRestanResult[i].ophBlockCode!);
            listBlockTemp.sort((a, b) => a.toString().compareTo(b.toString()));
          }
        }
      }
      _listBlock = ["Semua"];
      _listBlock.addAll(listBlockTemp);
      _countOPHRestan = listRestanResult.length;
    }
    notifyListeners();
  }

  onSetBlockValue(String value) {
    _blockValue = value;
    _totalBunches = 0;
    _totalLooseFruits = 0;
    _listRestanResult.clear();
    if (value == "Semua" && _divisionValue == "Semua") {
      for (int i = 0; i < _listRestan.length; i++) {
        _totalBunches = _totalBunches + _listRestan[i].bunchesTotal;
        _totalLooseFruits = _totalLooseFruits + _listRestan[i].looseFruits;
      }
      _countOPHRestan = _listRestan.length;
      notifyListeners();
    } else if (_divisionValue == "Semua") {
      for (int i = 0; i < _listRestan.length; i++) {
        if (_listRestan[i].ophBlockCode != null ||
            _listRestan[i].ophDivisionCode != null) {
          if (_listRestan[i]
              .ophBlockCode!
              .toLowerCase()
              .contains(value.toLowerCase()))
            _listRestanResult.add(_listRestan[i]);
        }
      }
      for (int i = 0; i < _listRestanResult.length; i++) {
        _totalBunches = _totalBunches + _listRestanResult[i].bunchesTotal;
        _totalLooseFruits =
            _totalLooseFruits + _listRestanResult[i].looseFruits;
      }
      _countOPHRestan = listRestanResult.length;
      notifyListeners();
    } else {
      for (int i = 0; i < _listRestan.length; i++) {
        if (_listRestan[i].ophBlockCode != null ||
            _listRestan[i].ophDivisionCode != null) {
          if (_listRestan[i].ophBlockCode! == value &&
              _listRestan[i].ophDivisionCode! == _divisionValue) {
            _listRestanResult.add(_listRestan[i]);
          }
        }
      }
      for (int i = 0; i < _listRestanResult.length; i++) {
        _totalBunches = _totalBunches + _listRestanResult[i].bunchesTotal;
        _totalLooseFruits =
            _totalLooseFruits + _listRestanResult[i].looseFruits;
      }
      _countOPHRestan = listRestanResult.length;
      notifyListeners();
    }
    notifyListeners();
  }
}
