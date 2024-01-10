class MemberInspectionModel {
  const MemberInspectionModel({
    this.id = '',
    this.mTeamId = '',
    this.mUserId = '',
    this.mCompanyId = '',
    this.mDivisionId = '',
    this.mEstateId = '',
  });

  factory MemberInspectionModel.fromJson(Map<String, dynamic> json) =>
      MemberInspectionModel(
        id: json["id"] ?? '',
        mTeamId: json["m_team_id"] ?? '',
        mUserId: json["m_user_id"] ?? '',
        mCompanyId: json["m_company_id"] ?? '',
        mDivisionId: json["m_division_id"] ?? '',
        mEstateId: json["m_estate_id"] ?? '',
      );

  final String id;
  final String mTeamId;
  final String mUserId;
  final String mCompanyId;
  final String mDivisionId;
  final String mEstateId;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['m_team_id'] = mTeamId;
    tempData['m_user_id'] = mUserId;
    tempData['m_company_id'] = mCompanyId;
    tempData['m_division_id'] = mDivisionId;
    tempData['m_estate_id'] = mEstateId;

    return tempData;
  }

  @override
  String toString() {
    return 'MemberInspectionModel(id: $id, m_team_id: $mTeamId, m_user_id: $mUserId, m_company_id: $mCompanyId, m_division_id: $mDivisionId, m_estate_id: $mEstateId)';
  }
}
