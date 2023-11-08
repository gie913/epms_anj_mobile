class DivisionInspectionModel {
  const DivisionInspectionModel({
    this.id = '',
    this.name = '',
    this.estate = '',
  });

  factory DivisionInspectionModel.fromJson(Map<String, dynamic> json) =>
      DivisionInspectionModel(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        estate: json["code"] ?? '',
      );

  final String id;
  final String name;
  final String estate;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['name'] = name;
    tempData['estate'] = estate;

    return tempData;
  }

  @override
  String toString() {
    return 'DivisionInspectionModel(id: $id, name: $name, estate: $estate)';
  }
}
