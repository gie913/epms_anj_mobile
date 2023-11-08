class MemberInspectionModel {
  const MemberInspectionModel({
    this.id = '',
    this.mTeamId = '',
    this.mUserId = '',
    this.isActive = 0,
    this.createdAt = '',
    this.createdBy = '',
    this.updatedAt = '',
    this.updatedBy = '',
  });

  factory MemberInspectionModel.fromJson(Map<String, dynamic> json) =>
      MemberInspectionModel(
        id: json["id"] ?? '',
        mTeamId: json["m_team_id"] ?? '',
        mUserId: json["m_user_id"] ?? '',
        isActive: json["is_active"] ?? 0,
        createdAt: json["created_at"] ?? '',
        createdBy: json["created_by"] ?? '',
        updatedAt: json["updated_at"] ?? '',
        updatedBy: json["updated_by"] ?? '',
      );

  final String id;
  final String mTeamId;
  final String mUserId;
  final int isActive;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['m_team_id'] = mTeamId;
    tempData['m_user_id'] = mUserId;
    tempData['is_active'] = isActive;
    tempData['created_at'] = createdAt;
    tempData['created_by'] = createdBy;
    tempData['updated_at'] = updatedAt;
    tempData['updated_by'] = updatedBy;

    return tempData;
  }

  @override
  String toString() {
    return 'MemberInspectionModel(id: $id, m_team_id: $mTeamId, m_user_id: $mUserId, is_active: $isActive, created_at: $createdAt, created_by: $createdBy, updated_at: $updatedAt, updated_by: $updatedBy)';
  }
}
