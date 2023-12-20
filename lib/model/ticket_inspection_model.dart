import 'dart:convert';

import 'package:epms/database/helper/convert_helper.dart';
import 'package:epms/model/history_inspection_model.dart';

class TicketInspectionModel {
  const TicketInspectionModel({
    this.id = '',
    this.code = '',
    this.trTime = '',
    this.mCompanyId = '',
    this.mCompanyName = '',
    this.mCompanyAlias = '',
    this.mTeamId = '',
    this.mTeamName = '',
    this.mDivisionId = '',
    this.mDivisionName = '',
    this.mDivisionEstateCode = '',
    this.gpsLng = 0,
    this.gpsLat = 0,
    this.submittedAt = '',
    this.submittedBy = '',
    this.submittedByName = '',
    this.assignee = '',
    this.assigneeId = '',
    this.status = '',
    this.description = '',
    this.closedAt = '',
    this.closedBy = '',
    this.closedByName = '',
    this.isSynchronize = 0,
    this.isNewResponse = 0,
    this.isClosed = 0,
    this.attachments = const [],
    this.responses = const <HistoryInspectionModel>[],
  });

  factory TicketInspectionModel.fromJson(Map<String, dynamic> json) =>
      TicketInspectionModel(
        id: json['id'] ?? '',
        code: json['code'] ?? '',
        trTime: json['tr_time'] ?? '',
        mCompanyId: json['m_company_id'] ?? '',
        mCompanyName: json['m_company_name'] ?? '',
        mCompanyAlias: json['m_company_alias'] ?? '',
        mTeamId: json['m_team_id'] ?? '',
        mTeamName: json['m_team_name'] ?? '',
        mDivisionId: json['m_division_id'] ?? '',
        mDivisionName: json['m_division_name'] ?? '',
        mDivisionEstateCode: json['m_division_estate_code'] ?? '',
        gpsLng: ConvertHelper.stringToDouble(json['gps_lng'] ?? ''),
        gpsLat: ConvertHelper.stringToDouble(json['gps_lat'] ?? ''),
        submittedAt: json['submitted_at'] ?? '',
        submittedBy: json['submitted_by'] ?? '',
        submittedByName: json['submitted_by_name'] ?? '',
        assignee: json['assignee'] ?? '',
        assigneeId: json['assignee_id'] ?? '',
        status: json['status'] ?? '',
        description: json['description'] ?? '',
        closedAt: json['closed_at'] ?? '',
        closedBy: json['closed_by'] ?? '',
        closedByName: json['closed_by_name'] ?? '',
        isSynchronize: json['is_synchronize'] ?? 1,
        isNewResponse: json['is_new_response'] ?? 0,
        isClosed: ConvertHelper.boolToInt(json['is_closed']),
        attachments: json['attachments'] != null
            ? List.from((json['attachments'] as List).map((e) => e))
            : [],
        responses: json['responses'] != null
            ? List<HistoryInspectionModel>.from(
                (json['responses'] as List).map((e) {
                  return HistoryInspectionModel.fromJson(e);
                }),
              )
            : <HistoryInspectionModel>[],
      );

  factory TicketInspectionModel.fromDatabase(Map<String, dynamic> json) =>
      TicketInspectionModel(
        id: json['id'] ?? '',
        code: json['code'] ?? '',
        trTime: json['tr_time'] ?? '',
        mCompanyId: json['m_company_id'] ?? '',
        mCompanyName: json['m_company_name'] ?? '',
        mCompanyAlias: json['m_company_alias'] ?? '',
        mTeamId: json['m_team_id'] ?? '',
        mTeamName: json['m_team_name'] ?? '',
        mDivisionId: json['m_division_id'] ?? '',
        mDivisionName: json['m_division_name'] ?? '',
        mDivisionEstateCode: json['m_division_estate_code'] ?? '',
        gpsLng: json['gps_lng'] ?? 0,
        gpsLat: json['gps_lat'] ?? 0,
        submittedAt: json['submitted_at'] ?? '',
        submittedBy: json['submitted_by'] ?? '',
        submittedByName: json['submitted_by_name'] ?? '',
        assignee: json['assignee'] ?? '',
        assigneeId: json['assignee_id'] ?? '',
        status: json['status'] ?? '',
        description: json['description'] ?? '',
        closedAt: json['closed_at'] ?? '',
        closedBy: json['closed_by'] ?? '',
        closedByName: json['closed_by_name'] ?? '',
        isSynchronize: json['is_synchronize'] ?? 0,
        isNewResponse: json['is_new_response'] ?? 0,
        isClosed: json['is_closed'] ?? 0,
        attachments: json['attachments'] != null
            ? List.from(
                (jsonDecode(json['attachments']) as List).map((e) => e),
              )
            : [],
        responses: json['responses'] != null
            ? List<HistoryInspectionModel>.from(
                (jsonDecode(json['responses']) as List).map((e) {
                  return HistoryInspectionModel.fromJson(e);
                }),
              )
            : <HistoryInspectionModel>[],
      );

  final String id;
  final String code;
  final String trTime;
  final String mCompanyId;
  final String mCompanyName;
  final String mCompanyAlias;
  final String mTeamId;
  final String mTeamName;
  final String mDivisionId;
  final String mDivisionName;
  final String mDivisionEstateCode;
  final double gpsLng;
  final double gpsLat;
  final String submittedAt;
  final String submittedBy;
  final String submittedByName;
  final String assignee;
  final String assigneeId;
  final String status;
  final String description;
  final String closedAt;
  final String closedBy;
  final String closedByName;
  final int isSynchronize;
  final int isNewResponse;
  final int isClosed;
  final List attachments;
  final List<HistoryInspectionModel> responses;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['code'] = code;
    tempData['tr_time'] = trTime;
    tempData['m_company_id'] = mCompanyId;
    tempData['m_company_name'] = mCompanyName;
    tempData['m_company_alias'] = mCompanyAlias;
    tempData['m_team_id'] = mTeamId;
    tempData['m_team_name'] = mTeamName;
    tempData['m_division_id'] = mDivisionId;
    tempData['m_division_name'] = mDivisionName;
    tempData['m_division_estate_code'] = mDivisionEstateCode;
    tempData['gps_lng'] = gpsLng;
    tempData['gps_lat'] = gpsLat;
    tempData['submitted_at'] = submittedAt;
    tempData['submitted_by'] = submittedBy;
    tempData['submitted_by_name'] = submittedByName;
    tempData['assignee'] = assignee;
    tempData['assignee_id'] = assigneeId;
    tempData['status'] = status;
    tempData['description'] = description;
    tempData['closed_at'] = closedAt;
    tempData['closed_by'] = closedBy;
    tempData['closed_by_name'] = closedByName;
    tempData['is_synchronize'] = isSynchronize;
    tempData['is_new_response'] = isNewResponse;
    tempData['is_closed'] = isClosed;
    tempData['attachments'] = List.from(attachments.map((e) => e));
    tempData['responses'] = List.from(responses.map((e) => e.toJson()));

    return tempData;
  }

  Map<String, dynamic> toDatabase() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['code'] = code;
    tempData['tr_time'] = trTime;
    tempData['m_company_id'] = mCompanyId;
    tempData['m_company_name'] = mCompanyName;
    tempData['m_company_alias'] = mCompanyAlias;
    tempData['m_team_id'] = mTeamId;
    tempData['m_team_name'] = mTeamName;
    tempData['m_division_id'] = mDivisionId;
    tempData['m_division_name'] = mDivisionName;
    tempData['m_division_estate_code'] = mDivisionEstateCode;
    tempData['gps_lng'] = gpsLng;
    tempData['gps_lat'] = gpsLat;
    tempData['submitted_at'] = submittedAt;
    tempData['submitted_by'] = submittedBy;
    tempData['submitted_by_name'] = submittedByName;
    tempData['assignee'] = assignee;
    tempData['assignee_id'] = assigneeId;
    tempData['status'] = status;
    tempData['description'] = description;
    tempData['closed_at'] = closedAt;
    tempData['closed_by'] = closedBy;
    tempData['closed_by_name'] = closedByName;
    tempData['is_synchronize'] = isSynchronize;
    tempData['is_new_response'] = isNewResponse;
    tempData['is_closed'] = isClosed;
    tempData['attachments'] = jsonEncode(List.from(attachments.map((e) => e)));
    tempData['responses'] =
        jsonEncode(List.from(responses.map((e) => e.toJson())));

    return tempData;
  }

  @override
  String toString() {
    return 'TicketInspectionModel(id: $id, code: $code, tr_time: $trTime, m_company_id: $mCompanyId, m_company_name: $mCompanyName, m_company_alias: $mCompanyAlias, m_team_id: $mTeamId, m_team_name: $mTeamName, m_division_id: $mDivisionId, m_division_name: $mDivisionName, m_division_estate_code: $mDivisionEstateCode, gps_lng: $gpsLng, gps_lat: $gpsLat, submitted_at: $submittedAt, submitted_by: $submittedBy, submitted_by_name: $submittedByName, assignee: $assignee, assignee_id: $assigneeId, status: $status, description: $description, closed_at: $closedAt, closed_by: $closedBy, closed_by_name: $closedByName, is_synchronize: $isSynchronize, is_new_response: $isNewResponse, is_closed: $isClosed, attachments: $attachments, responses: $responses)';
  }
}
