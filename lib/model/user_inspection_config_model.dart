class UserInspectionConfigModel {
  const UserInspectionConfigModel({
    this.id = '',
    this.code = '',
    this.name = '',
    this.email = '',
    this.emailVerifiedAt = '',
    this.mRoleId = '',
    this.username = '',
    this.address = '',
    this.gender = '',
    this.rememberToken = '',
    this.mCompanyId = '',
    this.mEmployeeHrisId = '',
    this.phoneNumber = '',
    this.lastLogin = '',
    this.loginStatus = '',
    this.lastConnected = '',
    this.mOccupationId = '',
    this.mDepartmentId = '',
    this.mMillId = '',
    this.groupName = '',
    this.level = 0,
    this.employeeCode = '',
    this.employeeNumber = '',
    this.supervisorEmployeeCode = '',
    this.isActive = 0,
    this.createdAt = '',
    this.createdBy = '',
    this.updatedAt = '',
    this.updatedBy = '',
  });

  factory UserInspectionConfigModel.fromJson(Map<String, dynamic> json) =>
      UserInspectionConfigModel(
        id: json["id"] ?? '',
        code: json["code"] ?? '',
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        emailVerifiedAt: json["email_verified_at"] ?? '',
        mRoleId: json["m_role_id"] ?? '',
        username: json["username"] ?? '',
        address: json["address"] ?? '',
        gender: json["gender"] ?? '',
        rememberToken: json["remember_token"] ?? '',
        mCompanyId: json["m_company_id"] ?? '',
        mEmployeeHrisId: json["m_employee_hris_id"] ?? '',
        phoneNumber: json["phone_number"] ?? '',
        lastLogin: json["last_login"] ?? '',
        loginStatus: json["login_status"] ?? '',
        lastConnected: json["last_connected"] ?? '',
        mOccupationId: json["m_occupation_id"] ?? '',
        mDepartmentId: json["m_department_id"] ?? '',
        mMillId: json["m_mill_id"] ?? '',
        groupName: json["group_name"] ?? '',
        level: json["level"] ?? 0,
        employeeCode: json["employee_code"] ?? '',
        employeeNumber: json["employee_number"] ?? '',
        supervisorEmployeeCode: json["supervisor_employee_code"] ?? '',
        isActive: json["is_active"] ?? 0,
        createdAt: json["created_at"] ?? '',
        createdBy: json["created_by"] ?? '',
        updatedAt: json["updated_at"] ?? '',
        updatedBy: json["updated_by"] ?? '',
      );

  final String id;
  final String code;
  final String name;
  final String email;
  final String emailVerifiedAt;
  final String mRoleId;
  final String username;
  final String address;
  final String gender;
  final String rememberToken;
  final String mCompanyId;
  final String mEmployeeHrisId;
  final String phoneNumber;
  final String lastLogin;
  final String loginStatus;
  final String lastConnected;
  final String mOccupationId;
  final String mDepartmentId;
  final String mMillId;
  final String groupName;
  final int level;
  final String employeeCode;
  final String employeeNumber;
  final String supervisorEmployeeCode;
  final int isActive;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['code'] = code;
    tempData['name'] = name;
    tempData['email'] = email;
    tempData['email_verified_at'] = emailVerifiedAt;
    tempData['m_role_id'] = mRoleId;
    tempData['username'] = username;
    tempData['address'] = address;
    tempData['gender'] = gender;
    tempData['remember_token'] = rememberToken;
    tempData['m_company_id'] = mCompanyId;
    tempData['m_employee_hris_id'] = mEmployeeHrisId;
    tempData['phone_number'] = phoneNumber;
    tempData['last_login'] = lastLogin;
    tempData['login_status'] = loginStatus;
    tempData['last_connected'] = lastConnected;
    tempData['m_occupation_id'] = mOccupationId;
    tempData['m_department_id'] = mDepartmentId;
    tempData['m_mill_id'] = mMillId;
    tempData['group_name'] = groupName;
    tempData['level'] = level;
    tempData['employee_code'] = employeeCode;
    tempData['employee_number'] = employeeNumber;
    tempData['supervisor_employee_code'] = supervisorEmployeeCode;
    tempData['is_active'] = isActive;
    tempData['created_at'] = createdAt;
    tempData['created_by'] = createdBy;
    tempData['updated_at'] = updatedAt;
    tempData['updated_by'] = updatedBy;

    return tempData;
  }

  @override
  String toString() {
    return 'UserInspectionConfigModel(id: $id, code: $code, name: $name, email: $email, email_verified_at: $emailVerifiedAt, m_role_id: $mRoleId, username: $username, address: $address, gender: $gender, remember_token: $rememberToken, m_company_id: $mCompanyId, m_employee_hris_id: $mEmployeeHrisId, phone_number: $phoneNumber, last_login: $lastLogin, login_status: $loginStatus, last_connected: $lastConnected, m_occupation_id: $mOccupationId, m_department_id: $mDepartmentId, m_mill_id: $mMillId, group_name: $groupName, level: $level, employee_code: $employeeCode, employee_number: $employeeNumber, supervisor_employee_code: $supervisorEmployeeCode, is_active: $isActive, created_at: $createdAt, created_by: $createdBy, updated_at: $updatedAt, updated_by: $updatedBy)';
  }
}
