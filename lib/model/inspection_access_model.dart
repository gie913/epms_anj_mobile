class InspectionAccessModel {
  const InspectionAccessModel({
    this.id = '',
    this.mModuleId = '',
    this.mRoleId = '',
    this.canCreate = 0,
    this.canUpdate = 0,
    this.canDelete = 0,
    this.isActive = 0,
  });

  factory InspectionAccessModel.fromJson(Map<String, dynamic> json) =>
      InspectionAccessModel(
        id: json["id"] ?? '',
        mModuleId: json["m_module_id"] ?? '',
        mRoleId: json["m_role_id"] ?? '',
        canCreate: json["can_create"] ?? 0,
        canUpdate: json["can_update"] ?? 0,
        canDelete: json["can_delete"] ?? 0,
        isActive: json["is_active"] ?? 0,
      );

  final String id;
  final String mModuleId;
  final String mRoleId;
  final int canCreate;
  final int canUpdate;
  final int canDelete;
  final int isActive;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['m_module_id'] = mModuleId;
    tempData['m_role_id'] = mRoleId;
    tempData['can_create'] = canCreate;
    tempData['can_update'] = canUpdate;
    tempData['can_delete'] = canDelete;
    tempData['is_active'] = isActive;

    return tempData;
  }

  @override
  String toString() {
    return 'InspectionAccessModel(id: $id, m_module_id: $mModuleId, m_role_id: $mRoleId, can_create: $canCreate, can_update: $canUpdate, can_delete: $canDelete, is_active: $isActive)';
  }
}
