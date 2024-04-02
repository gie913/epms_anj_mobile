import 'package:epms/base/common/locator.dart';
import 'package:epms/common_manager/camera_service.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/location_service.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/oph_card_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/common_manager/validation_service.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_m_employee.dart';
import 'package:epms/database/service/database_oph_supervise.dart';
import 'package:epms/model/m_block_schema.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/m_tph_schema.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/oph_supervise.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nfc_manager/nfc_manager.dart';

class SupervisorHarvestFormNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  bool _activeText = false;

  bool get activeText => _activeText;

  String _harvestingID = "";

  String get harvestingID => _harvestingID;

  String _date = "";

  String get date => _date;

  String _time = "";

  String get time => _time;

  String _gpsLocation = "";

  String get gpsLocation => _gpsLocation;

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

  MConfigSchema? _mConfigSchema;

  MConfigSchema? get mConfigSchema => _mConfigSchema;

  Position? _position;

  Position? get position => _position;

  MEmployeeSchema? _kemandoran;

  MEmployeeSchema? get kemandoran => _kemandoran;

  MEmployeeSchema? _keraniPanen;

  MEmployeeSchema? get keraniPanen => _keraniPanen;

  MEmployeeSchema? _pemanen;

  MEmployeeSchema? get pemanen => _pemanen;

  MTPHSchema? _mtphSchema;

  MTPHSchema? get mtphSchema => _mtphSchema;

  MBlockSchema? _mBlockSchema;

  MBlockSchema? get mBlockSchema => _mBlockSchema;

  TextEditingController blockCode = TextEditingController();

  TextEditingController tphCode = TextEditingController();

  TextEditingController ophID = TextEditingController();

  String? _pickedFile;

  String? get pickedFile => _pickedFile;

  List<MEmployeeSchema> _listEmployee = [];

  List<MEmployeeSchema> get listEmployee => _listEmployee;

  getLocation() async {
    _position = await LocationService.getGPSLocation();
    if (_position != null) {
      _gpsLocation = "${_position?.longitude}, ${_position?.latitude}";
    } else {
      _gpsLocation = "";
    }
    notifyListeners();
  }

  onSetActiveText(bool value) {
    _activeText = value;
    notifyListeners();
  }

  generateVariable() async {
    _mConfigSchema = await DatabaseMConfig().selectMConfig();
    _listEmployee = await DatabaseMEmployeeSchema().selectMEmployeeSchema();
    DateTime now = DateTime.now();
    NumberFormat formatterNumber = new NumberFormat("000");
    String number = formatterNumber.format(mConfigSchema?.userId);
    _date = TimeManager.dateWithDash(now);
    _time = TimeManager.timeWithColon(now);
    _harvestingID = "${mConfigSchema?.estateCode}" +
        ValueService.generateIDFromDateTime(now) +
        "$number" "SM";
    bunchesRipe.text = "0";
    bunchesOverRipe.text = "0";
    bunchesHalfRipe.text = "0";
    bunchesUnRipe.text = "0";
    bunchesAbnormal.text = "0";
    bunchesEmpty.text = "0";
    looseFruits.text = "0";
    bunchesTotal.text = "0";
    bunchesNotSent.text = "0";
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

  void tPHNumberCheck(BuildContext context, String tphCodeOph) async {
    if (tphCodeOph.isNotEmpty) {
      _mtphSchema = await ValidationService.checkMTPHSchema(
          tphCodeOph, _mConfigSchema!.estateCode!, blockCode.text);
      _mtphSchema ??
          FlushBarManager.showFlushBarWarning(
              context, "Kode TPH", "Tidak sesuai");
      tphCode.text = _mtphSchema!.tphCode!;
      notifyListeners();
    }
  }

  void blockNumberCheck(BuildContext context, String block) async {
    if (block.isNotEmpty) {
      block.toUpperCase();
      _mBlockSchema = await ValidationService.checkBlockSchema(
          block, _mConfigSchema!.estateCode!);
      _mBlockSchema ??
          FlushBarManager.showFlushBarWarning(
              context, "Kode Blok", "Tidak sesuai");
      blockCode.text = _mBlockSchema!.blockCode!;
      blockCode.selection = TextSelection.fromPosition(
          TextPosition(offset: blockCode.text.length));
      notifyListeners();
    }
  }

  getCamera(BuildContext context) async {
    String? picked = await CameraService.getImageByCamera(context);
    if (picked != null) {
      _pickedFile = picked;
      notifyListeners();
    }
  }

  countBunches(
      BuildContext context, TextEditingController textEditingController) {
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

  saveToDatabase() async {
    OPHSupervise ophSupervise = OPHSupervise();
    ophSupervise.ophSupervisiId = _harvestingID;
    ophSupervise.createdDate = _date;
    ophSupervise.createdTime = _time;
    if (_position != null) {
      ophSupervise.supervisiLat = _position?.latitude.toString();
      ophSupervise.supervisiLong = _position?.longitude.toString();
    }
    ophSupervise.supervisiEstateCode = _mConfigSchema?.estateCode;
    ophSupervise.supervisiBlockCode = blockCode.text;
    ophSupervise.supervisiTphCode = tphCode.text;
    ophSupervise.ophId = ophID.text;
    ophSupervise.supervisiEmployeeCode = _mConfigSchema?.employeeCode;
    ophSupervise.supervisiEmployeeName = _mConfigSchema?.employeeName;
    ophSupervise.supervisiMandorEmployeeCode = _kemandoran?.employeeCode;
    ophSupervise.supervisiMandorEmployeeName = _kemandoran?.employeeName;
    ophSupervise.supervisiKeraniPanenEmployeeCode = _keraniPanen?.employeeCode;
    ophSupervise.supervisiKeraniPanenEmployeeName = _keraniPanen?.employeeName;
    ophSupervise.supervisiPemanenEmployeeName = _pemanen?.employeeName;
    ophSupervise.supervisiPemanenEmployeeCode = _pemanen?.employeeCode;
    ophSupervise.supervisiPhoto = _pickedFile;
    ophSupervise.supervisiDivisionCode = _mBlockSchema?.blockDivisionCode;
    ophSupervise.bunchesRipe = int.parse(_bunchesRipe.text);
    ophSupervise.bunchesOverripe = int.parse(_bunchesOverRipe.text);
    ophSupervise.bunchesHalfripe = int.parse(_bunchesHalfRipe.text);
    ophSupervise.bunchesUnripe = int.parse(_bunchesUnRipe.text);
    ophSupervise.bunchesAbnormal = int.parse(_bunchesAbnormal.text);
    ophSupervise.bunchesEmpty = int.parse(_bunchesEmpty.text);
    ophSupervise.looseFruits = int.parse(_looseFruits.text);
    ophSupervise.bunchesTotal = int.parse(bunchesTotal.text);
    ophSupervise.bunchesNotSent = int.parse(_bunchesNotSent.text);
    ophSupervise.supervisiNotes = _notesOPH.text;
    ophSupervise.createdBy = _mConfigSchema?.employeeCode;
    ophSupervise.supervisiDate = _date;
    int count = await DatabaseOPHSupervise().insertOPHSupervise(ophSupervise);
    if (count > 0) {
      _dialogService.popDialog();
      _navigationService.pop();
      FlushBarManager.showFlushBarSuccess(
          _navigationService.navigatorKey.currentContext!,
          "Supervisi Panen",
          "Berhasil tersimpan");
    } else {
      _dialogService.popDialog();
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Supervisi Panen",
          "Gagal tersimpan");
    }
  }

  onCheckFormGenerator(BuildContext context) {
    blockNumberCheck(context, blockCode.text);
    tPHNumberCheck(context, tphCode.text);
    if (_kemandoran != null) {
      if (_keraniPanen != null) {
        if (_pemanen != null) {
          if (tphCode.text.isNotEmpty) {
            if (_mtphSchema != null) {
              if (blockCode.text.isNotEmpty) {
                if (_mBlockSchema != null) {
                  if (_pickedFile != null) {
                    if (_bunchesTotal.text != "0") {
                      if (!(int.parse(_bunchesNotSent.text) >
                          int.parse(_bunchesTotal.text))) {
                        showDialogQuestion(context);
                      } else {
                        FlushBarManager.showFlushBarWarning(
                            context,
                            "Janjang Grading",
                            "Jumlah janjang tidak dikirim lebih dari Jumlah janjang");
                      }
                    } else {
                      FlushBarManager.showFlushBarWarning(context,
                          "Janjang Grading", "Anda belum melakukan Grading");
                    }
                  } else {
                    FlushBarManager.showFlushBarWarning(context,
                        "Foto Supervisi", "Anda belum memasukkan Foto");
                  }
                } else {
                  FlushBarManager.showFlushBarWarning(
                      context, "Kode Blok", "Kode Blok tidak sesuai");
                }
              } else {
                FlushBarManager.showFlushBarWarning(
                    context, "Kode Blok", "Anda belum memasukkan kode Blok");
              }
            } else {
              FlushBarManager.showFlushBarWarning(
                  context, "Kode TPH", "Kode TPH tidak sesuai");
            }
          } else {
            FlushBarManager.showFlushBarWarning(
                context, "Kode TPH", "Anda belum memasukkan kode TPH");
          }
        } else {
          FlushBarManager.showFlushBarWarning(
              context, "Pemanen", "Anda belum memasukkan pemanen");
        }
      } else {
        FlushBarManager.showFlushBarWarning(
            context, "Kerani Panen", "Anda belum memasukkan kerani panen");
      }
    } else {
      FlushBarManager.showFlushBarWarning(
          context, "Kemandoran", "Anda belum memasukkan kemandoran");
    }
  }

  onSuccessRead(BuildContext context, OPH oph) {
    checkOPHExist(context, oph);
  }

  checkOPHExist(BuildContext context, OPH oph) async {
    List ophList =
        await DatabaseOPHSupervise().selectOPHSuperviseByID(oph.ophId!);
    if (ophList.isEmpty) {
      ophID.text = oph.ophId!;
      blockNumberCheck(context, oph.ophBlockCode!);
      tPHNumberCheck(context, oph.ophTphCode!);
      setEmployee(oph);
      _dialogService.popDialog();
    } else {
      _dialogService.popDialog();
      FlushBarManager.showFlushBarWarning(
          _navigationService.navigatorKey.currentContext!,
          "Scan OPH",
          "OPH ini sudah pernah discan");
    }
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
  }

  setEmployee(OPH oph) {
    _pemanen = _listEmployee
        .where((element) => element.employeeCode == oph.employeeCode)
        .last;
    _kemandoran = _listEmployee
        .where((element) => element.employeeCode == oph.mandorEmployeeCode)
        .last;
  }

  onErrorRead(BuildContext context, String message) {
    Future.delayed(Duration(seconds: 1), () {
      NfcManager.instance.stopSession();
    });
    FlushBarManager.showFlushBarWarning(context, "Gagal Membaca", message);
  }

  dialogNFC(BuildContext context) {
    OPHCardManager().readOPHCard(context, onSuccessRead, onErrorRead);
    _dialogService.showNFCDialog(
        title: "Tempel Kartu NFC",
        subtitle: "Untuk membaca data",
        buttonText: "Batal",
        onPress: onPressCancelRead);
  }

  onPressCancelRead() {
    _dialogService.popDialog();
    NfcManager.instance.stopSession();
  }

  showDialogQuestion(BuildContext context) {
    _dialogService.showOptionDialog(
        title: "Simpan Supervisi Panen",
        subtitle: "Anda yakin ingin menyimpan",
        buttonTextYes: "Ya",
        buttonTextNo: "Tidak",
        onPressYes: saveToDatabase,
        onPressNo: _dialogService.popDialog);
  }
}
