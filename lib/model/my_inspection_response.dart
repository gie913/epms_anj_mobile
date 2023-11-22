import 'package:epms/model/ticket_inspection_model.dart';

class MyInspectionResponse {
  const MyInspectionResponse({
    this.success = false,
    this.message = '',
    this.data = const [],
  });

  factory MyInspectionResponse.fromJson(Map<String, dynamic> json) =>
      MyInspectionResponse(
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
    return 'MyInspectionResponse(success: $success, message: $message, data: $data)';
  }
}
