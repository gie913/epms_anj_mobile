import 'package:epms/model/member_inspection_model.dart';

class TeamInspectionModel {
  const TeamInspectionModel({
    this.id = '',
    this.code = '',
    this.name = '',
    this.member = const [],
  });

  factory TeamInspectionModel.fromJson(Map<String, dynamic> json) =>
      TeamInspectionModel(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        member: json['member'] != null
            ? List<MemberInspectionModel>.from(
                (json['member'] as List).map((e) {
                  return MemberInspectionModel.fromJson(e);
                }),
              )
            : <MemberInspectionModel>[],
      );

  factory TeamInspectionModel.fromDatabase(Map<String, dynamic> json) =>
      TeamInspectionModel(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        member: const <MemberInspectionModel>[],
      );

  final String id;
  final String code;
  final String name;
  final List<MemberInspectionModel> member;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['code'] = code;
    tempData['name'] = name;
    tempData['member'] = List.from(member.map((e) => e.toJson()));

    return tempData;
  }

  Map<String, dynamic> toDatabase() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['code'] = code;
    tempData['name'] = name;

    return tempData;
  }

  @override
  String toString() {
    return 'TeamInspectionModel(id: $id, code: $code, name: $name, member: $member)';
  }
}
