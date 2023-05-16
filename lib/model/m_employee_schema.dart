import 'package:equatable/equatable.dart';

class MEmployeeSchema extends Equatable {
  dynamic employeeId;
  String? employeeEstateCode;
  String? employeeCode;
  String? employeeName;
  dynamic employeeSex;
  String? employeeValidFrom;
  String? employeeValidTo;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;
  String? employeeJobCode;
  String? employeeDivisionCode;

  MEmployeeSchema(
      {this.employeeId,
      this.employeeEstateCode,
      this.employeeCode,
      this.employeeName,
      this.employeeSex,
      this.employeeValidFrom,
      this.employeeValidTo,
      this.createdBy,
      this.createdDate,
      this.createdTime,
      this.updatedBy,
      this.updatedDate,
      this.updatedTime,
      this.employeeJobCode,
      this.employeeDivisionCode});

  MEmployeeSchema.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    employeeEstateCode = json['employee_estate_code'];
    employeeCode = json['employee_code'];
    employeeName = json['employee_name'];
    employeeSex = json['employee_sex'];
    employeeValidFrom = json['employee_valid_from'];
    employeeValidTo = json['employee_valid_to'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
    employeeJobCode = json['employee_job_code'];
    employeeDivisionCode = json['employee_division_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_id'] = this.employeeId;
    data['employee_estate_code'] = this.employeeEstateCode;
    data['employee_code'] = this.employeeCode;
    data['employee_name'] = this.employeeName;
    data['employee_sex'] = this.employeeSex;
    data['employee_valid_from'] = this.employeeValidFrom;
    data['employee_valid_to'] = this.employeeValidTo;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    data['employee_job_code'] = this.employeeJobCode;
    data['employee_division_code'] = this.employeeDivisionCode;
    return data;
  }

  @override
  List<Object> get props => [employeeCode!, employeeName!];

  @override
  bool get stringify => false;
}
