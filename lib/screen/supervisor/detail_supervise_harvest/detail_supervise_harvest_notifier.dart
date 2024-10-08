import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/database/service/database_oph_supervise.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/oph_supervise.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetailSuperviseHarvestNotifier extends ChangeNotifier {
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

  TextEditingController _notesOPH = TextEditingController();

  TextEditingController get notesOPH => _notesOPH;

  MEmployeeSchema? _kemandoran;

  MEmployeeSchema? get kemandoran => _kemandoran;

  MEmployeeSchema? _keraniPanen;

  MEmployeeSchema? get keraniPanen => _keraniPanen;

  MEmployeeSchema? _pemanen;

  MEmployeeSchema? get pemanen => _pemanen;

  OPHSupervise? _ophSupervise;

  OPHSupervise? get ophSupervise => _ophSupervise;

  bool _onEdit = false;

  bool get onEdit => _onEdit;

  ImagePicker _picker = ImagePicker();

  ImagePicker get picker => _picker;

  onInit(OPHSupervise ophSupervise) {
    _ophSupervise = ophSupervise;
    _kemandoran = MEmployeeSchema(
        employeeCode: _ophSupervise?.supervisiMandorEmployeeCode,
        employeeName: _ophSupervise?.supervisiMandorEmployeeName);
    _keraniPanen = MEmployeeSchema(
        employeeCode: _ophSupervise?.supervisiKeraniPanenEmployeeCode,
        employeeName: _ophSupervise?.supervisiKeraniPanenEmployeeName);
    _pemanen = MEmployeeSchema(
        employeeName: _ophSupervise?.supervisiPemanenEmployeeName);
    notesOPH.text = _ophSupervise?.supervisiNotes ?? "";
    bunchesRipe.text = _ophSupervise!.bunchesRipe!.toString();
    bunchesOverRipe.text = _ophSupervise!.bunchesOverripe.toString();
    bunchesHalfRipe.text = _ophSupervise!.bunchesHalfripe.toString();
    bunchesUnRipe.text = _ophSupervise!.bunchesUnripe.toString();
    bunchesAbnormal.text = _ophSupervise!.bunchesAbnormal.toString();
    bunchesEmpty.text = _ophSupervise!.bunchesEmpty.toString();
    looseFruits.text = _ophSupervise!.looseFruits.toString();
    bunchesTotal.text = _ophSupervise!.bunchesTotal.toString();
    bunchesNotSent.text = _ophSupervise!.bunchesNotSent.toString();
  }

  onChangeEdit() {
    _onEdit = true;
    notifyListeners();
  }

  onSetKemandoran(MEmployeeSchema mEmployeeSchema) {
    _kemandoran = mEmployeeSchema;
    notifyListeners();
  }

  onSetKeraniPanen(MEmployeeSchema mEmployeeSchema) {
    _keraniPanen = mEmployeeSchema;
    notifyListeners();
  }

  onSetPemanen(MEmployeeSchema mEmployeeSchema) {
    _pemanen = mEmployeeSchema;
    notifyListeners();
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
  }

  onUpdateOPHSupervise(BuildContext context) async {
    DateTime now = DateTime.now();
    _ophSupervise?.updatedDate = TimeManager.dateWithDash(now);
    _ophSupervise?.updatedTime = TimeManager.dateWithDash(now);
    _ophSupervise?.supervisiKeraniPanenEmployeeName =
        _keraniPanen?.employeeName;
    _ophSupervise?.supervisiKeraniPanenEmployeeCode =
        _keraniPanen?.employeeCode;
    _ophSupervise?.supervisiMandorEmployeeName = _kemandoran?.employeeName;
    _ophSupervise?.supervisiMandorEmployeeCode = _kemandoran?.employeeCode;
    _ophSupervise?.supervisiPemanenEmployeeName = _pemanen?.employeeName;
    _ophSupervise?.bunchesRipe = int.parse(_bunchesRipe.text);
    _ophSupervise?.bunchesOverripe = int.parse(bunchesOverRipe.text);
    _ophSupervise?.bunchesHalfripe = int.parse(bunchesHalfRipe.text);
    _ophSupervise?.bunchesUnripe = int.parse(bunchesUnRipe.text);
    _ophSupervise?.bunchesAbnormal = int.parse(bunchesAbnormal.text);
    _ophSupervise?.bunchesEmpty = int.parse(bunchesEmpty.text);
    _ophSupervise?.looseFruits = int.parse(looseFruits.text);
    _ophSupervise?.bunchesTotal = int.parse(bunchesTotal.text);
    _ophSupervise?.bunchesNotSent = int.parse(bunchesNotSent.text);
    int count =
        await DatabaseOPHSupervise().updateOPHSuperviseByID(_ophSupervise!);
    if (count > 0) {
      Navigator.pop(context);
      // FlushBarManager.showFlushBarSuccess(context, "Berhasil tersimpan");
    } else {
      // FlushBarManager.showFlushBarWarning(context, "Gagal tersimpan");
    }
  }

  Future getCamera(BuildContext context) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 20,
      );
      if (pickedFile != null) {
        this.ophSupervise?.supervisiPhoto = pickedFile.path;
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
