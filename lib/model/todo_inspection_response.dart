import 'package:epms/model/ticket_inspection_model.dart';

class TodoInspectionResponse {
  const TodoInspectionResponse({
    this.success = false,
    this.message = '',
    this.data = const [],
  });

  factory TodoInspectionResponse.fromJson(Map<String, dynamic> json) =>
      TodoInspectionResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] != null
            ? List<TicketInspectionModel>.from((json['data'] as List).map(
                (e) {
                  return TicketInspectionModel.fromJson(e);
                },
              ))
            : const <TicketInspectionModel>[],
      );

  final bool success;
  final String message;
  final List<TicketInspectionModel> data;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['success'] = success;
    tempData['message'] = message;
    tempData['data'] = List.from(data.map((e) => e.toJson()));

    return tempData;
  }

  @override
  String toString() {
    return 'TodoInspectionResponse(success: $success, message: $message, data: $data)';
  }
}
