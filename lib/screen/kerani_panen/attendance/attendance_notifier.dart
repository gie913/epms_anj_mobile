import 'package:epms/base/common/locator.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/database/service/database_attendance.dart';
import 'package:epms/database/service/database_m_attendance.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_t_user_assignment.dart';
import 'package:epms/model/m_attendance_schema.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/t_attendance_schema.dart';
import 'package:epms/model/t_user_assignment_schema.dart';
import 'package:flutter/material.dart';

class AttendanceNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  MConfigSchema _configSchema = MConfigSchema();

  MConfigSchema get configSchema => _configSchema;

  List<TAttendanceSchema> _tAttendanceList = [];

  List<TAttendanceSchema> get tAttendanceList => _tAttendanceList;

  List<MAttendanceSchema> _mAttendanceSchema = [];

  List<MAttendanceSchema> get mAttendanceSchema => _mAttendanceSchema;

  List<MAttendanceSchema> _listAttendanceValue = [];

  List<MAttendanceSchema> get listAttendanceValue => _listAttendanceValue;

  TUserAssignmentSchema _tUserAssignmentSchema = TUserAssignmentSchema();

  TUserAssignmentSchema get tUserAssignmentSchema => _tUserAssignmentSchema;

  getMAttendanceSchema() async {
    _mAttendanceSchema = await DatabaseMAttendance().selectEmployeeAttendance();
    notifyListeners();
  }

  getAttendanceList() async {
    _tAttendanceList = await DatabaseAttendance().selectEmployeeAttendance();
    for (int i = 0; i < _tAttendanceList.length; i++) {
      MAttendanceSchema mAttendanceSchema = MAttendanceSchema();
      mAttendanceSchema.attendanceId = _tAttendanceList[i].attendanceId;
      mAttendanceSchema.attendanceDesc = _tAttendanceList[i].attendanceDesc;
      mAttendanceSchema.attendanceCode = _tAttendanceList[i].attendanceCode;
      _listAttendanceValue.add(mAttendanceSchema);
    }
    notifyListeners();
  }

  onChangeAttendance(MAttendanceSchema mAttendanceSchema, int index) {
    DateTime now = DateTime.now();
    _tAttendanceList[index].attendanceId = mAttendanceSchema.attendanceId;
    _tAttendanceList[index].attendanceCode = mAttendanceSchema.attendanceCode;
    _tAttendanceList[index].attendanceDesc = mAttendanceSchema.attendanceDesc;
    _tAttendanceList[index].updatedDate = TimeManager.dateWithDash(now);
    _tAttendanceList[index].updatedTime = TimeManager.timeWithColon(now);
    _listAttendanceValue[index] = mAttendanceSchema;
    notifyListeners();
  }

  onSaveAttendance() async {
    _dialogService.popDialog();
    _dialogService.showLoadingDialog(title: "Menyimpan Absensi");
    try {
      for (int i = 0; i < _tAttendanceList.length; i++) {
        await DatabaseAttendance()
            .updateDatabaseAttendance(_tAttendanceList[i]);
      }
      _dialogService.popDialog();
      _navigationService.pop();
      FlushBarManager.showFlushBarSuccess(
          _navigationService.navigatorKey.currentContext!,
          "Absensi",
          "Berhasil disimpan");
    } catch (e) {
      _dialogService.popDialog();
      _dialogService.showNoOptionDialog(
          title: "Absensi",
          subtitle: "Gagal menyimpan",
          onPress: _dialogService.popDialog);
    }
  }

  onClickSave() {
    _dialogService.showOptionDialog(
        title: "Absensi",
        subtitle: "Anda yakin ingin menyimpan absensi?",
        buttonTextYes: "Ya",
        buttonTextNo: "Tidak",
        onPressYes: onSaveAttendance,
        onPressNo: _dialogService.popDialog);
  }

  getMandorEmployee() async {
    MConfigSchema? mConfigSchema = await DatabaseMConfig().selectMConfig();
    List<TUserAssignmentSchema> list = await DatabaseTUserAssignment()
        .selectEmployeeTUserAssignment(mConfigSchema);
    if (list.isNotEmpty) {
      _tUserAssignmentSchema = list[0];
    }
    notifyListeners();
  }
}
