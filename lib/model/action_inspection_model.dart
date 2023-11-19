import 'dart:convert';

class ActionInspectionModel {
  const ActionInspectionModel({
    this.name = '',
    this.options = const [],
  });

  factory ActionInspectionModel.fromJson(Map<String, dynamic> json) =>
      ActionInspectionModel(
        name: json["name"] ?? '',
        options: json["parameter"]["options"] != null
            ? List.from((json["parameter"]["options"] as List).map((e) => e))
            : const [],
      );

  factory ActionInspectionModel.fromDatabase(Map<String, dynamic> json) =>
      ActionInspectionModel(
        name: json["name"] ?? '',
        options: json["options"] != null
            ? List.from((jsonDecode(json["options"]) as List).map((e) => e))
            : const [],
      );

  final String name;
  final List options;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['name'] = name;
    tempData['options'] = List.from(options.map((e) => e));

    return tempData;
  }

  Map<String, dynamic> toDatabase() {
    final tempData = <String, dynamic>{};

    tempData['name'] = name;
    tempData['options'] = jsonEncode(options);

    return tempData;
  }

  @override
  String toString() {
    return 'ActionInspectionModel(name: $name, options: $options)';
  }
}
