import 'package:epms/base/common/locator.dart';
import 'package:epms/common_manager/camera_service.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/location_service.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/common_manager/validation_service.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_oph_supervise_ancak.dart';
import 'package:epms/model/m_ancak_employee.dart';
import 'package:epms/model/m_block_schema.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/m_tph_schema.dart';
import 'package:epms/model/oph_supervise_ancak.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SupervisorAncakFormNotifier extends ChangeNotifier {
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

  String _gpsLocationUpdate = "";

  String get gpsLocationUpdate => _gpsLocationUpdate;

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

  MConfigSchema? _mConfigSchema;

  MConfigSchema? get mConfigSchema => _mConfigSchema;

  Position? _position;

  Position? get position => _position;

  Position? _positionUpdate;

  Position? get positionUpdate => _positionUpdate;

  MEmployeeSchema? _kemandoran;

  MEmployeeSchema? get kemandoran => _kemandoran;

  MAncakEmployee? _ancakEmployee;

  MAncakEmployee? get ancakEmployee => _ancakEmployee;

  MEmployeeSchema? _pemanen;

  MEmployeeSchema? get pemanen => _pemanen;

  MTPHSchema? _mtphSchema;

  MTPHSchema? get mtphSchema => _mtphSchema;

  MBlockSchema? _mBlockSchema;

  MBlockSchema? get mBlockSchema => _mBlockSchema;

  TextEditingController blockCode = TextEditingController();

  ImagePicker _picker = ImagePicker();

  ImagePicker get picker => _picker;

  String? _pickedFile;

  String? get pickedFile => _pickedFile;

  getLocation() async {
    _position = await LocationService.getGPSLocation();
    if (_position != null) {
      _gpsLocation = "${_position?.longitude}, ${_position?.latitude}";
    } else {
      _gpsLocation = "";
    }
    notifyListeners();
  }

  getLocationUpdate() async {
    _positionUpdate = await LocationService.getGPSLocation();
    if (_positionUpdate != null) {
      _gpsLocationUpdate =
          "${_positionUpdate?.longitude}, ${_positionUpdate?.latitude}";
    } else {
      _gpsLocationUpdate = "";
    }
    notifyListeners();
  }

  onSetActiveText(bool value) {
    _activeText = value;
    notifyListeners();
  }

  generateVariable() async {
    _mConfigSchema = await DatabaseMConfig().selectMConfig();
    DateTime now = DateTime.now();
    NumberFormat formatterNumber = new NumberFormat("000");
    String number = formatterNumber.format(mConfigSchema?.userId);
    _date = TimeManager.dateWithDash(now);
    _time = TimeManager.timeWithColon(now);
    _harvestingID = "${mConfigSchema?.estateCode}" +
        ValueService.generateIDFromDateTime(now) +
        "$number" "SM";
    _pokokPanen.text = "0";
    _totalJanjang.text = "0";
    _totalBrondolan.text = "0";
    _rat.text = "0";
    _vCut.text = "0";
    _tangkaiPanjang.text = "0";
    _pelepahSengkleh.text = "0";
    _janjangTinggal.text = "0";
    _brondolanTinggal.text = "0";
    notifyListeners();
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

  void blockNumberCheck(BuildContext context, String block) async {
    if (block.isNotEmpty) {
      block.toUpperCase();
      _mBlockSchema = await ValidationService.checkBlockSchema(block, _mConfigSchema!.estateCode!);
      _mBlockSchema ??
          FlushBarManager.showFlushBarWarning(
              context, "Kode Blok", "Tidak sesuai");
      blockCode.text = _mBlockSchema!.blockCode!;
      notifyListeners();
    }
  }

  getCamera(BuildContext context) async {
    String? picked = await CameraService.getImageByCamera();
    if (picked != null) {
      _pickedFile = picked;
      notifyListeners();
    }
  }

  onCheckFormGenerator(BuildContext context) {
    blockNumberCheck(context, blockCode.text);
    if (_kemandoran != null) {
      if (_pemanen != null) {
        if (_ancakEmployee != null) {
          if (blockCode.text.isNotEmpty) {
            if (_mBlockSchema != null) {
              if (_pickedFile != null) {
                if (_positionUpdate != null) {
                  showDialogQuestion(context);
                } else {
                  FlushBarManager.showFlushBarWarning(
                      context, "Update Lokasi", "Anda belum mengupdate lokasi");
                }
              } else {
                FlushBarManager.showFlushBarWarning(
                    context, "Foto", "Anda belum memasukkan Foto");
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
              context, "Assign To", "Anda belum menugaskan ancak");
        }
      } else {
        FlushBarManager.showFlushBarWarning(
            context, "Pemanen", "Anda belum memasukkan pemanen");
      }
    } else {
      FlushBarManager.showFlushBarWarning(
          context, "Kemandoran", "Anda belum memasukkan kemandoran");
    }
  }

  saveToDatabase() async {
    OPHSuperviseAncak ophSuperviseAncak = OPHSuperviseAncak();

    ophSuperviseAncak.supervisiAncakId = _harvestingID;
    ophSuperviseAncak.supervisiAncakEstateCode = _mConfigSchema?.estateCode;
    ophSuperviseAncak.supervisiAncakBlockCode = blockCode.text;
    if (_position != null) {
      ophSuperviseAncak.supervisiAncakLat = _position?.latitude.toString();
      ophSuperviseAncak.supervisiAncakLon = _position?.longitude.toString();
    }
    if (_positionUpdate != null) {
      ophSuperviseAncak.supervisiAncakLatEnd =
          _positionUpdate?.latitude.toString();
      ophSuperviseAncak.supervisiAncakLongEnd =
          _positionUpdate?.longitude.toString();
    }
    ophSuperviseAncak.supervisiAncakMandorEmployeeCode =
        _kemandoran?.employeeCode;
    ophSuperviseAncak.supervisiAncakMandorEmployeeName =
        _kemandoran?.employeeName;
    ophSuperviseAncak.supervisiAncakPemanenEmployeeCode =
        _pemanen?.employeeCode;
    ophSuperviseAncak.supervisiAncakPemanenEmployeeName =
        _pemanen?.employeeName;
    ophSuperviseAncak.supervisiAncakAssignToId = _ancakEmployee?.userId;
    ophSuperviseAncak.supervisiAncakAssignToName = _ancakEmployee?.userName;
    ophSuperviseAncak.supervisiAncakPhoto = _pickedFile;
    ophSuperviseAncak.supervisiAncakDivisionCode =
        _mBlockSchema?.blockDivisionCode;
    ophSuperviseAncak.pokokSample = _pokokPanen.text;
    ophSuperviseAncak.bunchesVCut = int.parse(_vCut.text);
    ophSuperviseAncak.bunchesRat = int.parse(_rat.text);
    ophSuperviseAncak.bunchesTangkaiPanjang = int.parse(_tangkaiPanjang.text);
    ophSuperviseAncak.pelepahSengkleh = int.parse(_pelepahSengkleh.text);
    ophSuperviseAncak.bunchesTinggal = int.parse(_janjangTinggal.text);
    ophSuperviseAncak.bunchesTinggalPercentage =
        (((int.parse(_janjangTinggal.text)) / (int.parse(_totalJanjang.text))) *
                100)
            .toDouble();
    ophSuperviseAncak.bunchesBrondolanTinggal =
        int.parse(_brondolanTinggal.text);
    ophSuperviseAncak.bunchesBrondolanTinggalPercentage =
        (((int.parse(_brondolanTinggal.text)) /
                    (int.parse(_totalJanjang.text))) *
                100)
            .toDouble();
    ophSuperviseAncak.bunchesTotal = int.parse(_totalJanjang.text);
    ophSuperviseAncak.looseFruits = int.parse(_brondolanTinggal.text);
    ophSuperviseAncak.supervisiAncakNotes = _notes.text;
    ophSuperviseAncak.createdBy = _mConfigSchema?.employeeName;
    ophSuperviseAncak.supervisiAncakEmployeeCode = _mConfigSchema?.employeeCode;
    ophSuperviseAncak.supervisiAncakEmployeeName = _mConfigSchema?.employeeName;
    ophSuperviseAncak.supervisiAncakDate = _date;
    ophSuperviseAncak.createdDate = _date;
    ophSuperviseAncak.createdTime = _time;
    int count = await DatabaseOPHSuperviseAncak()
        .insertOPHSuperviseAncak(ophSuperviseAncak);
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
