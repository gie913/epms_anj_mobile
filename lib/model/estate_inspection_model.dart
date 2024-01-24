class EstateInspectionModel {
  const EstateInspectionModel({
    this.id = '',
    this.name = '',
    this.code = '',
    this.mCompanyId = '',
  });

  factory EstateInspectionModel.fromJson(Map<String, dynamic> json) =>
      EstateInspectionModel(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        code: json["code"] ?? '',
        mCompanyId: json["m_company_id"] ?? '',
      );

  final String id;
  final String name;
  final String code;
  final String mCompanyId;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['name'] = name;
    tempData['code'] = code;
    tempData['m_company_id'] = mCompanyId;

    return tempData;
  }

  @override
  String toString() {
    return 'EstateInspectionModel(id: $id, name: $name, code: $code, m_company_id: $mCompanyId)';
  }
}
