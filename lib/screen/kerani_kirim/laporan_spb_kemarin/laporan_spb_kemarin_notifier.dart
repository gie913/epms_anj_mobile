import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/database/service/database_laporan_spb_kemarin.dart';
import 'package:epms/model/laporan_spb_kemarin.dart';
import 'package:flutter/material.dart';

class LaporanSPBKemarinNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  List<LaporanSPBKemarin> _listLaporanSPBKemarin = [];

  List<LaporanSPBKemarin> get listLaporanSPBKemarin => _listLaporanSPBKemarin;

  int _totalBunches = 0;

  int get totalBunches => _totalBunches;

  int _totalLoosFruits = 0;

  int get totalLoosFruits => _totalLoosFruits;

  dynamic _totalWeight = 0;

  dynamic get totalWeight => _totalWeight;

  onInitLaporanSPBKemarin() async {
    _listLaporanSPBKemarin =
        await DatabaseLaporanSPBKemarin().selectLaporanSPBKemarin();
    if (_listLaporanSPBKemarin.isNotEmpty) {
      for (int i = 0; i < _listLaporanSPBKemarin.length; i++) {
        _totalBunches =
            _totalBunches + _listLaporanSPBKemarin[i].spbTotalBunches!;
        _totalLoosFruits =
            _totalLoosFruits + _listLaporanSPBKemarin[i].spbTotalLooseFruit!;
        _totalWeight =
            _totalWeight + _listLaporanSPBKemarin[i].spbActualTonnage!;
      }
    }
    notifyListeners();
  }

  onClickLaporanSPBKemarin(LaporanSPBKemarin laporanSPBKemarin) {
    _navigationService.push(Routes.SPB_KEMARIN_DETAIL, arguments: laporanSPBKemarin);
  }
}
