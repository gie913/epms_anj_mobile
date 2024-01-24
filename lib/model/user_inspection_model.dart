class UserInspectionModel {
  const UserInspectionModel({
    this.id = '',
    this.code = '',
    this.name = '',
    this.employeeCode = '',
    this.employeeNumber = '',
    this.userEstate = '',
    this.userDivision = '',
    this.mCompanyId = '',
    this.mOccupationName = '',
  });

  factory UserInspectionModel.fromJson(Map<String, dynamic> json) =>
      UserInspectionModel(
        id: json["id"] ?? '',
        code: json["code"] ?? '',
        name: json["name"] ?? '',
        employeeCode: json["employee_code"] ?? '',
        employeeNumber: json["employee_number"] ?? '',
        userEstate: json["user_estate"] ?? '',
        userDivision: json["user_division"] ?? '',
        mCompanyId: json["m_company_id"] ?? '',
        mOccupationName: json["m_occupation_name"] ?? '',
      );

  final String id;
  final String code;
  final String name;
  final String employeeCode;
  final String employeeNumber;
  final String userEstate;
  final String userDivision;
  final String mCompanyId;
  final String mOccupationName;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['code'] = code;
    tempData['name'] = name;
    tempData['employee_code'] = employeeCode;
    tempData['employee_number'] = employeeNumber;
    tempData['user_estate'] = userEstate;
    tempData['user_division'] = userDivision;
    tempData['m_company_id'] = mCompanyId;
    tempData['m_occupation_name'] = mOccupationName;

    return tempData;
  }

  @override
  String toString() {
    return 'UserInspectionModel(id: $id, code: $code, name: $name, employee_code: $employeeCode, employee_number: $employeeNumber, user_estate: $userEstate, user_division: $userDivision, m_company_id: $mCompanyId, m_occupation_name: $mOccupationName)';
  }
}
