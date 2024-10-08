import 'dart:convert';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/camera_service.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/oph_card_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/database/service/database_laporan_panen_kemarin.dart';
import 'package:epms/database/service/database_m_employee.dart';
import 'package:epms/database/service/database_oph.dart';
import 'package:epms/database/service/database_t_abw.dart';
import 'package:epms/model/laporan_panen_kemarin.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/t_abw_schema.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nfc_manager/nfc_manager.dart';

class DetailOPHNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  OPH _oph = OPH();

  OPH get oph => _oph;

  bool _isExist = false;

  bool get isExist => _isExist;

  bool _onEdit = false;

  bool get onEdit => _onEdit;

  TextEditingController _notesOPH = TextEditingController();

  TextEditingController get notesOPH => _notesOPH;

  TextEditingController _bunchesRipe = TextEditingController();

  TextEditingController get bunchesRipe => _bunchesRipe;

  TextEditingController _bunchesOverRipe = TextEditingController();

  TextEditingController get bunchesOverRipe => _bunchesOverRipe;

  TextEditingController _bunchesHalfRipe = TextEditingController();

  TextEditingController get bunchesHalfRipe => _bunchesHalfRipe;

  TextEditingController _bunchesUnRipe = TextEditingController();

  TextEditingController get bunchesUnRipe => _bunchesUnRipe;

  TextEditingController _bunchesAbnormal = TextEditingController();

  TextEditingController get bunchesAbnormal => _bunchesAbnormal;

  TextEditingController _bunchesEmpty = TextEditingController();

  TextEditingController get bunchesEmpty => _bunchesEmpty;

  TextEditingController _looseFruits = TextEditingController();

  TextEditingController get looseFruits => _looseFruits;

  TextEditingController _bunchesTotal = TextEditingController();

  TextEditingController get bunchesTotal => _bunchesTotal;

  TextEditingController _bunchesNotSent = TextEditingController();

  TextEditingController get bunchesNotSent => _bunchesNotSent;

  TextEditingController ophNumber = TextEditingController();

  ValueNotifier<dynamic> resultNFC = ValueNotifier(null);

  ImagePicker _picker = ImagePicker();

  ImagePicker get picker => _picker;

  bool _isChangeCard = false;

  bool get isChangeCard => _isChangeCard;

  bool _onChangeCard = false;

  bool get onChangeCard => _onChangeCard;

  bool _restan = false;

  bool get restan => _restan;

  onSuccessRead(BuildContext context, OPH oph) {
    checkOPHExist(oph);
  }

  onErrorRead(BuildContext context, String message) {
    FlushBarManager.showFlushBarWarning(context, "Gagal Membaca", message);
  }

  onPressCancelRead() {
    _dialogService.popDialog();
    _navigationService.push(Routes.HOME_PAGE);
  }

  onInit(BuildContext context, OPH oph, String method, bool isRestan) async {
    _restan = isRestan;
    if (method == "BACA") {
      await Future.delayed(Duration(milliseconds: 50));
      OPHCardManager().readOPHCard(context, onSuccessRead, onErrorRead);
      _dialogService.showNFCDialog(
          title: "Tempel Kartu NFC",
          subtitle: "Untuk membaca data",
          buttonText: "Batal",
          onPress: onPressCancelRead);
    } else if (method == "GANTI") {
      _isChangeCard = true;
      _oph = oph;
      notesOPH.text = _oph.ophNotes ?? "";
      bunchesRipe.text = _oph.bunchesRipe!.toString();
      bunchesOverRipe.text = _oph.bunchesOverripe.toString();
      bunchesHalfRipe.text = _oph.bunchesHalfripe.toString();
      bunchesUnRipe.text = _oph.bunchesUnripe.toString();
      bunchesAbnormal.text = _oph.bunchesAbnormal.toString();
      bunchesEmpty.text = _oph.bunchesEmpty.toString();
      looseFruits.text = _oph.looseFruits.toString();
      bunchesTotal.text = _oph.bunchesTotal.toString();
      bunchesNotSent.text = _oph.bunchesNotSent.toString();
    } else {
      _oph = oph;
      notesOPH.text = _oph.ophNotes ?? "";
      bunchesRipe.text = _oph.bunchesRipe!.toString();
      bunchesOverRipe.text = _oph.bunchesOverripe.toString();
      bunchesHalfRipe.text = _oph.bunchesHalfripe.toString();
      bunchesUnRipe.text = _oph.bunchesUnripe.toString();
      bunchesAbnormal.text = _oph.bunchesAbnormal.toString();
      bunchesEmpty.text = _oph.bunchesEmpty.toString();
      looseFruits.text = _oph.looseFruits.toString();
      bunchesTotal.text = _oph.bunchesTotal.toString();
      bunchesNotSent.text = _oph.bunchesNotSent.toString();
      _isExist = true;
    }
  }

  countBunches(
      BuildContext context, TextEditingController textEditingController) {
    try {
      getEstimationTonnage();
      bunchesTotal.text = (int.parse(bunchesRipe.text) +
              int.parse(bunchesOverRipe.text) +
              int.parse(bunchesHalfRipe.text) +
              int.parse(bunchesUnRipe.text) +
              int.parse(bunchesAbnormal.text) +
              int.parse(bunchesEmpty.text))
          .toString();
    } catch (e) {
      print(e);
    }
  }

  void onChangeEdit() {
    _onEdit = true;
    notifyListeners();
  }

  void onChangeCardEdit() {
    _onChangeCard = true;
    _isChangeCard = false;
    ophNumber.text = _oph.ophCardId!;
    notifyListeners();
  }

  checkOPHExist(OPH oph) async {
    OPH? ophGet = await DatabaseOPH().selectOPHByID(oph.ophId!);
    if (ophGet != null) {
      _oph = ophGet;
      notesOPH.text = _oph.ophNotes ?? "";
      bunchesRipe.text = _oph.bunchesRipe.toString();
      bunchesOverRipe.text = _oph.bunchesOverripe.toString();
      bunchesHalfRipe.text = _oph.bunchesHalfripe.toString();
      bunchesUnRipe.text = _oph.bunchesUnripe.toString();
      bunchesAbnormal.text = _oph.bunchesAbnormal.toString();
      bunchesEmpty.text = _oph.bunchesEmpty.toString();
      looseFruits.text = _oph.looseFruits.toString();
      bunchesTotal.text = _oph.bunchesTotal.toString();
      bunchesNotSent.text = _oph.bunchesNotSent.toString();
      _isExist = true;
    } else {
      _oph = oph;
      List<MEmployeeSchema> kemandoran = await DatabaseMEmployeeSchema()
          .selectMEmployeeSchemaByCode(oph.mandorEmployeeCode!);
      List<MEmployeeSchema> pekerja = await DatabaseMEmployeeSchema()
          .selectMEmployeeSchemaByCode(oph.employeeCode!);
      if (kemandoran.isNotEmpty && pekerja.isNotEmpty) {
        _oph.mandorEmployeeName = kemandoran[0].employeeName;
        _oph.employeeName = pekerja[0].employeeName;
      }
    }
    _dialogService.popDialog();
    notifyListeners();
  }

  getEstimationTonnage() async {
    TABWSchema? tabwSchema =
        await DatabaseTABWSchema().selectTABWSchemaByBlock(_oph.ophBlockCode!);
    _oph.ophEstimateTonnage =
        (tabwSchema?.bunchWeight * int.parse(_bunchesTotal.text));
    _oph.ophEstimateTonnage =
        double.parse(_oph.ophEstimateTonnage!.toStringAsFixed(3));
    notifyListeners();
  }

  getCamera(BuildContext context) async {
    String? picked = await CameraService.getImageByCamera();
    if (picked != null) {
      _oph.ophPhoto  = picked;
      notifyListeners();
    }
  }

  onUpdateOPHClicked(BuildContext context) {
    _dialogService.showOptionDialog(
        title: "Memakai Kartu NFC",
        subtitle: "Apakah ingin menyimpan data dengan NFC?",
        buttonTextYes: "Ya",
        buttonTextNo: "Tidak",
        onPressYes: dialogNFCWrite,
        onPressNo: updateOPHToDatabase);
  }

  dialogNFCWrite() {
    _dialogService.popDialog();
    _oph.bunchesRipe = int.tryParse(bunchesRipe.text);
    _oph.bunchesOverripe = int.tryParse(bunchesOverRipe.text);
    _oph.bunchesHalfripe = int.tryParse(bunchesHalfRipe.text);
    _oph.bunchesUnripe = int.tryParse(bunchesUnRipe.text);
    _oph.bunchesAbnormal = int.tryParse(bunchesAbnormal.text);
    _oph.bunchesEmpty = int.tryParse(bunchesEmpty.text);
    _oph.looseFruits = int.tryParse(looseFruits.text);
    _oph.bunchesTotal = int.tryParse(bunchesTotal.text);
    _oph.bunchesNotSent = int.tryParse(bunchesNotSent.text);
    OPHCardManager().writeOPHCard(
        _navigationService.navigatorKey.currentContext!,
        _oph,
        onSuccessWrite,
        onErrorWrite);
    _dialogService.showNFCDialog(
        title: "Tempel Kartu NFC",
        subtitle: "Untuk membaca data",
        buttonText: "Batal",
        onPress: _dialogService.popDialog);
  }

  onSuccessWrite(BuildContext context, OPH oph) {
    updateOPHToDatabase();
  }

  onErrorWrite(BuildContext context) {
    _dialogService.popDialog();
    FlushBarManager.showFlushBarSuccess(
        _navigationService.navigatorKey.currentContext!,
        "Simpan OPH",
        "Berhasil Menyimpan");
  }

  updateOPHToDatabase() async {
    DateTime now = DateTime.now();
    _oph.updatedDate = TimeManager.dateWithDash(now);
    _oph.updatedTime = TimeManager.timeWithColon(now);
    if (_onChangeCard) {
      _oph.ophCardId = ophNumber.text;
    } else {
      _oph.ophNotes = notesOPH.text;
      _oph.bunchesRipe = int.tryParse(bunchesRipe.text);
      _oph.bunchesOverripe = int.tryParse(bunchesOverRipe.text);
      _oph.bunchesHalfripe = int.tryParse(bunchesHalfRipe.text);
      _oph.bunchesUnripe = int.tryParse(bunchesUnRipe.text);
      _oph.bunchesAbnormal = int.tryParse(bunchesAbnormal.text);
      _oph.bunchesEmpty = int.tryParse(bunchesEmpty.text);
      _oph.looseFruits = int.tryParse(looseFruits.text);
      _oph.bunchesTotal = int.tryParse(bunchesTotal.text);
      _oph.bunchesNotSent = int.tryParse(bunchesNotSent.text);
    }

    int count = await DatabaseOPH().updateOPHByID(_oph);
    if (count > 0) {
      updateLaporanPanenKemarin();
      Future.delayed(Duration(seconds: 2), () {
        NfcManager.instance.stopSession();
      });
      _dialogService.popDialog();
      _navigationService.push(Routes.HOME_PAGE);
      FlushBarManager.showFlushBarSuccess(
          _navigationService.navigatorKey.currentContext!,
          "Simpan OPH",
          "Berhasil Menyimpan");
    } else {
      _dialogService.popDialog();
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Simpan OPH",
          "Gagal Menyimpan");
    }
  }

  updateLaporanPanenKemarin() async {
    List<OPH> listOPH = await DatabaseOPH().selectOPH();
    List<LaporanPanenKemarin> laporanKemarin = [];
    if (listOPH.isNotEmpty) {
      DatabaseLaporanPanenKemarin().deleteLaporanPanenKemarinByDate();
      for (int i = 0; i < listOPH.length; i++) {
        LaporanPanenKemarin laporanPanenKemarin =
            LaporanPanenKemarin.fromJson(jsonDecode(jsonEncode(listOPH[i])));
        laporanKemarin.add(laporanPanenKemarin);
      }
      await DatabaseLaporanPanenKemarin()
          .insertLaporanPanenKemarin(laporanKemarin);
    }
  }

  doWriteRestanDialog() {
    if (_onChangeCard) {
      _oph.ophCardId = ophNumber.text;
    } else {
      _oph.ophNotes = notesOPH.text;
      _oph.bunchesRipe = int.tryParse(bunchesRipe.text);
      _oph.bunchesOverripe = int.tryParse(bunchesOverRipe.text);
      _oph.bunchesHalfripe = int.tryParse(bunchesHalfRipe.text);
      _oph.bunchesUnripe = int.tryParse(bunchesUnRipe.text);
      _oph.bunchesAbnormal = int.tryParse(bunchesAbnormal.text);
      _oph.bunchesEmpty = int.tryParse(bunchesEmpty.text);
      _oph.looseFruits = int.tryParse(looseFruits.text);
      _oph.bunchesTotal = int.tryParse(bunchesTotal.text);
      _oph.bunchesNotSent = int.tryParse(bunchesNotSent.text);
    }
    OPHCardManager().writeOPHCard(
        _navigationService.navigatorKey.currentContext!,
        _oph,
        onSuccessWriteRestan,
        onErrorWriteRestan);
    _dialogService.showNFCDialog(
        title: "Tempel Kartu NFC",
        subtitle: "Untuk membaca data",
        buttonText: "Batal",
        onPress: _dialogService.popDialog);
  }

  onSuccessWriteRestan(BuildContext context, OPH oph) {
    Future.delayed(Duration(seconds: 2), () {
      NfcManager.instance.stopSession();
    });
    _dialogService.popDialog();
    _navigationService.push(Routes.HOME_PAGE);
    FlushBarManager.showFlushBarSuccess(
        _navigationService.navigatorKey.currentContext!,
        "Simpan OPH",
        "Berhasil Menyimpan");
  }

  onErrorWriteRestan(BuildContext context) {
    _dialogService.popDialog();
    FlushBarManager.showFlushBarSuccess(
        _navigationService.navigatorKey.currentContext!,
        "Simpan OPH",
        "Berhasil Menyimpan");
  }
}
