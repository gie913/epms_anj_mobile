import 'dart:convert';

import 'package:epms/base/common/locator.dart';
import 'package:epms/common_manager/camera_service.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/oph_card_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/common_manager/validation_service.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_oph.dart';
import 'package:epms/database/service/database_t_abw.dart';
import 'package:epms/model/m_c_oph_card_schema.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/oph_new.dart';
import 'package:epms/model/t_abw_schema.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class BagiOPHNotifier extends ChangeNotifier {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  TextEditingController ophNumber = TextEditingController();

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

  Barcode? _resultBarcode;

  Barcode? get resultBarcode => _resultBarcode;

  QRViewController? _controller;

  QRViewController? get controller => _controller;

  ValueNotifier<dynamic> result = ValueNotifier(null);

  ValueNotifier<dynamic> resultNFCNew = ValueNotifier(null);

  bool _isOldSaved = false;

  bool get isOldSaved => _isOldSaved;

  bool _isNewSaved = false;

  bool get isNewSaved => _isNewSaved;

  OPH _oph = new OPH();

  OPH get oph => _oph;

  OPHNew _newOPH = new OPHNew();

  OPHNew get newOPH => _newOPH;

  bool _canEdit = false;

  bool get canEdit => _canEdit;

  int _bunchesRipePrev = 0;

  int get bunchesRipePrev => _bunchesRipePrev;

  int _bunchesOverRipePrev = 0;

  int get bunchesOverRipePrev => _bunchesOverRipePrev;

  int _bunchesHalfRipePrev = 0;

  int get bunchesHalfRipePrev => _bunchesHalfRipePrev;

  int _bunchesUnRipePrev = 0;

  int get bunchesUnRipePrev => _bunchesUnRipePrev;

  int _bunchesAbnormalPrev = 0;

  int get bunchesAbnormalPrev => _bunchesAbnormalPrev;

  int _bunchesEmptyPrev = 0;

  int get bunchesEmptyPrev => _bunchesEmptyPrev;

  int _bunchesTotalPrev = 0;

  int get bunchesTotalPrev => _bunchesTotalPrev;

  int _looseFruitsPrev = 0;

  int get looseFruitsPrev => _looseFruitsPrev;

  int _bunchesNotSentPrev = 0;

  int get bunchesNotSentPrev => _bunchesNotSentPrev;

  String? _pickedFileOldOPH;

  String? get pickedFileOldOPH => _pickedFileOldOPH;

  String? _pickedFileNewOPH;

  String? get pickedFileNewOPH => _pickedFileNewOPH;

  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  MCOPHCardSchema? _mcophCardSchema;

  MCOPHCardSchema? get mcophCardSchema => _mcophCardSchema;

  bool _isExist = false;

  bool get isExist => _isExist;

  Future<bool> checkAllSaved() async {
    BuildContext context = _navigationService.navigatorKey.currentContext!;
    if (_isNewSaved == false && _isOldSaved == false) {
      return NavigatorService().onWillPopForm(context);
    } else if (_isNewSaved == false && _isOldSaved == true) {
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Bagi OPH",
          "Belum menyimpan OPH Baru");
      return false;
    } else if (_isNewSaved == true && _isOldSaved == false) {
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Bagi OPH",
          "Belum menyimpan OPH Lama");
      return false;
    } else {
      return NavigatorService().onWillPopForm(context);
    }
  }

  void onQRViewCreatedOPH(QRViewController controller, BuildContext context) {
    _controller = controller;
    controller.scannedDataStream.listen((scanData) {
      _resultBarcode = scanData;
      ophNumber.text = resultBarcode!.code!;
      if (resultBarcode != null) {
        Navigator.pop(context);
      }
    });
  }

  void cardOPHNumberCheck(BuildContext context, String ophCard) async {
    if (ophCard.isNotEmpty) {
      ophCard.toUpperCase();
      _mcophCardSchema = await ValidationService.checkMCOPHCardSchema(ophCard);
      _mcophCardSchema ??
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Kode Kartu OPH",
              "Tidak sesuai");
      notifyListeners();
    }
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  Future getCameraOldOPH(BuildContext context) async {
    String? picked = await CameraService.getImageByCamera(context);
    if (picked != null) {
      _oph.ophPhoto = picked;
      notifyListeners();
    }
  }

  Future getCameraNewOPH(BuildContext context) async {
    String? picked = await CameraService.getImageByCamera(context);
    if (picked != null) {
      _newOPH.ophPhoto = picked;
      notifyListeners();
    }
  }

  onInit(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 50));
    OPHCardManager().readOPHCard(context, onSuccessRead, onErrorRead);
    _dialogService.showNFCDialog(
        title: "Tempel Kartu NFC",
        subtitle: "Untuk membaca data",
        buttonText: "Batal",
        onPress: onPressCancelRead);
  }

  onSuccessRead(BuildContext context, OPH oph) {
    checkOPHExist(oph);
    _dialogService.popDialog();
  }

  onErrorRead(BuildContext context, String message) {
    FlushBarManager.showFlushBarWarning(
        _navigationService.navigatorKey.currentContext!,
        "Gagal Membaca",
        message);
  }

  checkOPHExist(OPH oph) async {
    OPH? ophGet = await DatabaseOPH().selectOPHByID(oph.ophId!);
    if (ophGet != null) {
      _oph = ophGet;
      _bunchesRipePrev = _oph.bunchesRipe!;
      _bunchesOverRipePrev = _oph.bunchesOverripe!;
      _bunchesHalfRipePrev = _oph.bunchesHalfripe!;
      _bunchesUnRipePrev = _oph.bunchesUnripe!;
      _bunchesAbnormalPrev = _oph.bunchesAbnormal!;
      _bunchesEmptyPrev = _oph.bunchesEmpty!;
      _bunchesTotalPrev = _oph.bunchesTotal!;
      _looseFruitsPrev = _oph.looseFruits!;
      _bunchesNotSentPrev = _oph.bunchesNotSent!;
      _canEdit = true;
      _isExist = true;
      generateNewOPH(_oph);
    } else {
      _oph = oph;
      _bunchesRipePrev = _oph.bunchesRipe!;
      _bunchesOverRipePrev = _oph.bunchesOverripe!;
      _bunchesHalfRipePrev = _oph.bunchesHalfripe!;
      _bunchesUnRipePrev = _oph.bunchesUnripe!;
      _bunchesAbnormalPrev = _oph.bunchesAbnormal!;
      _bunchesEmptyPrev = _oph.bunchesEmpty!;
      _bunchesTotalPrev = _oph.bunchesTotal!;
      _looseFruitsPrev = _oph.looseFruits!;
      _bunchesNotSentPrev = _oph.bunchesNotSent!;
      generateNewOPH(_oph);
    }
    notifyListeners();
  }

  onPressCancelRead() {
    _dialogService.popDialog();
    _navigationService.pop();
  }

  generateNewOPH(OPH oph) async {
    MConfigSchema mConfigSchema = await DatabaseMConfig().selectMConfig();
    DateTime now = DateTime.now();
    NumberFormat formatterNumber = new NumberFormat("000");
    String number = formatterNumber.format(mConfigSchema.userId);
    String ophString = jsonEncode(oph);
    Map<String, dynamic> ophNewJson = jsonDecode(ophString);
    OPHNew ophTemp = OPHNew.fromJson(ophNewJson);
    _newOPH = ophTemp;
    _newOPH.ophId = "${mConfigSchema.estateCode}" +
        ValueService.generateIDFromDateTime(now) +
        "$number" +
        "M";
    _newOPH.createdDate = TimeManager.dateWithDash(now);
    _newOPH.createdTime = TimeManager.timeWithColon(now);
    _newOPH.ophPhoto = null;
    _newOPH.ophNotes = "Bagi OPH ${ophTemp.ophId}";
    _bunchesRipe.text = "0";
    _bunchesOverRipe.text = "0";
    _bunchesHalfRipe.text = "0";
    _bunchesUnRipe.text = "0";
    _bunchesAbnormal.text = "0";
    _bunchesEmpty.text = "0";
    _looseFruits.text = "0";
    _bunchesTotal.text = "0";
    _bunchesNotSent.text = "0";
  }

  countBunches(BuildContext context,
      TextEditingController textEditingController, int value) {
    if (int.parse(textEditingController.text) > value) {
      textEditingController.value = TextEditingValue(text: "0");
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
    }
    if (textEditingController == bunchesRipe) {
      _bunchesRipePrev =
          oph.bunchesRipe! - int.parse(textEditingController.text);
    } else if (textEditingController == bunchesOverRipe) {
      _bunchesOverRipePrev =
          oph.bunchesOverripe! - int.parse(textEditingController.text);
    } else if (textEditingController == bunchesHalfRipe) {
      _bunchesHalfRipePrev =
          oph.bunchesHalfripe! - int.parse(textEditingController.text);
    } else if (textEditingController == bunchesUnRipe) {
      _bunchesUnRipePrev =
          oph.bunchesUnripe! - int.parse(textEditingController.text);
    } else if (textEditingController == bunchesAbnormal) {
      _bunchesAbnormalPrev =
          oph.bunchesAbnormal! - int.parse(textEditingController.text);
    } else if (textEditingController == bunchesEmpty) {
      _bunchesEmptyPrev =
          oph.bunchesEmpty! - int.parse(textEditingController.text);
    } else if (textEditingController == looseFruits) {
      _looseFruitsPrev =
          oph.looseFruits! - int.parse(textEditingController.text);
    } else if (textEditingController == bunchesNotSent) {
      _bunchesNotSentPrev =
          oph.bunchesNotSent! - int.parse(textEditingController.text);
    }
    try {
      bunchesTotal.text = (int.parse(bunchesRipe.text) +
              int.parse(bunchesOverRipe.text) +
              int.parse(bunchesHalfRipe.text) +
              int.parse(bunchesUnRipe.text) +
              int.parse(bunchesAbnormal.text) +
              int.parse(bunchesEmpty.text))
          .toString();
      _bunchesTotalPrev = oph.bunchesTotal! - int.parse(bunchesTotal.text);
      getEstimationTonnage();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  getEstimationTonnage() async {
    TABWSchema? tabwSchema = await DatabaseTABWSchema()
        .selectTABWSchemaByBlock(_oph.ophBlockCode!, _oph.ophEstateCode!);
    _oph.ophEstimateTonnage = (tabwSchema?.bunchWeight * _bunchesTotalPrev);
    _oph.ophEstimateTonnage =
        double.parse(_oph.ophEstimateTonnage!.toStringAsFixed(3));
    _newOPH.ophEstimateTonnage =
        (tabwSchema?.bunchWeight * int.parse(_bunchesTotal.text));
    _newOPH.ophEstimateTonnage =
        double.parse(_newOPH.ophEstimateTonnage!.toStringAsFixed(3));
    notifyListeners();
  }

  showDialogQuestionOld() {
    if (_oph.ophPhoto != null) {
      showDialogNFCOld();
    } else {
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Foto OPH Lama",
          "Foto OPH Lama belum ada");
    }
    // _dialogService.showOptionDialog(
    //     title: "Save OPH Lama",
    //     subtitle: "Apakan anda ingin memakai kartu",
    //     buttonTextYes: "Ya",
    //     buttonTextNo: "Tidak",
    //     onPressYes: showDialogNFCOld,
    //     onPressNo: saveOldToDatabase);
  }

  saveOldToDatabase() {
    OPH ophOld = OPH();
    ophOld = _oph;
    ophOld.bunchesRipe = _bunchesRipePrev;
    ophOld.bunchesOverripe = _bunchesOverRipePrev;
    ophOld.bunchesHalfripe = _bunchesHalfRipePrev;
    ophOld.bunchesUnripe = _bunchesUnRipePrev;
    ophOld.bunchesAbnormal = _bunchesAbnormalPrev;
    ophOld.bunchesNotSent = _bunchesNotSentPrev;
    ophOld.looseFruits = _looseFruitsPrev;
    ophOld.bunchesEmpty = _bunchesEmptyPrev;
    ophOld.bunchesTotal = _bunchesTotalPrev;
    notifyListeners();
  }

  showDialogNFCOld() {
    // _dialogService.popDialog();
    OPH ophOld = OPH();
    ophOld = _oph;
    ophOld.bunchesRipe = _bunchesRipePrev;
    ophOld.bunchesOverripe = _bunchesOverRipePrev;
    ophOld.bunchesHalfripe = _bunchesHalfRipePrev;
    ophOld.bunchesUnripe = _bunchesUnRipePrev;
    ophOld.bunchesAbnormal = _bunchesAbnormalPrev;
    ophOld.bunchesNotSent = _bunchesNotSentPrev;
    ophOld.looseFruits = _looseFruitsPrev;
    ophOld.bunchesEmpty = _bunchesEmptyPrev;
    ophOld.bunchesTotal = _bunchesTotalPrev;
    notifyListeners();
    OPHCardManager().writeOPHCard(
        _navigationService.navigatorKey.currentContext!,
        ophOld,
        onSuccessWriteOld,
        onErrorWriteOld);
    _dialogService.showNFCDialog(
        title: "Tempelkan kartu NFC",
        subtitle: "Untuk memasukkan data",
        buttonText: "Batal",
        onPress: onPressCancel);
  }

  onSuccessWriteOld(BuildContext context, OPH oph) {
    if (_isExist) {
      updateOPHtoDatabase(context, oph);
    } else {
      saveOPHOldToDatabase(context, oph);
    }
  }

  onErrorWriteOld() {
    _dialogService.popDialog();
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
    FlushBarManager.showFlushBarWarning(
        _navigationService.navigatorKey.currentContext!,
        "Save OPH Lama",
        "Gagal tersimpan");
  }

  showDialogQuestionNew() {
    if (ophNumber.text.isNotEmpty) {
      if (ophNumber.text != _oph.ophCardId) {
        if (_mcophCardSchema != null) {
          if (_newOPH.ophPhoto != null) {
            showDialogNFCNew();
            // _dialogService.showOptionDialog(
            //     title: "Save OPH Baru",
            //     subtitle: "Apakan anda ingin memakai kartu",
            //     buttonTextYes: "Ya",
            //     buttonTextNo: "Tidak",
            //     onPressYes: showDialogNFCNew,
            //     onPressNo: onSaveClickedNew);
          } else {
            FlushBarManager.showFlushBarWarning(
                _navigationService.navigatorKey.currentContext!,
                "Foto OPH Baru",
                "Foto OPH Baru belum ada");
          }
        } else {
          FlushBarManager.showFlushBarWarning(
              _navigationService.navigatorKey.currentContext!,
              "Kartu OPH",
              "Kode tidak sesuai");
        }
      } else {
        FlushBarManager.showFlushBarWarning(
            _navigationService.navigatorKey.currentContext!,
            "Kode Kartu OPH",
            "Tidak boleh sama");
      }
    } else {
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Kode Kartu OPH",
          "Belum terisi");
    }
  }

  showDialogNFCNew() {
    // _dialogService.popDialog();
    OPHNew ophNew = OPHNew();
    ophNew = _newOPH;
    ophNew.bunchesRipe = int.parse(bunchesRipe.text);
    ophNew.bunchesOverripe = int.parse(bunchesOverRipe.text);
    ophNew.bunchesHalfripe = int.parse(bunchesHalfRipe.text);
    ophNew.bunchesUnripe = int.parse(bunchesUnRipe.text);
    ophNew.bunchesAbnormal = int.parse(bunchesAbnormal.text);
    ophNew.bunchesEmpty = int.parse(bunchesEmpty.text);
    ophNew.looseFruits = int.parse(looseFruits.text);
    ophNew.bunchesTotal = int.parse(bunchesTotal.text);
    ophNew.bunchesNotSent = int.parse(bunchesNotSent.text);
    ophNew.ophCardId = ophNumber.text;
    String encode = jsonEncode(_newOPH);
    notifyListeners();
    Map<String, dynamic> map = jsonDecode(encode);
    OPHCardManager().writeOPHCard(
        _navigationService.navigatorKey.currentContext!,
        OPH.fromJson(map),
        onSuccessWriteNew,
        onErrorWriteNew);
    _dialogService.showNFCDialog(
        title: "Tempelkan kartu NFC",
        subtitle: "Untuk memasukkan data",
        buttonText: "Batal",
        onPress: onPressCancel);
  }

  onSuccessWriteNew(BuildContext context, OPH oph) {
    saveOPHNewToDatabase(context, oph);
  }

  onErrorWriteNew() {
    _dialogService.popDialog();
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
    FlushBarManager.showFlushBarWarning(
        _navigationService.navigatorKey.currentContext!,
        "Save OPH Lama",
        "Gagal tersimpan");
  }

  onPressCancel() {
    NfcManager.instance.stopSession();
    _dialogService.popDialog();
  }

  onSaveClickedNew() {
    OPHNew ophNew = OPHNew();
    ophNew = _newOPH;
    ophNew.bunchesRipe = int.parse(bunchesRipe.text);
    ophNew.bunchesOverripe = int.parse(bunchesOverRipe.text);
    ophNew.bunchesHalfripe = int.parse(bunchesHalfRipe.text);
    ophNew.bunchesUnripe = int.parse(bunchesUnRipe.text);
    ophNew.bunchesAbnormal = int.parse(bunchesAbnormal.text);
    ophNew.bunchesEmpty = int.parse(bunchesEmpty.text);
    ophNew.looseFruits = int.parse(looseFruits.text);
    ophNew.bunchesTotal = int.parse(bunchesTotal.text);
    ophNew.bunchesNotSent = int.parse(bunchesNotSent.text);
    ophNew.ophCardId = ophNumber.text;
    String encode = jsonEncode(_newOPH);
    notifyListeners();
    Map<String, dynamic> map = jsonDecode(encode);
    saveOPHNewToDatabase(
        _navigationService.navigatorKey.currentContext!, OPH.fromJson(map));
  }

  saveOPHNewToDatabase(BuildContext context, OPH oph) async {
    int countSaved = await DatabaseOPH().insertOPH(oph);
    if (countSaved > 0) {
      _dialogService.popDialog();
      _isNewSaved = true;
      if (_isNewSaved == true && _isOldSaved == true) {
        _navigationService.pop();
        _navigationService.pop();
      }
      FlushBarManager.showFlushBarSuccess(
          _navigationService.navigatorKey.currentContext!,
          "Save OPH Baru",
          "Berhasil tersimpan");
    } else {
      _dialogService.popDialog();
      FlushBarManager.showFlushBarSuccess(
          _navigationService.navigatorKey.currentContext!,
          "Save OPH Baru",
          "Gagal tersimpan");
    }
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
    notifyListeners();
  }

  saveOPHOldToDatabase(BuildContext context, OPH oph) async {
    int countSaved = await DatabaseOPH().insertOPH(oph);
    if (countSaved > 0) {
      _dialogService.popDialog();
      _isOldSaved = true;
      if (_isNewSaved == true && _isOldSaved == true) {
        _navigationService.pop();
        _navigationService.pop();
      }
      FlushBarManager.showFlushBarSuccess(
          _navigationService.navigatorKey.currentContext!,
          "Save OPH Lama",
          "Berhasil tersimpan");
    } else {
      _dialogService.popDialog();
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Save OPH Lama",
          "Gagal tersimpan");
    }
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
    notifyListeners();
  }

  updateOPHtoDatabase(BuildContext context, OPH oph) async {
    int countSaved = await DatabaseOPH().updateOPHByID(oph);
    if (countSaved > 0) {
      _dialogService.popDialog();
      _isOldSaved = true;
      if (_isNewSaved == true && _isOldSaved == true) {
        _navigationService.pop();
        _navigationService.pop();
      }
      FlushBarManager.showFlushBarSuccess(
          _navigationService.navigatorKey.currentContext!,
          "Save OPH Lama",
          "Berhasil tersimpan");
    } else {
      _dialogService.popDialog();
      FlushBarManager.showFlushBarSuccess(
          _navigationService.navigatorKey.currentContext!,
          "Save OPH Lama",
          "Berhasil tersimpan");
    }
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
  }
}
