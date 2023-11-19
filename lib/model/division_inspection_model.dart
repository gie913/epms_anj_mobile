class DivisionInspectionModel {
  const DivisionInspectionModel({
    this.id = '',
    this.name = '',
    this.code = '',
    this.estateCode = '',
    this.mCompanyId = '',
  });

  factory DivisionInspectionModel.fromJson(Map<String, dynamic> json) =>
      DivisionInspectionModel(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        code: json["code"] ?? '',
        estateCode: json["estate_code"] ?? '',
        mCompanyId: json["m_company_id"] ?? '',
      );

  final String id;
  final String name;
  final String code;
  final String estateCode;
  final String mCompanyId;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['name'] = name;
    tempData['code'] = code;
    tempData['estate_code'] = estateCode;
    tempData['m_company_id'] = mCompanyId;

    return tempData;
  }

  @override
  String toString() {
    return 'DivisionInspectionModel(id: $id, name: $name, code: $code, estate_code: $estateCode, m_company_id: $mCompanyId)';
  }
}
