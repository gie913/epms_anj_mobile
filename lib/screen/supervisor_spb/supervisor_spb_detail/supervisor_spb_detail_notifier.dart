import 'package:epms/base/ui/palette.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_spb_supervise.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/spb_supervise.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SupervisorSPBDetailNotifier extends ChangeNotifier {

  SPBSupervise _spbSupervise = SPBSupervise();

  SPBSupervise get spbSupervise => _spbSupervise;

  ImagePicker _picker = ImagePicker();

  ImagePicker get picker => _picker;

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

  TextEditingController get noteJanjangTangkaiPanjang => _noteJanjangTangkaiPanjang;

  TextEditingController _sampah = TextEditingController();

  TextEditingController get sampah => _sampah;

  TextEditingController _batu = TextEditingController();

  TextEditingController get batu => _batu;

  bool _onEdit = false;

  bool get onEdit => _onEdit;

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
    _janjangTangkaiPanjang.text = spbSupervise.bunchesTotal.toString();
    _sampah.text = spbSupervise.bunchesSampah.toString();
    _batu.text = spbSupervise.bunchesBatu.toString();
    notifyListeners();
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


  Future getCamera(BuildContext context) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 20,
      );
      if (pickedFile != null) {
        this._spbSupervise.supervisiSpbPhoto = pickedFile.path;
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void updateToDatabase(BuildContext context) async {
    DateTime now = DateTime.now();
    _spbSupervise.bunchesRipe = int.parse(_bunchesRipe.text);
    _spbSupervise.bunchesOverripe = int.parse(_bunchesOverRipe.text);
    _spbSupervise.bunchesHalfripe = int.parse(_bunchesHalfRipe.text);
    _spbSupervise.bunchesUnripe =  int.parse(_bunchesUnRipe.text);
    _spbSupervise.bunchesAbnormal = int.parse(_bunchesAbnormal.text);
    _spbSupervise.bunchesEmpty = int.parse(_bunchesEmpty.text);
    _spbSupervise.looseFruits = int.parse(_looseFruits.text);
    _spbSupervise.bunchesTotal = int.parse(_bunchesTotal.text);
    _spbSupervise.bunchesTotalNormal = int.parse(_bunchesNormalTotal.text);
    _spbSupervise.bunchesSampah = int.parse(_sampah.text);
    _spbSupervise.bunchesBatu = int.parse(_batu.text);
    _spbSupervise.catatanBunchesTangkaiPanjang = noteJanjangTangkaiPanjang.text;
    _spbSupervise.supervisiNotes = _notesOPH.text;
    _spbSupervise.updatedBy = _mConfigSchema.employeeName;
    _spbSupervise.updatedDate = TimeManager.dateWithDash(now);
    _spbSupervise.updatedTime = TimeManager.timeWithColon(now);
    int count = await DatabaseSPBSupervise().updateSPBSuperviseByID(spbSupervise);
    if(count > 0) {
      Navigator.pop(context);
      Navigator.pop(context);
      // FlushBarManager.showFlushBarSuccess(context, "Berhasil tersimpan");
    } else {
      // FlushBarManager.showFlushBarWarning(context, "Gagal tersimpan");
    }
  }

}