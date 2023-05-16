import 'package:epms/base/ui/palette.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/database/service/database_oph_supervise_ancak.dart';
import 'package:epms/model/m_ancak_employee.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/oph_supervise_ancak.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetailSupervisorAncakNotifier extends ChangeNotifier {
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

  ImagePicker _picker = ImagePicker();

  ImagePicker get picker => _picker;

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

  onInit(OPHSuperviseAncak ophSuperviseAncak) {
    this._ophSuperviseAncak = ophSuperviseAncak;
    _ancakEmployee = MAncakEmployee(
        userId: _ophSuperviseAncak?.supervisiAncakAssignToId,
        userName: _ophSuperviseAncak?.supervisiAncakAssignToName);
    _pemanen = MEmployeeSchema(
        employeeCode: _ophSuperviseAncak?.supervisiAncakPemanenEmployeeCode,
        employeeName: _ophSuperviseAncak?.supervisiAncakPemanenEmployeeCode);
    _kemandoran = MEmployeeSchema(
      employeeCode: _ophSuperviseAncak?.supervisiAncakMandorEmployeeCode,
      employeeName: _ophSuperviseAncak?.supervisiAncakMandorEmployeeName
    );
    _pokokPanen.text = _ophSuperviseAncak?.pokokSample ?? "0";
    _totalJanjang.text = _ophSuperviseAncak?.bunchesTotal.toString() ?? "0";
    _totalBrondolan.text = _ophSuperviseAncak?.looseFruits.toString() ??"0";
    _rat.text = _ophSuperviseAncak?.bunchesRat.toString() ?? "0";
    _vCut.text = _ophSuperviseAncak?.bunchesVCut.toString() ?? "0";
    _tangkaiPanjang.text = _ophSuperviseAncak?.bunchesTangkaiPanjang.toString() ?? "0";
    _pelepahSengkleh.text = _ophSuperviseAncak?.pelepahSengkleh.toString() ?? "0";
    _janjangTinggal.text = _ophSuperviseAncak?.bunchesTinggal.toString() ?? "0";
    _brondolanTinggal.text = _ophSuperviseAncak?.bunchesBrondolanTinggal.toString() ?? "0";
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

  Future getCamera(BuildContext context) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 20,
      );
      if (pickedFile != null) {
        this._ophSuperviseAncak?.supervisiAncakPhoto = pickedFile.path;
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  updateToDatabase(BuildContext context) async {
    DateTime now = DateTime.now();
    _ophSuperviseAncak?.supervisiAncakMandorEmployeeCode = _kemandoran?.employeeCode;
    _ophSuperviseAncak?.supervisiAncakMandorEmployeeName = _kemandoran?.employeeName;
    _ophSuperviseAncak?.supervisiAncakPemanenEmployeeCode = _pemanen?.employeeCode;
    _ophSuperviseAncak?.supervisiAncakPemanenEmployeeName = _pemanen?.employeeName;
    _ophSuperviseAncak?.supervisiAncakAssignToId = _ancakEmployee?.userId;
    _ophSuperviseAncak?.supervisiAncakAssignToName = _ancakEmployee?.userName;
    _ophSuperviseAncak?.bunchesVCut = int.parse(_vCut.text);
    _ophSuperviseAncak?.bunchesRat = int.parse(_rat.text);
    _ophSuperviseAncak?.bunchesTangkaiPanjang = int.parse(_tangkaiPanjang.text);
    _ophSuperviseAncak?.pelepahSengkleh = int.parse(_pelepahSengkleh.text);
    _ophSuperviseAncak?.bunchesTinggal = int.parse(_janjangTinggal.text);
    _ophSuperviseAncak?.bunchesTinggalPercentage = (((int.parse(_janjangTinggal.text))/(int.parse(_totalJanjang.text)))*100).toDouble();
    _ophSuperviseAncak?.bunchesBrondolanTinggal = int.parse(_brondolanTinggal.text);
    _ophSuperviseAncak?.bunchesBrondolanTinggalPercentage = (((int.parse(_brondolanTinggal.text))/(int.parse(_totalJanjang.text)))*100).toDouble();
    _ophSuperviseAncak?.bunchesTotal = int.parse(_totalJanjang.text);
    _ophSuperviseAncak?.looseFruits = int.parse(_brondolanTinggal.text);
    _ophSuperviseAncak?.supervisiAncakNotes = _notes.text;
    _ophSuperviseAncak?.updatedDate = TimeManager.dateWithDash(now);
    _ophSuperviseAncak?.createdTime = TimeManager.timeWithColon(now);
    int count = await DatabaseOPHSuperviseAncak().updateOPHSuperviseAncakByID(_ophSuperviseAncak!);
    if (count > 0) {
      Navigator.pop(context);
      Navigator.pop(context);
      // FlushBarManager.showFlushBarSuccess(context, "Berhasil tersimpan");
    } else {
      // FlushBarManager.showFlushBarWarning(context, "Gagal tersimpan");
      Navigator.pop(context);
    }
  }

  countBunches(
      BuildContext context, TextEditingController textEditingController) {
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
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            title: Center(
                child: Text(
                  "Apakah anda yakin ingin menyimpan?",
                  textAlign: TextAlign.center,
                )),
            actions: <Widget>[
              OutlinedButton(
                  child: new Text(
                    "Ya",
                    style: TextStyle(
                        color: Palette.primaryColorProd,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    updateToDatabase(context);
                  }),
              OutlinedButton(
                  child: new Text(
                    "Tidak",
                    style: TextStyle(
                        color: Palette.redColorLight,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  void onChangeEdit() {
    _onEdit = true;
    notifyListeners();
  }

}
