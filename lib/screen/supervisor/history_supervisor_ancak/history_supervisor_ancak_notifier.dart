import 'package:epms/database/service/database_oph_supervise_ancak.dart';
import 'package:epms/model/oph_supervise_ancak.dart';
import 'package:flutter/material.dart';

class HistorySuperviseAncakNotifier extends ChangeNotifier {
  List<String> _listDivision = ["Semua"];

  List<String> get listDivision => _listDivision;

  List<String> _listKemandoran = ["Semua"];

  List<String> get listKemandoran => _listKemandoran;

  String _valueDivision = "Semua";

  String get valueDivision => _valueDivision;

  String _valueKemandoran = "Semua";

  String get valueKemandoran => _valueKemandoran;

  List<OPHSuperviseAncak> _listOPHSupervise = [];

  List<OPHSuperviseAncak> get listOPHSupervise => _listOPHSupervise;

  List<OPHSuperviseAncak> _listOPHSuperviseResult = [];

  List<OPHSuperviseAncak> get listOPHSuperviseResult => _listOPHSuperviseResult;

  int _totalPokokPanen = 0;

  int get totalPokokPanen => _totalPokokPanen;

  int _totalLooseFruits = 0;

  int get totalLooseFruits => _totalLooseFruits;

  onInit() async {
    _listOPHSupervise = await DatabaseOPHSuperviseAncak().selectOPHSuperviseAncak();
    for(int i=0; i < _listOPHSupervise.length; i++) {
      _totalPokokPanen += _listOPHSupervise[i].bunchesTotal!;
      _totalLooseFruits += _listOPHSupervise[i].looseFruits!;
      _listDivision.add(_listOPHSupervise[i].supervisiAncakDivisionCode!);
    }
    notifyListeners();
  }

  onChangeDivision(String division) {
    onChangeFilter(division, _valueKemandoran);
  }

  onChangeKemandoran(String kemandoran) {
    onChangeFilter(_valueDivision, kemandoran);
  }

  onChangeFilter(String division, String kemandoran) {
    _valueDivision = division;
    _valueKemandoran = kemandoran;
    _listOPHSuperviseResult.clear();
    if (division == "Semua" && kemandoran == "Semua") {
      notifyListeners();
      return;
    } else if (division == "Semua") {
      _listOPHSupervise.forEach((element) {
        if (element.supervisiAncakDivisionCode!
            .toLowerCase()
            .contains(division.toLowerCase()))
          _listOPHSuperviseResult.add(element);
      });
      notifyListeners();
    } else if (kemandoran == "Semua") {
      _listOPHSupervise.forEach((element) {
        if (element.supervisiAncakMandorEmployeeName!
            .toLowerCase()
            .contains(kemandoran.toLowerCase()))
          _listOPHSuperviseResult.add(element);
      });
      notifyListeners();
    } else {
      _listOPHSupervise.forEach((element) {
        if (element.supervisiAncakDivisionCode!
            .toLowerCase()
            .contains(division.toLowerCase()) &&
            element.supervisiAncakPemanenEmployeeName!
                .toLowerCase()
                .contains(kemandoran.toLowerCase()))
          _listOPHSuperviseResult.add(element);
      });
      notifyListeners();
    }
  }
}
