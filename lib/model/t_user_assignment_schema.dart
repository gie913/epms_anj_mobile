class TUserAssignmentSchema {
  dynamic mandorId;
  String? estateCode;
  String? mandor1EmployeeCode;
  String? mandor1EmployeeName;
  String? keraniKirimEmployeeCode;
  String? keraniKirimEmployeeName;
  String? mandorEmployeeCode;
  String? mandorEmployeeName;
  String? keraniPanenEmployeeCode;
  String? keraniPanenEmployeeName;
  String? employeeCode;
  String? employeeName;
  String? startValidity;
  String? endValidity;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;

  TUserAssignmentSchema(
      {this.mandorId,
      this.estateCode,
      this.mandor1EmployeeCode,
      this.mandor1EmployeeName,
      this.keraniKirimEmployeeCode,
      this.keraniKirimEmployeeName,
      this.mandorEmployeeCode,
      this.mandorEmployeeName,
      this.keraniPanenEmployeeCode,
      this.keraniPanenEmployeeName,
      this.employeeCode,
      this.employeeName,
      this.startValidity,
      this.endValidity,
      this.createdBy,
      this.createdDate,
      this.createdTime,
      this.updatedBy,
      this.updatedDate,
      this.updatedTime});

  TUserAssignmentSchema.fromJson(Map<String, dynamic> json) {
    mandorId = json['mandor_id'];
    estateCode = json['estate_code'];
    mandor1EmployeeCode = json['mandor1_employee_code'];
    mandor1EmployeeName = json['mandor1_employee_name'];
    keraniKirimEmployeeCode = json['kerani_kirim_employee_code'];
    keraniKirimEmployeeName = json['kerani_kirim_employee_name'];
    mandorEmployeeCode = json['mandor_employee_code'];
    mandorEmployeeName = json['mandor_employee_name'];
    keraniPanenEmployeeCode = json['kerani_panen_employee_code'];
    keraniPanenEmployeeName = json['kerani_panen_employee_name'];
    employeeCode = json['employee_code'];
    employeeName = json['employee_name'];
    startValidity = json['start_validity'];
    endValidity = json['end_validity'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mandor_id'] = this.mandorId;
    data['estate_code'] = this.estateCode;
    data['mandor1_employee_code'] = this.mandor1EmployeeCode;
    data['mandor1_employee_name'] = this.mandor1EmployeeName;
    data['kerani_kirim_employee_code'] = this.keraniKirimEmployeeCode;
    data['kerani_kirim_employee_name'] = this.keraniKirimEmployeeName;
    data['mandor_employee_code'] = this.mandorEmployeeCode;
    data['mandor_employee_name'] = this.mandorEmployeeName;
    data['kerani_panen_employee_code'] = this.keraniPanenEmployeeCode;
    data['kerani_panen_employee_name'] = this.keraniPanenEmployeeName;
    data['employee_code'] = this.employeeCode;
    data['employee_name'] = this.employeeName;
    data['start_validity'] = this.startValidity;
    data['end_validity'] = this.endValidity;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    return data;
  }
}
