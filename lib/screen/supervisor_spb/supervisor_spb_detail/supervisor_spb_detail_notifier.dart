import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/camera_service.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/spb_card_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_spb_supervise.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/model/spb_supervise.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class SupervisorSPBDetailNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  TextEditingController _spbID = TextEditingController();

  TextEditingController get spbID => _spbID;

  bool _activeText = false;

  bool get activeText => _activeText;

  SPBSupervise _spbSupervise = SPBSupervise();

  SPBSupervise get spbSupervise => _spbSupervise;

  MConfigSchema _mConfigSchema = MConfigSchema();

  MConfigSchema get mConfigSchema => _mConfigSchema;

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

  TextEditingController _bunchesNormalTotal = TextEditingController();

  TextEditingController get bunchesNormalTotal => _bunchesNormalTotal;

  TextEditingController _notesOPH = TextEditingController();

  TextEditingController get notesOPH => _notesOPH;

  TextEditingController _janjangTangkaiPanjang = TextEditingController();

  TextEditingController get janjangTangkaiPanjang => _janjangTangkaiPanjang;

  TextEditingController _noteJanjangTangkaiPanjang = TextEditingController();

  TextEditingController get noteJanjangTangkaiPanjang =>
      _noteJanjangTangkaiPanjang;

  TextEditingController _sampah = TextEditingController();

  TextEditingController get sampah => _sampah;

  TextEditingController _batu = TextEditingController();

  TextEditingController get batu => _batu;

  bool _onEdit = false;

  bool get onEdit => _onEdit;

  dialogNFC(BuildContext context) {
    SPBCardManager().readSPBCard(context, onSuccessRead, onErrorRead);
    _dialogService.showNFCDialog(
        title: "Tempel Kartu SPB",
        subtitle: "untuk membaca data",
        buttonText: "Selesai",
        onPress: onCancelScanSPB);
  }

  onCancelScanSPB() {
    _dialogService.popDialog();
    NfcManager.instance.stopSession();
  }

  onSuccessRead(BuildContext context, SPB spb) {
    _dialogService.popDialog();
    _spbID.text = spb.spbId!;
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
    notifyListeners();
  }

  onErrorRead(BuildContext context, String response) {
    _dialogService.popDialog();
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
    FlushBarManager.showFlushBarWarning(context, "Gagal Membaca", response);
  }

  onChangeActiveText(bool checked) {
    _activeText = checked;
    notifyListeners();
  }

  onInit(SPBSupervise spbSupervise) async {
    _mConfigSchema = await DatabaseMConfig().selectMConfig();
    _spbSupervise = spbSupervise;
    _bunchesRipe.text = spbSupervise.bunchesRipe.toString();
    _bunchesOverRipe.text = spbSupervise.bunchesOverripe.toString();
    _bunchesHalfRipe.text = spbSupervise.bunchesHalfripe.toString();
    _bunchesUnRipe.text = spbSupervise.bunchesUnripe.toString();
    _bunchesAbnormal.text = spbSupervise.bunchesAbnormal.toString();
    _bunchesEmpty.text = spbSupervise.bunchesEmpty.toString();
    _looseFruits.text = spbSupervise.looseFruits.toString();
    _bunchesTotal.text = spbSupervise.bunchesTotal.toString();
    _bunchesNormalTotal.text = spbSupervise.bunchesTotalNormal.toString();
    _janjangTangkaiPanjang.text = spbSupervise.bunchesTangkaiPanjang.toString();
    _sampah.text = spbSupervise.bunchesSampah.toString();
    _batu.text = spbSupervise.bunchesBatu.toString();
    _spbID.text = spbSupervise.spbId!;
    _noteJanjangTangkaiPanjang.text = spbSupervise.catatanBunchesTangkaiPanjang.toString();
    _notesOPH.text = spbSupervise.supervisiNotes.toString();
    notifyListeners();
  }

  onPressYes() {
    _dialogService.popDialog();
    updateToDatabase(_navigationService.navigatorKey.currentContext!);
  }

  onPressNo() {
    _dialogService.popDialog();
    NfcManager.instance.stopSession();
  }

  showDialogQuestion(BuildContext context) {
    _dialogService.showOptionDialog(
        title: "Simpan Supervisi",
        subtitle: "Anda yakin ingin menyimpan supervisi?",
        buttonTextYes: "Iya",
        buttonTextNo: "Tidak",
        onPressYes: onPressYes,
        onPressNo: onPressNo);
  }

  countBunches(BuildContext context,
      TextEditingController textEditingController) {
    if (textEditingController.text.isEmpty ||
        textEditingController.text == "0") {
      textEditingController.value = TextEditingValue(text: "0");
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
    } else {
      textEditingController.text =
          textEditingController.text.replaceFirst(RegExp(r'^0+'), "");
      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
    }
    try {
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
    try {
      bunchesNormalTotal.text = (int.parse(bunchesRipe.text) +
          int.parse(bunchesOverRipe.text) +
          int.parse(bunchesHalfRipe.text) +
          int.parse(bunchesUnRipe.text) +
          int.parse(bunchesEmpty.text))
          .toString();
    } catch (e) {
      print(e);
    }
  }

  onChangeEdit() {
    _onEdit = true;
    notifyListeners();
  }

  getCamera(BuildContext context) async {
    String? picked = await CameraService.getImageByCamera(context);
    if (picked != null) {
      this._spbSupervise.supervisiSpbPhoto = picked;
      notifyListeners();
    }
  }

  void updateToDatabase(BuildContext context) async {
    DateTime now = DateTime.now();
    _spbSupervise.bunchesRipe = int.parse(_bunchesRipe.text);
    _spbSupervise.bunchesOverripe = int.parse(_bunchesOverRipe.text);
    _spbSupervise.bunchesHalfripe = int.parse(_bunchesHalfRipe.text);
    _spbSupervise.bunchesUnripe = int.parse(_bunchesUnRipe.text);
    _spbSupervise.bunchesAbnormal = int.parse(_bunchesAbnormal.text);
    _spbSupervise.bunchesEmpty = int.parse(_bunchesEmpty.text);
    _spbSupervise.looseFruits = int.parse(_looseFruits.text);
    _spbSupervise.bunchesTotal = int.parse(_bunchesTotal.text);
    _spbSupervise.bunchesTotalNormal = int.parse(_bunchesNormalTotal.text);
    _spbSupervise.bunchesSampah = int.parse(_sampah.text);
    _spbSupervise.bunchesBatu = int.parse(_batu.text);
    _spbSupervise.bunchesTangkaiPanjang = int.parse(_janjangTangkaiPanjang.text);
    _spbSupervise.catatanBunchesTangkaiPanjang = noteJanjangTangkaiPanjang.text;
    _spbSupervise.spbId = _spbID.text;
    _spbSupervise.supervisiNotes = _notesOPH.text;
    _spbSupervise.updatedBy = _mConfigSchema.employeeName;
    _spbSupervise.updatedDate = TimeManager.dateWithDash(now);
    _spbSupervise.updatedTime = TimeManager.timeWithColon(now);
    int count =
    await DatabaseSPBSupervise().updateSPBSuperviseByID(spbSupervise);
    if (count > 0) {
      _navigationService.push(Routes.HOME_PAGE);
      FlushBarManager.showFlushBarSuccess(
          context, "Simpan Supervisi", "Berhasil menyimpan Supervisi");
    } else {
      FlushBarManager.showFlushBarError(
          context, "Simpan Supervisi", "Gagal menyimpan Supervisi");
    }
  }
}
