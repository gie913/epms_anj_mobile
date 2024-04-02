import 'dart:convert';

import 'package:epms/database/helper/convert_helper.dart';
import 'package:equatable/equatable.dart';

class ResponseInspectionModel extends Equatable {
  const ResponseInspectionModel({
    this.tInspectionId = '',
    this.id = '',
    this.code = '',
    this.trTime = '',
    this.submittedAt = '',
    this.submittedBy = '',
    this.submittedByName = '',
    this.reassignedTo = '',
    this.reassignedToName = '',
    this.consultedWith = '',
    this.consultedWithName = '',
    this.description = '',
    this.gpsLat = 0,
    this.gpsLng = 0,
    this.status = '',
    this.attachments = const [],
    this.isSynchronize = 0,
    this.isNewResponse = 0,
  });

  factory ResponseInspectionModel.fromJson(Map<String, dynamic> json) =>
      ResponseInspectionModel(
        tInspectionId: json['t_inspection_id'] ?? '',
        id: json['id'] ?? '',
        code: json['code'] ?? '',
        trTime: json['tr_time'] ?? '',
        submittedAt: json['submitted_at'] ?? '',
        submittedBy: json['submitted_by'] ?? '',
        submittedByName: json['submitted_by_name'] ?? '',
        reassignedTo: json['reassigned_to'] ?? '',
        reassignedToName: json['reassigned_to_name'] ?? '',
        consultedWith: json['consulted_with'] ?? '',
        consultedWithName: json['consulted_with_name'] ?? '',
        description: json['description'] ?? '',
        gpsLat: ConvertHelper.stringToDouble(json['gps_lat'] ?? ''),
        gpsLng: ConvertHelper.stringToDouble(json['gps_lng'] ?? ''),
        status: json['status'] ?? '',
        attachments: json['attachments'] != null
            ? List.from((json['attachments'] as List).map((e) => e))
            : const [],
        isSynchronize: json['is_synchronize'] ?? 1,
        isNewResponse: json['is_new_response'] ?? 0,
      );

  factory ResponseInspectionModel.fromDatabase(Map<String, dynamic> json) =>
      ResponseInspectionModel(
        tInspectionId: json['t_inspection_id'] ?? '',
        id: json['id'] ?? '',
        code: json['code'] ?? '',
        trTime: json['tr_time'] ?? '',
        submittedAt: json['submitted_at'] ?? '',
        submittedBy: json['submitted_by'] ?? '',
        submittedByName: json['submitted_by_name'] ?? '',
        reassignedTo: json['reassigned_to'] ?? '',
        reassignedToName: json['reassigned_to_name'] ?? '',
        consultedWith: json['consulted_with'] ?? '',
        consultedWithName: json['consulted_with_name'] ?? '',
        description: json['description'] ?? '',
        gpsLat: json['gps_lat'] ?? 0,
        gpsLng: json['gps_lng'] ?? 0,
        status: json['status'] ?? '',
        attachments: json['attachments'] != null
            ? List.from(
                (jsonDecode(json['attachments']) as List).map((e) => e),
              )
            : [],
        isSynchronize: json['is_synchronize'] ?? 0,
        isNewResponse: json['is_new_response'] ?? 0,
      );

  final String tInspectionId;
  final String id;
  final String code;
  final String trTime;
  final String submittedAt;
  final String submittedBy;
  final String submittedByName;
  final String reassignedTo;
  final String reassignedToName;
  final String consultedWith;
  final String consultedWithName;
  final String description;
  final double gpsLng;
  final double gpsLat;
  final String status;
  final List attachments;
  final int isSynchronize;
  final int isNewResponse;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['t_inspection_id'] = tInspectionId;
    tempData['id'] = id;
    tempData['code'] = code;
    tempData['tr_time'] = trTime;
    tempData['submitted_at'] = submittedAt;
    tempData['submitted_by'] = submittedBy;
    tempData['submitted_by_name'] = submittedByName;
    tempData['reassigned_to'] = reassignedTo;
    tempData['reassigned_to_name'] = reassignedToName;
    tempData['consulted_with'] = consultedWith;
    tempData['consulted_with_name'] = consultedWithName;
    tempData['description'] = description;
    tempData['gps_lat'] = gpsLat.toString();
    tempData['gps_lng'] = gpsLng.toString();
    tempData['status'] = status;
    tempData['attachments'] = List.from(attachments.map((e) => e));
    tempData['is_synchronize'] = isSynchronize;
    tempData['is_new_response'] = isNewResponse;

    return tempData;
  }

  Map<String, dynamic> toDatabase() {
    final tempData = <String, dynamic>{};

    tempData['t_inspection_id'] = tInspectionId;
    tempData['id'] = id;
    tempData['code'] = code;
    tempData['tr_time'] = trTime;
    tempData['submitted_at'] = submittedAt;
    tempData['submitted_by'] = submittedBy;
    tempData['submitted_by_name'] = submittedByName;
    tempData['reassigned_to'] = reassignedTo;
    tempData['reassigned_to_name'] = reassignedToName;
    tempData['consulted_with'] = consultedWith;
    tempData['consulted_with_name'] = consultedWithName;
    tempData['description'] = description;
    tempData['gps_lng'] = gpsLng;
    tempData['gps_lat'] = gpsLat;
    tempData['status'] = status;
    tempData['attachments'] = jsonEncode(List.from(attachments.map((e) => e)));
    tempData['is_synchronize'] = isSynchronize;
    tempData['is_new_response'] = isNewResponse;

    return tempData;
  }

  @override
  String toString() {
    return 'ResponseInspectionModel(t_inspection_id: $tInspectionId, id: $id, code: $code, tr_time: $trTime, submitted_at: $submittedAt, submitted_by: $submittedBy, submitted_by_name: $submittedByName, reassigned_to: $reassignedTo, reassigned_to_name: $reassignedToName, consulted_with: $consultedWith, consulted_with_name: $consultedWithName, description: $description, gps_lat: $gpsLat, gps_lng: $gpsLng, status: $status, attachments: $attachments, is_synchronize: $isSynchronize, is_new_response: $isNewResponse)';
  }

  @override
  List<Object?> get props => [
        tInspectionId,
        id,
        code,
        trTime,
        submittedAt,
        submittedBy,
        submittedByName,
        reassignedTo,
        reassignedToName,
        consultedWith,
        consultedWithName,
        description,
        gpsLng,
        gpsLat,
        status,
        attachments,
        isSynchronize,
        isNewResponse
      ];
}
