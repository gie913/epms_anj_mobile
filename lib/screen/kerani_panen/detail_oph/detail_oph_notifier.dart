import 'dart:convert';
import 'dart:developer';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/camera_service.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/oph_card_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/common_manager/validation_service.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/database/service/database_laporan_panen_kemarin.dart';
import 'package:epms/database/service/database_m_customer_code.dart';
import 'package:epms/database/service/database_m_employee.dart';
import 'package:epms/database/service/database_oph.dart';
import 'package:epms/database/service/database_t_abw.dart';
import 'package:epms/model/laporan_panen_kemarin.dart';
import 'package:epms/model/m_block_schema.dart';
import 'package:epms/model/m_customer_code_schema.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/t_abw_schema.dart';
import 'package:flutter/material.dart';
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

  TextEditingController _blockNumber = TextEditingController();

  TextEditingController get blockNumber => _blockNumber;

  MBlockSchema? _mBlockSchema;

  MBlockSchema? get mBlockSchema => _mBlockSchema;

  ValueNotifier<dynamic> resultNFC = ValueNotifier(null);

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
    // _navigationService.push(Routes.HOME_PAGE);
    _navigationService.pop();
  }

  void blockNumberCheck(BuildContext context, String block) async {
    if (block.isNotEmpty) {
      block.toUpperCase();
      _mBlockSchema =
          await ValidationService.checkBlockSchema(block, _oph.ophEstateCode!);
      _mBlockSchema ??
          FlushBarManager.showFlushBarWarning(
              context, "Kode Blok", "Tidak sesuai dengan estate");
    } else {
      _mBlockSchema = null;
    }
    notifyListeners();
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
      _blockNumber.text = _oph.ophBlockCode!;
      blockNumberCheck(context, _oph.ophBlockCode!);
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
      _blockNumber.text = _oph.ophBlockCode!;
      blockNumberCheck(context, _oph.ophBlockCode!);
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
    print('cek kartu oph : ${_oph.ophCardId}');
    print('cek blok oph : ${_oph.ophBlockCode}');
    print('cek blok oph text: ${blockNumber.text}');

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
      _blockNumber.text = _oph.ophBlockCode.toString();
      print('cek oph baca first : ${_oph.ophBlockCode}');
      _isExist = true;
    } else {
      _oph = oph;
      List<MEmployeeSchema> kemandoran = await DatabaseMEmployeeSchema()
          .selectMEmployeeSchemaByCode(oph.mandorEmployeeCode!);
      List<MEmployeeSchema> pekerja = await DatabaseMEmployeeSchema()
          .selectMEmployeeSchemaByCode(oph.employeeCode!);
      List<MCustomerCodeSchema> listMCustomer =
          await DatabaseMCustomerCodeSchema().selectMCustomerCodeSchema();

      if (kemandoran.isNotEmpty && pekerja.isNotEmpty) {
        _oph.mandorEmployeeName = kemandoran[0].employeeName;
        _oph.employeeName = pekerja[0].employeeName;
      }

      if (ValueService.typeOfFormToText(_oph.ophHarvestingType ?? 1) ==
          'Pinjam') {
        if (listMCustomer.isNotEmpty) {
          log('listMCustomer : $listMCustomer');
          final listMCustomerCode =
              listMCustomer.map((e) => e.customerCode ?? '').toList();
          final mCustomerCode = listMCustomerCode
              .firstWhere((element) => element.contains(_oph.ophEstateCode!));
          _oph.ophCustomerCode = mCustomerCode;
        }
      }
    }
    _dialogService.popDialog();
    notifyListeners();
  }

  getEstimationTonnage() async {
    TABWSchema? tabwSchema = await DatabaseTABWSchema()
        .selectTABWSchemaByBlock(_oph.ophBlockCode!, _oph.ophEstateCode!);
    _oph.ophEstimateTonnage =
        (tabwSchema?.bunchWeight * int.parse(_bunchesTotal.text));
    _oph.ophEstimateTonnage =
        double.parse(_oph.ophEstimateTonnage!.toStringAsFixed(3));
    notifyListeners();
  }

  getCamera(BuildContext context) async {
    String? picked = await CameraService.getImageByCamera(context);
    if (picked != null) {
      _oph.ophPhoto = picked;
      notifyListeners();
    }
  }

  onUpdateOPHClicked(BuildContext context) {
    dialogNFCWrite();
    // _dialogService.showOptionDialog(
    //     title: "Memakai Kartu NFC",
    //     subtitle: "Apakah ingin menyimpan data dengan NFC?",
    //     buttonTextYes: "Ya",
    //     buttonTextNo: "Tidak",
    //     onPressYes: dialogNFCWrite,
    //     onPressNo: updateOPHToDatabase);
  }

  onSaveChangeCard(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_blockNumber.text.isNotEmpty) {
      if (_mBlockSchema != null) {
        if (_oph.ophCardId != ophNumber.text) {
          print('cek onSaveChangeCard');
          print(
              'cek kebenaran 1 : ${_oph.ophCardId} != ${ophNumber.text} ${_oph.ophCardId != ophNumber.text}');
          if (_restan) {
            print('doWriteRestanDialog');
            doWriteRestanDialog();
          } else {
            print('onUpdateOPHClicked');
            onUpdateOPHClicked(context);
          }
        } else {
          FlushBarManager.showFlushBarWarning(
              context, "Kartu OPH", "Kartu OPH belum diganti");
        }
      } else {
        FlushBarManager.showFlushBarWarning(
            context, "Kode Blok", "Kode Blok tidak sesuai");
      }
    } else {
      FlushBarManager.showFlushBarWarning(
          context, "Kode Blok", "Anda belum memasukkan block");
    }
  }

  dialogNFCWrite() {
    // _dialogService.popDialog();
    _oph.bunchesRipe = int.tryParse(bunchesRipe.text);
    _oph.bunchesOverripe = int.tryParse(bunchesOverRipe.text);
    _oph.bunchesHalfripe = int.tryParse(bunchesHalfRipe.text);
    _oph.bunchesUnripe = int.tryParse(bunchesUnRipe.text);
    _oph.bunchesAbnormal = int.tryParse(bunchesAbnormal.text);
    _oph.bunchesEmpty = int.tryParse(bunchesEmpty.text);
    _oph.looseFruits = int.tryParse(looseFruits.text);
    _oph.bunchesTotal = int.tryParse(bunchesTotal.text);
    _oph.bunchesNotSent = int.tryParse(bunchesNotSent.text);
    // azis
    _oph.ophBlockCode = blockNumber.text;
    if (ophNumber.text.isNotEmpty) {
      _oph.ophCardId = ophNumber.text;
    }
    if (_onEdit) {
      print('onEdit : true');
      OPHCardManager().readWriteOPHCard(
          _navigationService.navigatorKey.currentContext!,
          _oph,
          onSuccessWrite,
          onErrorWrite);
    } else {
      print('onEdit : false');
      OPHCardManager().writeOPHCard(
          _navigationService.navigatorKey.currentContext!,
          _oph,
          onSuccessWrite,
          onErrorWrite);
    }
    _dialogService.showNFCDialog(
        title: "Tempel Kartu NFC",
        subtitle: "Untuk membaca data",
        buttonText: "Batal",
        onPress: _dialogService.popDialog);
  }

  onSuccessWrite(BuildContext context, OPH oph) {
    updateOPHToDatabase();
  }

  onErrorWrite(BuildContext context, String message) {
    _dialogService.popDialog();
    FlushBarManager.showFlushBarWarning(
        _navigationService.navigatorKey.currentContext!,
        "Simpan OPH",
        "$message");
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
  }

  updateOPHToDatabase() async {
    DateTime now = DateTime.now();
    _oph.updatedDate = TimeManager.dateWithDash(now);
    _oph.updatedTime = TimeManager.timeWithColon(now);
    if (_onChangeCard) {
      _oph.ophCardId = ophNumber.text;
    } else {
      _oph.ophNotes = notesOPH.text;
      _oph.ophBlockCode = _blockNumber.text;
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
      // updateLaporanPanenKemarin();
      try {
        _dialogService.popDialog();
        _navigationService.push(Routes.HOME_PAGE);
        FlushBarManager.showFlushBarSuccess(
            _navigationService.navigatorKey.currentContext!,
            "Simpan OPH",
            "Berhasil Menyimpan");
      } catch (e) {
        _dialogService.popDialog();
        FlushBarManager.showFlushBarWarning(
            _navigationService.navigatorKey.currentContext!,
            "Simpan OPH",
            "Gagal Menyimpan");
      }
    } else {
      _dialogService.popDialog();
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Simpan OPH",
          "Gagal Menyimpan");
    }
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
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
    _dialogService.popDialog();
    _navigationService.push(Routes.HOME_PAGE);
    FlushBarManager.showFlushBarSuccess(
        _navigationService.navigatorKey.currentContext!,
        "Simpan OPH",
        "Berhasil Menyimpan");
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
  }

  onErrorWriteRestan(BuildContext context) {
    _dialogService.popDialog();
    FlushBarManager.showFlushBarSuccess(
        _navigationService.navigatorKey.currentContext!,
        "Simpan OPH",
        "Berhasil Menyimpan");
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
  }
}
