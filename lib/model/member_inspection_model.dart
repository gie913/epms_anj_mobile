class MemberInspectionModel {
  const MemberInspectionModel({
    this.id = '',
    this.mUserId = '',
    this.mTeamId = '',
    this.mCompanyId = '',
    this.mDivisionId = '',
    this.mEstateId = '',
    this.mUserName = '',
    this.mUserCode = '',
    this.mTeamName = '',
    this.mCompanyAlias = '',
    this.mDivisionName = '',
  });

  factory MemberInspectionModel.fromJson(Map<String, dynamic> json) =>
      MemberInspectionModel(
        id: json["id"] ?? '',
        mUserId: json["m_user_id"] ?? '',
        mTeamId: json["m_team_id"] ?? '',
        mCompanyId: json["m_company_id"] ?? '',
        mDivisionId: json["m_division_id"] ?? '',
        mEstateId: json['m_estate_id'] ?? '',
        mUserName: json["m_user_name"] ?? '',
        mUserCode: json["m_user_code"] ?? '',
        mTeamName: json["m_team_name"] ?? '',
        mCompanyAlias: json["m_company_alias"] ?? '',
        mDivisionName: json["m_division_name"] ?? '',
      );

  final String id;
  final String mUserId;
  final String mTeamId;
  final String mCompanyId;
  final String mDivisionId;
  final String mEstateId;
  final String mUserName;
  final String mUserCode;
  final String mTeamName;
  final String mCompanyAlias;
  final String mDivisionName;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['m_user_id'] = mUserId;
    tempData['m_team_id'] = mTeamId;
    tempData['m_company_id'] = mCompanyId;
    tempData['m_division_id'] = mDivisionId;
    tempData['m_estate_id'] = mEstateId;
    tempData['m_user_name'] = mUserName;
    tempData['m_user_code'] = mUserCode;
    tempData['m_team_name'] = mTeamName;
    tempData['m_company_alias'] = mCompanyAlias;
    tempData['m_division_name'] = mDivisionName;

    return tempData;
  }

  @override
  String toString() {
    return 'MemberInspectionModel(id: $id, m_user_id: $mUserId, m_team_id: $mTeamId, m_company_id: $mCompanyId, m_division_id: $mDivisionId, m_estate_id: $mEstateId, m_user_name: $mUserName, m_user_code: $mUserCode, m_team_name: $mTeamName, m_company_alias: $mCompanyAlias, m_division_name: $mDivisionName)';
  }
}
