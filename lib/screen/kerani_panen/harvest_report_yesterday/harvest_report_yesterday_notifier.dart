import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/database/service/database_laporan_panen_kemarin.dart';
import 'package:epms/model/laporan_panen_kemarin.dart';
import 'package:flutter/material.dart';

class HarvestReportYesterdayNotifier extends ChangeNotifier {
  List<LaporanPanenKemarin> _listLaporanPanen = [];

  List<LaporanPanenKemarin> get listLaporanPanen => _listLaporanPanen;

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
    _listLaporanPanen = await DatabaseLaporanPanenKemarin().selectLaporanPanenKemarinByDate(date);
    if(_listLaporanPanen.isEmpty) {
      var yesterday = new DateTime(now.year, now.month, now.day);
      String date = TimeManager.dateWithDash(yesterday);
      _listLaporanPanen = await DatabaseLaporanPanenKemarin().selectLaporanPanenKemarinByDate(date);
      _listLaporanPanen.forEach((element) {
        _totalBunches = _totalBunches + element.bunchesTotal;
        _totalLooseFruits = _totalLooseFruits + element.looseFruits;
        _totalBunchesRipe = _totalBunchesRipe + element.bunchesRipe;
        _totalBunchesOverRipe = _totalBunchesOverRipe + element.bunchesOverripe;
        _totalBunchesHalfRipe = _totalBunchesHalfRipe + element.bunchesHalfripe;
        _totalBunchesUnRipe = _totalBunchesUnRipe + element.bunchesUnripe;
        _totalBunchesAbnormal = _totalBunchesAbnormal + element.bunchesAbnormal;
        _totalBunchesEmpty = _totalBunchesEmpty + element.bunchesEmpty;
        _totalBunchesNotSent = _totalBunchesNotSent + element.bunchesNotSent;
      });
      _totalHarvester = _listLaporanPanen.length;
      _dateFilterValue = "Hari ini";
    } else {
      _listLaporanPanen = await DatabaseLaporanPanenKemarin().selectLaporanPanenKemarinByDate(date);
      _listLaporanPanen.forEach((element) {
        _totalBunches = _totalBunches + element.bunchesTotal;
        _totalLooseFruits = _totalLooseFruits + element.looseFruits;
        _totalBunchesRipe = _totalBunchesRipe + element.bunchesRipe;
        _totalBunchesOverRipe = _totalBunchesOverRipe + element.bunchesOverripe;
        _totalBunchesHalfRipe = _totalBunchesHalfRipe + element.bunchesHalfripe;
        _totalBunchesUnRipe = _totalBunchesUnRipe + element.bunchesUnripe;
        _totalBunchesAbnormal = _totalBunchesAbnormal + element.bunchesAbnormal;
        _totalBunchesEmpty = _totalBunchesEmpty + element.bunchesEmpty;
        _totalBunchesNotSent = _totalBunchesNotSent + element.bunchesNotSent;
      });
      _totalHarvester = _listLaporanPanen.length;
      _dateFilter.insert(0, _listLaporanPanen[0].createdDate!);
      _dateFilterValue = _listLaporanPanen[0].createdDate!;
    }

    notifyListeners();
  }

  onSetDateFilter(String value) async {
    _listLaporanPanen.clear();
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
      DateTime now = DateTime.now();
      String date = TimeManager.dateWithDash(now);
      List<LaporanPanenKemarin> list = await DatabaseLaporanPanenKemarin()
          .selectLaporanPanenKemarinByDate(date);
      list.forEach((element) {
        _totalBunches = _totalBunches + element.bunchesTotal;
        _totalLooseFruits = _totalLooseFruits + element.looseFruits;
        _totalBunchesRipe = _totalBunchesRipe + element.bunchesRipe;
        _totalBunchesOverRipe = _totalBunchesOverRipe + element.bunchesOverripe;
        _totalBunchesHalfRipe = _totalBunchesHalfRipe + element.bunchesHalfripe;
        _totalBunchesUnRipe = _totalBunchesUnRipe + element.bunchesUnripe;
        _totalBunchesAbnormal = _totalBunchesAbnormal + element.bunchesAbnormal;
        _totalBunchesEmpty = _totalBunchesEmpty + element.bunchesEmpty;
        _totalBunchesNotSent = _totalBunchesNotSent + element.bunchesNotSent;
        _totalHarvester = list.length;
        _listLaporanPanen.add(element);
      });
      notifyListeners();
    } else {
      DateTime now = DateTime.now();
      var yesterday = new DateTime(now.year, now.month, now.day - 1);
      String date = TimeManager.dateWithDash(yesterday);
      List<LaporanPanenKemarin> list = await DatabaseLaporanPanenKemarin()
          .selectLaporanPanenKemarinByDate(date);
      list.forEach((element) {
        _totalBunches = _totalBunches + element.bunchesTotal;
        _totalLooseFruits = _totalLooseFruits + element.looseFruits;
        _totalBunchesRipe = _totalBunchesRipe + element.bunchesRipe;
        _totalBunchesOverRipe = _totalBunchesOverRipe + element.bunchesOverripe;
        _totalBunchesHalfRipe = _totalBunchesHalfRipe + element.bunchesHalfripe;
        _totalBunchesUnRipe = _totalBunchesUnRipe + element.bunchesUnripe;
        _totalBunchesAbnormal = _totalBunchesAbnormal + element.bunchesAbnormal;
        _totalBunchesEmpty = _totalBunchesEmpty + element.bunchesEmpty;
        _totalBunchesNotSent = _totalBunchesNotSent + element.bunchesNotSent;
        _totalHarvester = list.length;
        _listLaporanPanen.add(element);
      });
      notifyListeners();
      return;
    }
  }
}
