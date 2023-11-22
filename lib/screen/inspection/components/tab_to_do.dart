import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/database/service/database_todo_inspection.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/screen/inspection/components/inspection_item.dart';
import 'package:flutter/material.dart';

class TabToDo extends StatefulWidget {
  const TabToDo({super.key, this.listToDo = const []});

  final List<TicketInspectionModel> listToDo;

  @override
  State<TabToDo> createState() => _TabToDoState();
}

class _TabToDoState extends State<TabToDo> {
  NavigatorService _navigationService = locator<NavigatorService>();

  List<TicketInspectionModel> listToDo = [];

  @override
  void initState() {
    listToDo = widget.listToDo;
    setState(() {});
    super.initState();
  }

  Future<void> getTodoInspectionFromLocal() async {
    final data = await DatabaseTodoInspection.selectData();
    listToDo = data;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: listToDo.isNotEmpty
          ? ListView.builder(
              itemCount: listToDo.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final data = listToDo[index];
                return InspectionItem(
                  data: data,
                  onTap: () async {
                    if (data.status == 'reassign' ||
                        data.status == 'complete' ||
                        data.status == 'close' ||
                        data.status == 'need_consultation') {
                      await _navigationService.push(
                        Routes.INSPECTION_APPROVAL,
                        arguments: data,
                      );
                      await getTodoInspectionFromLocal();
                    } else {
                      await _navigationService.push(
                        Routes.INSPECTION_ASSIGNMENT_DETAIL,
                        arguments: data,
                      );
                      await getTodoInspectionFromLocal();
                    }
                  },
                );
              },
            )
          : Center(child: Text('Belum Ada Data')),
    );
  }
}
