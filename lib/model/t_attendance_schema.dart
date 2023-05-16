class TAttendanceSchema {
  String? attendanceMandorEmployeeCode;
  String? attendanceMandorEmployeeName;
  String? attendanceEmployeeCode;
  String? attendanceEmployeeName;
  String? attendanceKeraniEmployeeCode;
  String? attendanceKeraniEmployeeName;
  dynamic attendanceId;
  String? attendanceDate;
  String? attendanceCode;
  String? attendanceDesc;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;

  TAttendanceSchema(
      {this.attendanceMandorEmployeeCode,
      this.attendanceMandorEmployeeName,
      this.attendanceEmployeeCode,
      this.attendanceEmployeeName,
      this.attendanceKeraniEmployeeCode,
      this.attendanceKeraniEmployeeName,
      this.attendanceId,
      this.attendanceDate,
      this.attendanceCode,
      this.attendanceDesc,
      this.createdBy,
      this.createdDate,
      this.createdTime,
      this.updatedBy,
      this.updatedDate,
      this.updatedTime});

  TAttendanceSchema.fromJson(Map<String, dynamic> json) {
    attendanceMandorEmployeeCode = json['attendance_mandor_employee_code'];
    attendanceMandorEmployeeName = json['attendance_mandor_employee_name'];
    attendanceEmployeeCode = json['attendance_employee_code'];
    attendanceEmployeeName = json['attendance_employee_name'];
    attendanceKeraniEmployeeCode = json['attendance_kerani_employee_code'];
    attendanceKeraniEmployeeName = json['attendance_kerani_employee_name'];
    attendanceId = json['attendance_id'];
    attendanceDate = json['attendance_date'];
    attendanceCode = json['attendance_code'];
    attendanceDesc = json['attendance_desc'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attendance_mandor_employee_code'] = this.attendanceMandorEmployeeCode;
    data['attendance_mandor_employee_name'] = this.attendanceMandorEmployeeName;
    data['attendance_employee_code'] = this.attendanceEmployeeCode;
    data['attendance_employee_name'] = this.attendanceEmployeeName;
    data['attendance_kerani_employee_code'] = this.attendanceKeraniEmployeeCode;
    data['attendance_kerani_employee_name'] = this.attendanceKeraniEmployeeName;
    data['attendance_id'] = this.attendanceId;
    data['attendance_date'] = this.attendanceDate;
    data['attendance_code'] = this.attendanceCode;
    data['attendance_desc'] = this.attendanceDesc;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    return data;
  }
}
