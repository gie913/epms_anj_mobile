class UserInspectionModel {
  const UserInspectionModel({
    this.id = '',
    this.code = '',
    this.name = '',
    this.employeeCode = '',
    this.employeeNumber = '',
    this.mCompanyId = '',
  });

  factory UserInspectionModel.fromJson(Map<String, dynamic> json) =>
      UserInspectionModel(
        id: json["id"] ?? '',
        code: json["code"] ?? '',
        name: json["name"] ?? '',
        employeeCode: json["employee_code"] ?? '',
        employeeNumber: json["employee_number"] ?? '',
        mCompanyId: json["m_company_id"] ?? '',
      );

  final String id;
  final String code;
  final String name;
  final String employeeCode;
  final String employeeNumber;
  final String mCompanyId;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['code'] = code;
    tempData['name'] = name;
    tempData['employee_code'] = employeeCode;
    tempData['employee_number'] = employeeNumber;
    tempData['m_company_id'] = mCompanyId;

    return tempData;
  }

  @override
  String toString() {
    return 'UserInspectionModel(id: $id, code: $code, name: $name, employee_code: $employeeCode, employee_number: $employeeNumber, m_company_id: $mCompanyId)';
  }
}
