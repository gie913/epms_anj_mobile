import 'package:epms/model/response_inspection_model.dart';
import 'package:epms/model/ticket_inspection_model.dart';

class TicketInspectionDataModel {
  const TicketInspectionDataModel({
    this.inspection = const [],
    this.responses = const [],
  });

  factory TicketInspectionDataModel.fromJson(Map<String, dynamic> json) =>
      TicketInspectionDataModel(
        inspection: json['inspection'] != null
            ? List<TicketInspectionModel>.from((json['inspection'] as List).map(
                (e) {
                  return TicketInspectionModel.fromJson(e);
                },
              ))
            : const <TicketInspectionModel>[],
        responses: json['responses'] != null
            ? List<ResponseInspectionModel>.from(
                (json['responses'] as List).map(
                (e) {
                  return ResponseInspectionModel.fromJson(e);
                },
              ))
            : const <ResponseInspectionModel>[],
      );

  final List<TicketInspectionModel> inspection;
  final List<ResponseInspectionModel> responses;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['inspection'] = List.from(inspection.map((e) => e.toJson()));
    tempData['responses'] = List.from(responses.map((e) => e.toJson()));

    return tempData;
  }

  @override
  String toString() {
    return 'TicketInspectionDataModel(inspection: $inspection, responses: $responses)';
  }
}
