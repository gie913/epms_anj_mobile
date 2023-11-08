import 'dart:developer';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
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
    log('Init Tab To Do');
    listToDo = widget.listToDo;
    setState(() {});
    super.initState();
  }

  Future<void> updateInspection() async {
    final data = await DatabaseTicketInspection.selectData();
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
                    if (data.status == 'Re-Assign' ||
                        data.status == 'Complete' ||
                        data.status == 'Close' ||
                        data.status == 'Need Consultation') {
                      await _navigationService.push(
                        Routes.INSPECTION_APPROVAL,
                        arguments: data,
                      );
                      await updateInspection();
                    } else {
                      await _navigationService.push(
                        Routes.INSPECTION_ASSIGNMENT_DETAIL,
                        arguments: data,
                      );
                      await updateInspection();
                    }

                    // if (index == 2 || index == 3) {
                    //   _navigationService.push(
                    //     Routes.INSPECTION_APPROVAL,
                    //     arguments: data,
                    //   );
                    // } else {
                    //   _navigationService.push(
                    //     Routes.INSPECTION_ASSIGNMENT_DETAIL,
                    //     arguments: data,
                    //   );
                    // }
                  },
                );
              },
            )
          : Center(child: Text('Belum Ada Data')),
    );
  }
}
