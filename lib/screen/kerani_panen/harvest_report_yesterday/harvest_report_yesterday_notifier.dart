import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/database/service/database_laporan_panen_kemarin.dart';
import 'package:epms/database/service/database_oph.dart';
import 'package:epms/model/laporan_panen_kemarin.dart';
import 'package:flutter/material.dart';

class HarvestReportYesterdayNotifier extends ChangeNotifier {
  List<LaporanPanenKemarin> _listLaporanPanenKemarin = [];

  List<LaporanPanenKemarin> get listLaporanPanenKemarin =>
      _listLaporanPanenKemarin;

  List<LaporanPanenKemarin> _listLaporanPanenHariIni = [];

  List<LaporanPanenKemarin> get listLaporanPanenHariIni =>
      _listLaporanPanenHariIni;

  List<LaporanPanenKemarin> _listResult = [];

  List<LaporanPanenKemarin> get listResult => _listResult;

  List<String> _dateFilter = ["Hari ini"];

  List<String> get dateFilter => _dateFilter;

  String _dateFilterValue = "Hari ini";

  String get dateFilterValue => _dateFilterValue;

  dynamic _totalBunches = 0;

  dynamic get totalBunches => _totalBunches;

  dynamic _totalLooseFruits = 0;

  dynamic get totalLooseFruits => _totalLooseFruits;

  dynamic _totalBunchesRipe = 0;

  dynamic get totalBunchesRipe => _totalBunchesRipe;

  dynamic _totalBunchesOverRipe = 0;

  dynamic get totalBunchesOverRipe => _totalBunchesOverRipe;

  dynamic _totalBunchesHalfRipe = 0;

  dynamic get totalBunchesHalfRipe => _totalBunchesHalfRipe;

  dynamic _totalBunchesUnRipe = 0;

  dynamic get totalBunchesUnRipe => _totalBunchesUnRipe;

  dynamic _totalBunchesAbnormal = 0;

  dynamic get totalBunchesAbNormal => _totalBunchesAbnormal;

  dynamic _totalBunchesEmpty = 0;

  dynamic get totalBunchesEmpty => _totalBunchesEmpty;

  dynamic _totalBunchesNotSent = 0;

  dynamic get totalBunchesNotSent => _totalBunchesNotSent;

  dynamic _totalHarvester = 0;

  dynamic get totalHarvester => _totalHarvester;

  getListLaporanPanenKemarin() async {
    DateTime now = DateTime.now();
    var yesterday = new DateTime(now.year, now.month, now.day - 1);
    String date = TimeManager.dateWithDash(yesterday);
    _listLaporanPanenHariIni = await DatabaseOPH().selectLaporanHarian();
    _listLaporanPanenKemarin = await DatabaseLaporanPanenKemarin()
        .selectLaporanPanenKemarinByDate(date);
    if (_listLaporanPanenKemarin.isEmpty) {
      _dateFilterValue = "Hari ini";
      _listResult = _listLaporanPanenHariIni;
      _listResult.forEach((element) {
        _totalBunches = _totalBunches + element.bunchesTotal;
        _totalLooseFruits = _totalLooseFruits + element.looseFruits;
        _totalBunchesRipe = _totalBunchesRipe + element.bunchesRipe;
        _totalBunchesOverRipe = _totalBunchesOverRipe + element.bunchesOverripe;
        _totalBunchesHalfRipe = _totalBunchesHalfRipe + element.bunchesHalfripe;
        _totalBunchesUnRipe = _totalBunchesUnRipe + element.bunchesUnripe;
        _totalBunchesAbnormal = _totalBunchesAbnormal + element.bunchesAbnormal;
        _totalBunchesEmpty = _totalBunchesEmpty + element.bunchesEmpty;
        _totalBunchesNotSent = _totalBunchesNotSent + element.bunchesNotSent;
        _totalHarvester = listResult.length;
      });
    } else {
      _dateFilter.insert(0, _listLaporanPanenKemarin[0].createdDate!);
      _dateFilterValue = _listLaporanPanenKemarin[0].createdDate!;
      _listResult = _listLaporanPanenKemarin;
      _listResult.forEach((element) {
        _totalBunches = _totalBunches + element.bunchesTotal;
        _totalLooseFruits = _totalLooseFruits + element.looseFruits;
        _totalBunchesRipe = _totalBunchesRipe + element.bunchesRipe;
        _totalBunchesOverRipe = _totalBunchesOverRipe + element.bunchesOverripe;
        _totalBunchesHalfRipe = _totalBunchesHalfRipe + element.bunchesHalfripe;
        _totalBunchesUnRipe = _totalBunchesUnRipe + element.bunchesUnripe;
        _totalBunchesAbnormal = _totalBunchesAbnormal + element.bunchesAbnormal;
        _totalBunchesEmpty = _totalBunchesEmpty + element.bunchesEmpty;
        _totalBunchesNotSent = _totalBunchesNotSent + element.bunchesNotSent;
        _totalHarvester = listResult.length;
      });
    }
    notifyListeners();
  }

  onSetDateFilter(String value) async {
    _dateFilterValue = value;
    _totalBunches = 0;
    _totalLooseFruits = 0;
    _totalBunchesRipe = 0;
    _totalBunchesOverRipe = 0;
    _totalBunchesHalfRipe = 0;
    _totalBunchesUnRipe = 0;
    _totalBunchesAbnormal = 0;
    _totalBunchesEmpty = 0;
    _totalBunchesNotSent = 0;
    _totalHarvester = 0;
    if (value == "Hari ini") {
      _listResult = _listLaporanPanenHariIni;
      _listResult.forEach((element) {
        _totalBunches = _totalBunches + element.bunchesTotal;
        _totalLooseFruits = _totalLooseFruits + element.looseFruits;
        _totalBunchesRipe = _totalBunchesRipe + element.bunchesRipe;
        _totalBunchesOverRipe = _totalBunchesOverRipe + element.bunchesOverripe;
        _totalBunchesHalfRipe = _totalBunchesHalfRipe + element.bunchesHalfripe;
        _totalBunchesUnRipe = _totalBunchesUnRipe + element.bunchesUnripe;
        _totalBunchesAbnormal = _totalBunchesAbnormal + element.bunchesAbnormal;
        _totalBunchesEmpty = _totalBunchesEmpty + element.bunchesEmpty;
        _totalBunchesNotSent = _totalBunchesNotSent + element.bunchesNotSent;
        _totalHarvester = _listLaporanPanenHariIni.length;
      });
      notifyListeners();
    } else {
      _listResult = _listLaporanPanenKemarin;
      _listResult.forEach((element) {
        _totalBunches = _totalBunches + element.bunchesTotal;
        _totalLooseFruits = _totalLooseFruits + element.looseFruits;
        _totalBunchesRipe = _totalBunchesRipe + element.bunchesRipe;
        _totalBunchesOverRipe = _totalBunchesOverRipe + element.bunchesOverripe;
        _totalBunchesHalfRipe = _totalBunchesHalfRipe + element.bunchesHalfripe;
        _totalBunchesUnRipe = _totalBunchesUnRipe + element.bunchesUnripe;
        _totalBunchesAbnormal = _totalBunchesAbnormal + element.bunchesAbnormal;
        _totalBunchesEmpty = _totalBunchesEmpty + element.bunchesEmpty;
        _totalBunchesNotSent = _totalBunchesNotSent + element.bunchesNotSent;
        _totalHarvester = _listLaporanPanenKemarin.length;
      });
      notifyListeners();
      return;
    }
  }
}
