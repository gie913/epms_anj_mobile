import 'package:epms/common_manager/value_service.dart';
import 'package:epms/database/service/database_spb_supervise.dart';
import 'package:epms/model/spb_supervise.dart';
import 'package:flutter/material.dart';

class SupervisorSPBHistoryNotifier extends ChangeNotifier {
  List<SPBSupervise> _listSPBSupervise = [];

  List<SPBSupervise> get listSPBSupervise => _listSPBSupervise;

  List<SPBSupervise> _listSPBSuperviseResult = [];

  List<SPBSupervise> get listSPBSuperviseResult => _listSPBSuperviseResult;

  List<String> _sourceSPB = ["Semua"];

  List<String> get sourceSPB => _sourceSPB;

  String _sourceSPBValue = "Semua";

  String get sourceSPBValue => _sourceSPBValue;

  int _totalBunches = 0;

  int get totalBunches => _totalBunches;

  int _totalNormalBunches = 0;

  int get totalNormalBunches => _totalNormalBunches;

  int _totalLooseFruits = 0;

  int get totalLooseFruits => _totalLooseFruits;

  onInit() async {
    _listSPBSupervise = await DatabaseSPBSupervise().selectSPBSupervise();
    for (int i = 0; i < _listSPBSupervise.length; i++) {
      _totalBunches = _totalBunches + _listSPBSupervise[i].bunchesTotal!;
      _totalNormalBunches =
          _totalNormalBunches + _listSPBSupervise[i].bunchesTotalNormal!;
      _totalLooseFruits = _totalLooseFruits + _listSPBSupervise[i].looseFruits!;
      if (!sourceSPB.contains(ValueService.spbSourceDataText(
          listSPBSupervise[i].supervisiSpbType!))) {
        _sourceSPB.add(ValueService.spbSourceDataText(
            listSPBSupervise[i].supervisiSpbType!)!);
      }
    }
    notifyListeners();
  }

  onChangeFilterSupervisiSPB(String value) {
    _sourceSPBValue = value;
    _totalBunches = 0;
    _totalLooseFruits = 0;
    _totalNormalBunches = 0;
    if (value == "Semua") {
      listSPBSuperviseResult.clear();
      for (int i = 0; i < _listSPBSupervise.length; i++) {
        _listSPBSuperviseResult.add(_listSPBSupervise[i]);
        _totalLooseFruits =
            _totalLooseFruits + _listSPBSupervise[i].looseFruits!.toInt();
        _totalBunches =
            _totalBunches + _listSPBSupervise[i].bunchesTotal!.toInt();
        _totalNormalBunches = _totalNormalBunches +
            _listSPBSupervise[i].bunchesTotalNormal!.toInt();
      }
    } else {
      _listSPBSuperviseResult.clear();
      for (int i = 0; i < _listSPBSupervise.length; i++) {
        if (ValueService.spbSourceDataText(
                _listSPBSupervise[i].supervisiSpbType!) ==
            value) {
          _listSPBSuperviseResult.add(_listSPBSupervise[i]);
          _totalLooseFruits =
              _totalLooseFruits + _listSPBSupervise[i].looseFruits!.toInt();
          _totalBunches =
              _totalBunches + _listSPBSupervise[i].bunchesTotal!.toInt();
          _totalNormalBunches = _totalNormalBunches +
              _listSPBSupervise[i].bunchesTotalNormal!.toInt();
        }
      }
    }
    notifyListeners();
  }
}
