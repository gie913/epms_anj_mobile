import 'package:epms/database/service/database_spb_supervise.dart';
import 'package:epms/model/spb_supervise.dart';
import 'package:flutter/material.dart';

class SupervisorSPBHistoryNotifier extends ChangeNotifier {
  List<SPBSupervise> _listSPBSupervise = [];

  List<SPBSupervise> get listSPBSupervise => _listSPBSupervise;

  List<String> _sourceSPB = ["Semua", "Internal"];

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
    }
    notifyListeners();
  }
}
