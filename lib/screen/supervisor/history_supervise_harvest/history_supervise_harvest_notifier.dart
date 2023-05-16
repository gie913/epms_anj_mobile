import 'package:epms/database/service/database_oph_supervise.dart';
import 'package:epms/model/oph_supervise.dart';
import 'package:flutter/material.dart';

class HistorySuperviseHarvestNotifier extends ChangeNotifier {
  List<String> _listDivision = ["Semua"];

  List<String> get listDivision => _listDivision;

  List<String> _listKeraniPanen = ["Semua"];

  List<String> get listKeraniPanen => _listKeraniPanen;

  String _valueDivision = "Semua";

  String get valueDivision => _valueDivision;

  String _valueKeraniPanen = "Semua";

  String get valueKeraniPanen => _valueKeraniPanen;

  List<OPHSupervise> _listOPHSupervise = [];

  List<OPHSupervise> get listOPHSupervise => _listOPHSupervise;

  List<OPHSupervise> _listOPHSuperviseResult = [];

  List<OPHSupervise> get listOPHSuperviseResult => _listOPHSuperviseResult;

  int _totalBunches = 0;

  int get totalBunches => _totalBunches;

  int _totalLooseFruits = 0;

  int get totalLooseFruits => _totalLooseFruits;

  onInit() async {
    _listOPHSupervise = await DatabaseOPHSupervise().selectOPHSupervise();
    for(int i=0; i < _listOPHSupervise.length; i++) {
      _totalBunches += _listOPHSupervise[i].bunchesTotal!;
      _totalLooseFruits += _listOPHSupervise[i].looseFruits!;
      _listDivision.add(_listOPHSupervise[i].supervisiDivisionCode!);
    }
    notifyListeners();
  }

  onChangeDivision(String division) {
    onChangeFilter(division, _valueKeraniPanen);
  }

  onChangeKeraniPanen(String keraniPanen) {
    onChangeFilter(_valueDivision, keraniPanen);
  }

  onChangeFilter(String division, String keraniPanen) {
    _valueDivision = division;
    _valueKeraniPanen = keraniPanen;
    _listOPHSuperviseResult.clear();
    if (division == "Semua" && keraniPanen == "Semua") {
      notifyListeners();
      return;
    } else if (division == "Semua") {
      _listOPHSupervise.forEach((element) {
        if (element.supervisiDivisionCode!
            .toLowerCase()
            .contains(division.toLowerCase()))
          _listOPHSuperviseResult.add(element);
      });
      notifyListeners();
    } else if (keraniPanen == "Semua") {
      _listOPHSupervise.forEach((element) {
        if (element.supervisiKeraniPanenEmployeeName!
            .toLowerCase()
            .contains(keraniPanen.toLowerCase()))
          _listOPHSuperviseResult.add(element);
      });
      notifyListeners();
    } else {
      _listOPHSupervise.forEach((element) {
        if (element.supervisiDivisionCode!
                .toLowerCase()
                .contains(division.toLowerCase()) &&
            element.supervisiKeraniPanenEmployeeName!
                .toLowerCase()
                .contains(keraniPanen.toLowerCase()))
          _listOPHSuperviseResult.add(element);
      });
      notifyListeners();
    }
  }
}
