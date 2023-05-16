
class MConfigSchema {
  String? userToken;
  String? userLogin;
  String? employeeCode;
  String? employeeName;
  dynamic userId;
  String? serverDate;
  String? serverTime;
  dynamic configId;
  String? companyCode;
  String? companyName;
  String? profileCode;
  String? profileName;
  String? estateCode;
  String? estateName;
  String? plantCode;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;
  dynamic configIdOld;
  String? loginDate;
  String? loginTime;
  String? apiRoot;

  MConfigSchema(
      {this.userToken,
        this.userLogin,
        this.employeeCode,
        this.employeeName,
        this.userId,
        this.serverDate,
        this.serverTime,
        this.configId,
        this.companyCode,
        this.companyName,
        this.profileCode,
        this.profileName,
        this.estateCode,
        this.estateName,
        this.plantCode,
        this.createdBy,
        this.createdDate,
        this.createdTime,
        this.updatedBy,
        this.updatedDate,
        this.updatedTime,
        this.configIdOld,
        this.loginDate,
        this.loginTime,
        this.apiRoot});

  MConfigSchema.fromJson(Map<String, dynamic> json) {
    userToken = json['user_token'];
    userLogin = json['user_login'];
    employeeCode = json['employee_code'];
    employeeName = json['employee_name'];
    userId = json['user_id'];
    serverDate = json['server_date'];
    serverTime = json['server_time'];
    configId = json['config_id'];
    companyCode = json['company_code'];
    companyName = json['company_name'];
    profileCode = json['profile_code'];
    profileName = json['profile_name'];
    estateCode = json['estate_code'];
    estateName = json['estate_name'];
    plantCode = json['plant_code'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
    configIdOld = json['config_id_old'];
    loginDate = json['login_date'];
    loginTime = json['login_time'];
    apiRoot = json['api_root'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_token'] = this.userToken;
    data['user_login'] = this.userLogin;
    data['employee_code'] = this.employeeCode;
    data['employee_name'] = this.employeeName;
    data['user_id'] = this.userId;
    data['server_date'] = this.serverDate;
    data['server_time'] = this.serverTime;
    data['config_id'] = this.configId;
    data['company_code'] = this.companyCode;
    data['company_name'] = this.companyName;
    data['profile_code'] = this.profileCode;
    data['profile_name'] = this.profileName;
    data['estate_code'] = this.estateCode;
    data['estate_name'] = this.estateName;
    data['plant_code'] = this.plantCode;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['updated_by'] = this.updatedBy;
    data['updated_date'] = this.updatedDate;
    data['updated_time'] = this.updatedTime;
    data['config_id_old'] = this.configIdOld;
    data['login_date'] = this.loginDate;
    data['login_time'] = this.loginTime;
    data['api_root'] = this.apiRoot;
    return data;
  }
}