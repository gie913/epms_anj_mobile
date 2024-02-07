import 'package:epms/model/action_inspection_model.dart';
import 'package:epms/model/company_inspection_model.dart';
import 'package:epms/model/division_inspection_model.dart';
import 'package:epms/model/estate_inspection_model.dart';
import 'package:epms/model/team_inspection_model.dart';
import 'package:epms/model/user_inspection_model.dart';

class SynchInspectionData {
  const SynchInspectionData({
    this.user = const [],
    this.team = const [],
    this.action = const [],
    this.company = const [],
    this.division = const [],
    this.estate = const [],
  });

  factory SynchInspectionData.fromJson(Map<String, dynamic> json) =>
      SynchInspectionData(
        user: json['user'] != null
            ? List<UserInspectionModel>.from(
                (json['user'] as List).map((e) {
                  return UserInspectionModel.fromJson(e);
                }),
              )
            : <UserInspectionModel>[],
        team: json['team'] != null
            ? List<TeamInspectionModel>.from(
                (json['team'] as List).map((e) {
                  return TeamInspectionModel.fromJson(e);
                }),
              )
            : <TeamInspectionModel>[],
        action: json['action'] != null
            ? List<ActionInspectionModel>.from(
                (json['action'] as List).map((e) {
                  return ActionInspectionModel.fromJson(e);
                }),
              )
            : <ActionInspectionModel>[],
        company: json['company'] != null
            ? List<CompanyInspectionModel>.from(
                (json['company'] as List).map((e) {
                  return CompanyInspectionModel.fromJson(e);
                }),
              )
            : <CompanyInspectionModel>[],
        division: json['division'] != null
            ? List<DivisionInspectionModel>.from(
                (json['division'] as List).map((e) {
                  return DivisionInspectionModel.fromJson(e);
                }),
              )
            : <DivisionInspectionModel>[],
        estate: json['estate'] != null
            ? List<EstateInspectionModel>.from(
                (json['estate'] as List).map((e) {
                  return EstateInspectionModel.fromJson(e);
                }),
              )
            : <EstateInspectionModel>[],
      );

  final List<UserInspectionModel> user;
  final List<TeamInspectionModel> team;
  final List<ActionInspectionModel> action;
  final List<CompanyInspectionModel> company;
  final List<DivisionInspectionModel> division;
  final List<EstateInspectionModel> estate;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['user'] = List.from(user.map((e) => e.toJson()));
    tempData['team'] = List.from(team.map((e) => e.toJson()));
    tempData['action'] = List.from(action.map((e) => e.toJson()));
    tempData['company'] = List.from(company.map((e) => e.toJson()));
    tempData['division'] = List.from(division.map((e) => e.toJson()));
    tempData['estate'] = List.from(estate.map((e) => e.toJson()));

    return tempData;
  }

  @override
  String toString() {
    return 'SynchInspectionData(user: $user, team: $team, action: $action, company: $company, division: $division, estate: $estate)';
  }
}
