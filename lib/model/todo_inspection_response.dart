import 'package:epms/model/todo_inspection_data.dart';

class TodoInspectionResponse {
  const TodoInspectionResponse({
    this.success = false,
    this.message = '',
    this.data = const TodoInspectionData(),
  });

  factory TodoInspectionResponse.fromJson(Map<String, dynamic> json) =>
      TodoInspectionResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] != null
            ? TodoInspectionData.fromJson(json['data'])
            : const TodoInspectionData(),
      );

  final bool success;
  final String message;
  final TodoInspectionData data;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['success'] = success;
    tempData['message'] = message;
    tempData['data'] = data.toJson();

    return tempData;
  }

  @override
  String toString() {
    return 'TodoInspectionResponse(success: $success, message: $message, data: $data)';
  }
}
