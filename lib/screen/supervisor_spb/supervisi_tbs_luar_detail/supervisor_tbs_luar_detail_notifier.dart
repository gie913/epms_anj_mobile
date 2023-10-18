import 'dart:developer';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/camera_service.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/tbs_luar_card_manager.dart';
import 'package:epms/database/service/database_t_auth.dart';
import 'package:epms/database/service/database_tbs_luar.dart';
import 'package:epms/model/auth_model.dart';
import 'package:epms/model/tbs_luar.dart';
import 'package:epms/widget/dialog_approval_tbs_luar.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class SupervisorTBSLuarDetailNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  TBSLuar? _tbsLuar;

  TBSLuar? get tbsLuar => _tbsLuar;

  bool _onEdit = false;

  bool get onEdit => _onEdit;

  String? _pickedFile;

  String? get pickedFile => _pickedFile;

  TextEditingController _bunchesUnRipe = TextEditingController();

  TextEditingController get bunchesUnRipe => _bunchesUnRipe;

  TextEditingController _bunchesHalfRipe = TextEditingController();

  TextEditingController get bunchesHalfRipe => _bunchesHalfRipe;

  TextEditingController _bunchesOverRipe = TextEditingController();

  TextEditingController get bunchesOverRipe => _bunchesOverRipe;

  TextEditingController _bunchesRotten = TextEditingController();

  TextEditingController get bunchesRotten => _bunchesRotten;

  TextEditingController _bunchesAbnormal = TextEditingController();

  TextEditingController get bunchesAbnormal => _bunchesAbnormal;

  TextEditingController _bunchesEmpty = TextEditingController();

  TextEditingController get bunchesEmpty => _bunchesEmpty;

  TextEditingController _rubbish = TextEditingController();

  TextEditingController get rubbish => _rubbish;

  TextEditingController _water = TextEditingController();

  TextEditingController get water => _water;

  TextEditingController _longStalk = TextEditingController();

  TextEditingController get longStalk => _longStalk;

  TextEditingController _looseFruits = TextEditingController();

  TextEditingController get looseFruits => _looseFruits;

  TextEditingController _bunchesTotal = TextEditingController();

  TextEditingController get bunchesTotal => _bunchesTotal;

  TextEditingController _deduction = TextEditingController();

  TextEditingController get deduction => _deduction;

  TextEditingController _bunchesLarge = TextEditingController();

  TextEditingController get bunchesLarge => _bunchesLarge;

  TextEditingController _bunchesMedium = TextEditingController();

  TextEditingController get bunchesMedium => _bunchesMedium;

  TextEditingController _bunchesSmall = TextEditingController();

  TextEditingController get bunchesSmall => _bunchesSmall;

  TextEditingController _bunchesLess4Kg = TextEditingController();

  TextEditingController get bunchesLess4Kg => _bunchesLess4Kg;

  TextEditingController _bunchesCengkeh = TextEditingController();

  TextEditingController get bunchesCengkeh => _bunchesCengkeh;

  TextEditingController _brondolanRotten = TextEditingController();

  TextEditingController get brondolanRotten => _brondolanRotten;

  TextEditingController _notesOPH = TextEditingController();

  TextEditingController get notesOPH => _notesOPH;

  List<AuthModel> _authList = [];

  List<AuthModel> get authList => _authList;

  AuthModel _selectedAuth = AuthModel();

  AuthModel get selectedAuth => _selectedAuth;

  onInit(BuildContext context, TBSLuar? tbsLuar, String method) async {
    if (method != "BACA") {
      _tbsLuar = tbsLuar;
      _bunchesUnRipe.text = _tbsLuar!.bunchesUnripe.toString();
      _bunchesHalfRipe.text = _tbsLuar!.bunchesHalfripe.toString();
      _bunchesOverRipe.text = _tbsLuar!.bunchesOverripe.toString();
      _bunchesRotten.text = _tbsLuar!.bunchesRotten.toString();
      _bunchesAbnormal.text = _tbsLuar!.bunchesAbnormal.toString();
      _bunchesEmpty.text = _tbsLuar!.bunchesEmpty.toString();
      _rubbish.text = _tbsLuar!.rubbish.toString();
      _water.text = _tbsLuar!.water.toString();
      _longStalk.text = _tbsLuar!.longStalk.toString();
      _bunchesTotal.text = _tbsLuar!.bunchesTotal.toString();
      _deduction.text = _tbsLuar!.deduction.toString();
      _bunchesLarge.text = _tbsLuar!.large.toString();
      _bunchesSmall.text = _tbsLuar!.small.toString();
      _bunchesMedium.text = _tbsLuar!.medium.toString();
      _brondolanRotten.text = _tbsLuar!.brondolanRotten.toString();
      _bunchesCengkeh.text = _tbsLuar!.bunchesCengkeh.toString();
      _bunchesLess4Kg.text = _tbsLuar!.bunchesLess4Kg.toString();
      _notesOPH.text = _tbsLuar!.notes ?? "";
      _pickedFile = _tbsLuar?.gradingPhoto ?? "";
    } else {
      await Future.delayed(Duration(milliseconds: 50));
      TBSLuarCardManager().readTBSLuarCard(context, onSuccessRead, onErrorRead);
      _dialogService.showNFCDialog(
          title: "TBS Luar",
          subtitle: "Tap kartu untuk membaca",
          buttonText: "Batal",
          onPress: onPressCancelRead);
    }
    await getAuthList();
  }

  onSuccessRead(BuildContext context, TBSLuar tbsLuar) {
    checkTBSLuarExist(tbsLuar);
  }

  onErrorRead(BuildContext context, String message) {
    FlushBarManager.showFlushBarWarning(context, "Gagal Membaca", message);
  }

  onPressCancelRead() {
    NfcManager.instance.stopSession();
    _dialogService.popDialog();
    _navigationService.pop();
  }

  onChangeFormType(int value) {
    _tbsLuar?.formType = value;
    notifyListeners();
  }

  countBunchesTBSLuar(
      BuildContext context, TextEditingController textEditingController) {
    if (textEditingController.text.isEmpty ||
        textEditingController.text == "0" ||
        textEditingController.text == "00") {
      textEditingController.value = TextEditingValue(text: "0");
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
      String deductionText = (double.parse(_bunchesUnRipe.text) +
              double.parse(_bunchesHalfRipe.text) +
              double.parse(_bunchesOverRipe.text) +
              double.parse(_bunchesRotten.text) +
              double.parse(_brondolanRotten.text) +
              double.parse(_bunchesAbnormal.text) +
              double.parse(_bunchesEmpty.text) +
              double.parse(_rubbish.text) +
              double.parse(_water.text) +
              double.parse(_longStalk.text) +
              double.parse(_bunchesCengkeh.text) +
              double.parse(_bunchesLess4Kg.text))
          .toString();
      if (deductionText == "0.0") {
        _deduction.text = "0";
      } else {
        _deduction.text = deductionText;
      }
    } else {
      if (textEditingController != _bunchesTotal) {
        if (double.parse(textEditingController.text) > 1) {
          textEditingController.text =
              textEditingController.text.replaceFirst(RegExp(r'^0+'), "");
        }
      } else {
        textEditingController.text =
            textEditingController.text.replaceFirst(RegExp(r'^0+'), "");
      }
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
      String deductionText = (double.parse(_bunchesUnRipe.text) +
              double.parse(_bunchesHalfRipe.text) +
              double.parse(_bunchesOverRipe.text) +
              double.parse(_bunchesRotten.text) +
              double.parse(_brondolanRotten.text) +
              double.parse(_bunchesAbnormal.text) +
              double.parse(_bunchesEmpty.text) +
              double.parse(_rubbish.text) +
              double.parse(_water.text) +
              double.parse(_longStalk.text) +
              double.parse(_bunchesCengkeh.text) +
              double.parse(_bunchesLess4Kg.text))
          .toString();
      if (deductionText == "0.0") {
        _deduction.text = "0";
      } else {
        _deduction.text = deductionText;
      }
      notifyListeners();
    }
  }

  showDialogQuestion(BuildContext context) {
    if ((_bunchesTotal.text != "0" && _bunchesSmall.text == "0") ||
        (_bunchesTotal.text == "0" && _bunchesSmall.text != "0")) {
      generateTBSLuar(context);
    } else {
      FlushBarManager.showFlushBarWarning(context, "Sortasi atau Grading",
          "Komidal dan Total janjang hanya diisi salah satu");
    }
  }

  onChangeEdit(bool value) {
    _onEdit = value;
    notifyListeners();
  }

  Future<void> getAuthList() async {
    final data = await DatabaseTAuth().selectTAuth();
    _authList = data;
    _selectedAuth = _authList.first;
    print('cek auth : $_authList');
    // final pinDecode = utf8.decode(base64Decode(_selectedAuth.pin));
    // print('cek auth encode : ${_selectedAuth.pin}');
    // print('cek auth decode : $pinDecode');
    notifyListeners();
  }

  void showDialogApprovalTbsLuar(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return DialogApprovalTbsLuar(
          title: 'Approval Manager',
          labelButton: 'SUBMIT',
          hintText: 'Masukkan PIN',
          listAuthenticator: _authList,
          selectedAuthenticator: _selectedAuth,
          onChangeAuthenticator: (value) {
            onChangeAuth(value);
          },
          onSubmit: (value) {
            log('cek isAuthValid : $value');
            if (value) {
              Navigator.pop(context);
              showDialogQuestion(context);
            }
          },
        );
      },
    );
  }

  void onChangeAuth(AuthModel data) {
    _selectedAuth = data;
    notifyListeners();
  }

  generateTBSLuar(BuildContext context) {
    _tbsLuar?.bunchesUnripe = double.parse(_bunchesUnRipe.text);
    _tbsLuar?.bunchesUnripe = double.parse(_bunchesUnRipe.text);
    _tbsLuar?.bunchesHalfripe = double.parse(_bunchesHalfRipe.text);
    _tbsLuar?.bunchesOverripe = double.parse(_bunchesOverRipe.text);
    _tbsLuar?.bunchesRotten = double.parse(_bunchesRotten.text);
    _tbsLuar?.bunchesAbnormal = double.parse(_bunchesAbnormal.text);
    _tbsLuar?.bunchesEmpty = double.parse(_bunchesEmpty.text);
    _tbsLuar?.rubbish = double.parse(_rubbish.text);
    _tbsLuar?.water = double.parse(_water.text);
    _tbsLuar?.bunchesTotal = double.parse(_bunchesTotal.text);
    _tbsLuar?.deduction = double.parse(_deduction.text);
    _tbsLuar?.small = double.parse(_bunchesSmall.text);
    _tbsLuar?.medium = double.parse(_bunchesMedium.text);
    _tbsLuar?.large = double.parse(_bunchesLarge.text);
    _tbsLuar?.longStalk = double.parse(_longStalk.text);
    _tbsLuar?.bunchesCengkeh = double.parse(_bunchesCengkeh.text);
    _tbsLuar?.brondolanRotten = double.parse(_brondolanRotten.text);
    _tbsLuar?.bunchesLess4Kg = double.parse(_bunchesLess4Kg.text);
    _tbsLuar?.gradingPhoto = _pickedFile;
    _tbsLuar?.notes = _notesOPH.text;
    notifyListeners();
    _dialogService.showOptionDialog(
        title: "Simpan Supervisi SPB",
        subtitle: "Anda yakin ingin menyimpan Supervisi SPB?",
        buttonTextYes: "Iya",
        buttonTextNo: "Tidak",
        onPressYes: onPressYes,
        onPressNo: onPressNo);
  }

  getCamera(BuildContext context) async {
    String? picked = await CameraService.getImageByCamera(context);
    if (picked != null) {
      _pickedFile = picked;
      notifyListeners();
    }
  }

  onPressYes() {
    _dialogService.popDialog();
    TBSLuarCardManager().writeTBSLuarCard(
        _navigationService.navigatorKey.currentContext!,
        _tbsLuar!,
        onSuccessWrite,
        onErrorWrite);
    _dialogService.showNFCDialog(
        title: "Tempel Kartu NFC",
        subtitle: "Untuk memasukkan data",
        buttonText: "Batal",
        onPress: onPressBatal);
  }

  onSuccessWrite(BuildContext context, TBSLuar tbsLuar) {
    saveToDatabase(tbsLuar);
  }

  onErrorWrite(BuildContext context) {
    FlushBarManager.showFlushBarWarning(
        context, "Supplier", "Nama Supplier belum terpilih");
  }

  onPressBatal() {
    NfcManager.instance.stopSession();
    _dialogService.popDialog();
  }

  onPressNo() {
    _dialogService.popDialog();
  }

  saveToDatabase(TBSLuar tbsLuar) async {
    _dialogService.popDialog();
    int count = await DatabaseTBSLuar().updateTBSLuarByID(tbsLuar);
    if (count > 0) {
      _navigationService.push(Routes.HOME_PAGE);
      FlushBarManager.showFlushBarSuccess(
          _navigationService.navigatorKey.currentContext!,
          "Supervisi TBS Luar",
          "Berhasil tersimpan");
    } else {
      FlushBarManager.showFlushBarError(
          _navigationService.navigatorKey.currentContext!,
          "Supervisi TBS Luar",
          "Gagal tersimpan");
    }
  }

  void checkTBSLuarExist(TBSLuar tbsLuarTemp) async {
    TBSLuar? tbsLuar =
        await DatabaseTBSLuar().selectTBSLuarByID(tbsLuarTemp.spdID!);
    if (tbsLuar != null) {
      _tbsLuar = tbsLuar;
      _bunchesUnRipe.text = _tbsLuar!.bunchesUnripe.toString();
      _bunchesHalfRipe.text = _tbsLuar!.bunchesHalfripe.toString();
      _bunchesOverRipe.text = _tbsLuar!.bunchesOverripe.toString();
      _bunchesRotten.text = _tbsLuar!.bunchesRotten.toString();
      _bunchesAbnormal.text = _tbsLuar!.bunchesAbnormal.toString();
      _bunchesEmpty.text = _tbsLuar!.bunchesEmpty.toString();
      _rubbish.text = _tbsLuar!.rubbish.toString();
      _water.text = _tbsLuar!.water.toString();
      _longStalk.text = _tbsLuar!.longStalk.toString();
      _bunchesTotal.text = _tbsLuar!.bunchesTotal.toString();
      _deduction.text = _tbsLuar!.deduction.toString();
      _bunchesLarge.text = _tbsLuar!.large.toString();
      _bunchesSmall.text = _tbsLuar!.small.toString();
      _bunchesMedium.text = _tbsLuar!.medium.toString();
      _brondolanRotten.text = _tbsLuar!.brondolanRotten.toString();
      _bunchesCengkeh.text = _tbsLuar!.bunchesCengkeh.toString();
      _bunchesLess4Kg.text = _tbsLuar!.bunchesLess4Kg.toString();
      _notesOPH.text = _tbsLuar!.notes ?? "";
      _pickedFile = _tbsLuar!.gradingPhoto ?? "";
      notifyListeners();
      Future.delayed(Duration(seconds: 1), () {
        NfcManager.instance.stopSession();
      });
      _dialogService.popDialog();
    } else {
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Detail Grading Luar",
          "Tidak tersedia di gadget");
    }
  }
}
