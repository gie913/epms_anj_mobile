class CompanyInspectionModel {
  const CompanyInspectionModel({
    this.id = '',
    this.name = '',
    this.code = '',
    this.alias = '',
  });

  factory CompanyInspectionModel.fromJson(Map<String, dynamic> json) =>
      CompanyInspectionModel(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        code: json["code"] ?? '',
        alias: json["alias"] ?? '',
      );

  final String id;
  final String name;
  final String code;
  final String alias;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['name'] = name;
    tempData['code'] = code;
    tempData['alias'] = alias;

    return tempData;
  }

  @override
  String toString() {
    return 'CompanyInspectionModel(id: $id, name: $name, code: $code, alias: $alias)';
  }
}
