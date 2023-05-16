// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class MAttendanceSchema extends Equatable {
  dynamic attendanceId;
  String? attendanceCode;
  String? attendanceDesc;

  MAttendanceSchema(
      {this.attendanceId, this.attendanceCode, this.attendanceDesc});

  MAttendanceSchema.fromJson(Map<String, dynamic> json) {
    attendanceId = json['attendance_id'];
    attendanceCode = json['attendance_code'];
    attendanceDesc = json['attendance_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attendance_id'] = this.attendanceId;
    data['attendance_code'] = this.attendanceCode;
    data['attendance_desc'] = this.attendanceDesc;
    return data;
  }

  @override
  List<Object> get props => [attendanceCode!, attendanceDesc!];

  @override
  bool get stringify => false;
}
