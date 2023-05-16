import 'package:equatable/equatable.dart';

class SPBLoader extends Equatable{
  String? spbId;
  String? spbLoaderId;
  int? loaderType;
  int? loaderDestinationType;
  String? loaderEmployeeCode;
  String? loaderEmployeeName;
  int? loaderPercentage;

  SPBLoader(
      {this.spbId,
      this.spbLoaderId,
      this.loaderType,
      this.loaderDestinationType,
      this.loaderEmployeeCode,
      this.loaderEmployeeName,
      this.loaderPercentage});

  SPBLoader.fromJson(Map<String, dynamic> json) {
    spbId = json['spb_id'];
    spbLoaderId = json['spb_loader_id'];
    loaderType = json['loader_type'];
    loaderDestinationType = json['loader_destination_type'];
    loaderEmployeeCode = json['loader_employee_code'];
    loaderEmployeeName = json['loader_employee_name'];
    loaderPercentage = json['loader_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spb_id'] = this.spbId;
    data['spb_loader_id'] = this.spbLoaderId;
    data['loader_type'] = this.loaderType;
    data['loader_destination_type'] = this.loaderDestinationType;
    data['loader_employee_code'] = this.loaderEmployeeCode;
    data['loader_employee_name'] = this.loaderEmployeeName;
    data['loader_percentage'] = this.loaderPercentage;
    return data;
  }

  @override
  List<Object?> get props => [loaderEmployeeCode, loaderEmployeeName, spbLoaderId];
}
