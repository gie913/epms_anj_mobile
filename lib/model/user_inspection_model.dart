class UserInspectionModel {
  const UserInspectionModel({
    this.id = '',
    this.name = '',
    this.employeeCode = '',
    this.employeeNumber = '',
  });

  factory UserInspectionModel.fromJson(Map<String, dynamic> json) =>
      UserInspectionModel(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        employeeCode: json["employee_code"] ?? '',
        employeeNumber: json["employee_number"] ?? '',
      );

  final String id;
  final String name;
  final String employeeCode;
  final String employeeNumber;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['name'] = name;
    tempData['employee_code'] = employeeCode;
    tempData['employee_number'] = employeeNumber;

    return tempData;
  }

  @override
  String toString() {
    return 'UserInspectionModel(id: $id, name: $name, employee_code: $employeeCode, employee_number: $employeeNumber)';
  }
}
