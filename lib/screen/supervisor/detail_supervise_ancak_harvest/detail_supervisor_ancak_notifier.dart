import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/camera_service.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/database/service/database_oph_supervise_ancak.dart';
import 'package:epms/model/m_ancak_employee.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/oph_supervise_ancak.dart';
import 'package:flutter/material.dart';

class DetailSupervisorAncakNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  OPHSuperviseAncak? _ophSuperviseAncak;

  OPHSuperviseAncak? get ophSuperviseAncak => _ophSuperviseAncak;

  bool _onEdit = false;

  bool get onEdit => _onEdit;

  MEmployeeSchema? _kemandoran;

  MEmployeeSchema? get kemandoran => _kemandoran;

  MAncakEmployee? _ancakEmployee;

  MAncakEmployee? get ancakEmployee => _ancakEmployee;

  MEmployeeSchema? _pemanen;

  MEmployeeSchema? get pemanen => _pemanen;

  TextEditingController _pokokPanen = TextEditingController();

  TextEditingController get pokokPanen => _pokokPanen;

  TextEditingController _totalJanjang = TextEditingController();

  TextEditingController get totalJanjang => _totalJanjang;

  TextEditingController _totalBrondolan = TextEditingController();

  TextEditingController get totalBrondolan => _totalBrondolan;

  TextEditingController _rat = TextEditingController();

  TextEditingController get rat => _rat;

  TextEditingController _vCut = TextEditingController();

  TextEditingController get vCut => _vCut;

  TextEditingController _tangkaiPanjang = TextEditingController();

  TextEditingController get tangkaiPanjang => _tangkaiPanjang;

  TextEditingController _pelepahSengkleh = TextEditingController();

  TextEditingController get pelepahSengkleh => _pelepahSengkleh;

  TextEditingController _janjangTinggal = TextEditingController();

  TextEditingController get janjangTinggal => _janjangTinggal;

  TextEditingController _brondolanTinggal = TextEditingController();

  TextEditingController get brondolanTinggal => _brondolanTinggal;

  TextEditingController _notes = TextEditingController();

  TextEditingController get notes => _notes;

  double _loosesBuahTinggal = 0.0;

  double get loosesBuahTinggal => _loosesBuahTinggal;

  double _loosesBrondolan = 0.0;

  double get loosesBrondolan => _loosesBrondolan;

  onInit(OPHSuperviseAncak ophSuperviseAncak) {
    this._ophSuperviseAncak = ophSuperviseAncak;
    _ancakEmployee = MAncakEmployee(
        userId: _ophSuperviseAncak?.supervisiAncakAssignToId,
        userName: _ophSuperviseAncak?.supervisiAncakAssignToName);
    _pemanen = MEmployeeSchema(
        employeeCode: _ophSuperviseAncak?.supervisiAncakPemanenEmployeeCode,
        employeeName: _ophSuperviseAncak?.supervisiAncakPemanenEmployeeName);
    _kemandoran = MEmployeeSchema(
        employeeCode: _ophSuperviseAncak?.supervisiAncakMandorEmployeeCode,
        employeeName: _ophSuperviseAncak?.supervisiAncakMandorEmployeeName
    );
    _pokokPanen.text = _ophSuperviseAncak?.pokokSample ?? "0";
    _totalJanjang.text = _ophSuperviseAncak?.bunchesTotal.toString() ?? "0";
    _totalBrondolan.text = _ophSuperviseAncak?.looseFruits.toString() ?? "0";
    _rat.text = _ophSuperviseAncak?.bunchesRat.toString() ?? "0";
    _vCut.text = _ophSuperviseAncak?.bunchesVCut.toString() ?? "0";
    _tangkaiPanjang.text =
        _ophSuperviseAncak?.bunchesTangkaiPanjang.toString() ?? "0";
    _pelepahSengkleh.text =
        _ophSuperviseAncak?.pelepahSengkleh.toString() ?? "0";
    _janjangTinggal.text = _ophSuperviseAncak?.bunchesTinggal.toString() ?? "0";
    _brondolanTinggal.text =
        _ophSuperviseAncak?.bunchesBrondolanTinggal.toString() ?? "0";
    _notes.text = _ophSuperviseAncak?.supervisiAncakNotes.toString() ?? "";
  }

  onSetKemandoran(MEmployeeSchema mEmployeeSchema) {
    _kemandoran = mEmployeeSchema;
    notifyListeners();
  }

  onSetAncakEmployee(MAncakEmployee mAncakEmployee) {
    _ancakEmployee = mAncakEmployee;
    notifyListeners();
  }

  onSetPemanen(MEmployeeSchema mEmployeeSchema) {
    _pemanen = mEmployeeSchema;
    notifyListeners();
  }

  getCamera(BuildContext context) async {
    String? picked = await CameraService.getImageByCamera(context);
    if (picked != null) {
      this._ophSuperviseAncak?.supervisiAncakPhoto = picked;
      notifyListeners();
    }
  }

  updateToDatabase() async {
    _dialogService.popDialog();
    DateTime now = DateTime.now();
    _ophSuperviseAncak?.supervisiAncakMandorEmployeeCode =
        _kemandoran?.employeeCode;
    _ophSuperviseAncak?.supervisiAncakMandorEmployeeName =
        _kemandoran?.employeeName;
    _ophSuperviseAncak?.supervisiAncakPemanenEmployeeCode =
        _pemanen?.employeeCode;
    _ophSuperviseAncak?.supervisiAncakPemanenEmployeeName =
        _pemanen?.employeeName;
    _ophSuperviseAncak?.supervisiAncakAssignToId = _ancakEmployee?.userId;
    _ophSuperviseAncak?.supervisiAncakAssignToName = _ancakEmployee?.userName;
    _ophSuperviseAncak?.bunchesVCut = int.parse(_vCut.text);
    _ophSuperviseAncak?.bunchesRat = int.parse(_rat.text);
    _ophSuperviseAncak?.bunchesTangkaiPanjang = int.parse(_tangkaiPanjang.text);
    _ophSuperviseAncak?.pelepahSengkleh = int.parse(_pelepahSengkleh.text);
    _ophSuperviseAncak?.bunchesTinggal = int.parse(_janjangTinggal.text);
    _ophSuperviseAncak?.bunchesBrondolanTinggal =
        int.parse(_brondolanTinggal.text);
    _ophSuperviseAncak?.bunchesTotal = int.parse(_totalJanjang.text);
    _ophSuperviseAncak?.looseFruits = int.parse(_totalBrondolan.text);
    _ophSuperviseAncak?.supervisiAncakNotes = _notes.text;
    _ophSuperviseAncak?.updatedDate = TimeManager.dateWithDash(now);
    _ophSuperviseAncak?.createdTime = TimeManager.timeWithColon(now);
    int count = await DatabaseOPHSuperviseAncak().updateOPHSuperviseAncakByID(
        _ophSuperviseAncak!);
    if (count > 0) {
      _navigationService.push(Routes.HOME_PAGE);
      FlushBarManager.showFlushBarSuccess(
          _navigationService.navigatorKey.currentContext!,
          "Simpan Supervisi Ancak", "Berhasil menyimpan");
    } else {
      FlushBarManager.showFlushBarError(
          _navigationService.navigatorKey.currentContext!,
          "Simpan Supervisi Ancak", "Gagal menyimpan");
    }
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
  }

  showDialogQuestion(BuildContext context) {
    _dialogService.showOptionDialog(title: "Simpan Supervisi Ancak",
        subtitle: "Anda yakin ingin menyimpan?",
        buttonTextYes: "Iya",
        buttonTextNo: "Tidak",
        onPressYes: updateToDatabase,
        onPressNo: _dialogService.popDialog);
  }

  void onChangeEdit() {
    _onEdit = true;
    notifyListeners();
  }

  countLoosesBuahTinggal(String janjangTinggal, String pokokPanen) {
    if(janjangTinggal.isNotEmpty && pokokPanen.isNotEmpty) {
      _ophSuperviseAncak?.bunchesTinggalPercentage = double.parse(janjangTinggal) / double.parse(pokokPanen);
    }
    notifyListeners();
  }

  countLoosesBrondolan(String brondolanTinggal, String pokokPanen) {
    if(brondolanTinggal.isNotEmpty && pokokPanen.isNotEmpty) {
      _ophSuperviseAncak?.bunchesBrondolanTinggalPercentage = double.parse(brondolanTinggal) / double.parse(pokokPanen);
    }
    notifyListeners();
  }

}
