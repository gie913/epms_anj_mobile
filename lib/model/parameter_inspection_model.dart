class ParameterInspectionModel {
  const ParameterInspectionModel({
    this.isLastLevel = false,
    this.options = const [],
  });

  factory ParameterInspectionModel.fromJson(Map<String, dynamic> json) =>
      ParameterInspectionModel(
        isLastLevel: json["is_last_level"],
        options: json['options'] != null
            ? List<String>.from(
                (json['options'] as List).map((e) {
                  return e as String;
                }),
              )
            : <String>[],
      );

  final bool isLastLevel;
  final List<String> options;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['is_last_level'] = isLastLevel;
    tempData['options'] = List.from(options.map((e) => e));

    return tempData;
  }

  @override
  String toString() {
    return 'ParameterInspectionModel(is_last_level: $isLastLevel, options: $options)';
  }
}
