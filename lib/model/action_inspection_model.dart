import 'dart:convert';

import 'package:epms/model/parameter_inspection_model.dart';

class ActionInspectionModel {
  const ActionInspectionModel({
    this.name = '',
    this.parameter = const ParameterInspectionModel(),
  });

  factory ActionInspectionModel.fromJson(Map<String, dynamic> json) =>
      ActionInspectionModel(
        name: json["name"] ?? '',
        parameter: json["parameter"] != null
            ? ParameterInspectionModel.fromJson(json["parameter"])
            : const ParameterInspectionModel(),
      );

  factory ActionInspectionModel.fromDatabase(Map<String, dynamic> json) =>
      ActionInspectionModel(
        name: json["name"] ?? '',
        parameter: json["parameter"] != null
            ? ParameterInspectionModel.fromJson(jsonDecode(json["parameter"]))
            : const ParameterInspectionModel(),
      );

  final String name;
  final ParameterInspectionModel parameter;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['name'] = name;
    tempData['parameter'] = parameter.toJson();

    return tempData;
  }

  Map<String, dynamic> toDatabase() {
    final tempData = <String, dynamic>{};

    tempData['name'] = name;
    tempData['parameter'] = jsonEncode(parameter.toJson());

    return tempData;
  }

  @override
  String toString() {
    return 'ActionInspectionModel(name: $name, parameter: $parameter)';
  }
}
