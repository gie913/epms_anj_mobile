import 'package:epms/model/ticket_inspection_model.dart';

class TodoInspectionData {
  const TodoInspectionData({
    this.notYet = const [],
    this.done = const [],
  });

  factory TodoInspectionData.fromJson(Map<String, dynamic> json) =>
      TodoInspectionData(
        notYet: json['not_yet'] != null
            ? List<TicketInspectionModel>.from((json['not_yet'] as List).map(
                (e) {
                  return TicketInspectionModel.fromJson(e);
                },
              ))
            : const <TicketInspectionModel>[],
        done: json['done'] != null
            ? List<TicketInspectionModel>.from((json['done'] as List).map(
                (e) {
                  return TicketInspectionModel.fromJson(e);
                },
              ))
            : const <TicketInspectionModel>[],
      );

  final List<TicketInspectionModel> notYet;
  final List<TicketInspectionModel> done;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['not_yet'] = List.from(notYet.map((e) => e.toJson()));
    tempData['done'] = List.from(done.map((e) => e.toJson()));

    return tempData;
  }

  @override
  String toString() {
    return 'TodoInspectionData(not_yet: $notYet, done: $done)';
  }
}
