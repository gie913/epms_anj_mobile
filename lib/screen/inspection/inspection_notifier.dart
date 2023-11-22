import 'dart:developer';

import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/inspection_service.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/database/service/database_todo_inspection.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/screen/inspection/inspection_repository.dart';
import 'package:flutter/material.dart';

class InspectionNotifier extends ChangeNotifier {
  List<TicketInspectionModel> _listMyInspection = [];
  List<TicketInspectionModel> _listTodoInspection = [];

  List<TicketInspectionModel> get listMyInspection => _listMyInspection;
  List<TicketInspectionModel> get listTodoInspection => _listTodoInspection;

  Future<void> getMyInspection(BuildContext context) async {
    final isInternetExist = await InspectionService.isInternetConnectionExist();
    if (isInternetExist) {
      await InspectionRepository().getMyInspection(
        context,
        (context, data) async {
          _listMyInspection = data;
          DatabaseTicketInspection.deleteTable();
          await DatabaseTicketInspection.addAllData(_listMyInspection);
          notifyListeners();
        },
        (context, errorMessage) {},
      );
    }
  }

  Future<void> getTodoInspection(BuildContext context) async {
    final isInternetExist = await InspectionService.isInternetConnectionExist();
    if (isInternetExist) {
      await InspectionRepository().getToDoInspection(
        context,
        (context, data) async {
          _listTodoInspection = data;
          DatabaseTodoInspection.deleteTable();
          await DatabaseTodoInspection.addAllData(_listTodoInspection);
          notifyListeners();
        },
        (context, errorMessage) {},
      );
    }
  }

  Future<void> uploadAndSynch(BuildContext context) async {
    final data = await DatabaseTicketInspection.selectData();
    final dataToDoInspection = await DatabaseTodoInspection.selectData();
    final isInternetExist = await InspectionService.isInternetConnectionExist();

    if (isInternetExist) {
      if (data.isNotEmpty) {
        for (final ticketInspection in data) {
          await InspectionRepository().createInspection(
            context,
            ticketInspection,
            (context, successMessage) async {
              await Future.delayed(const Duration(seconds: 1));
              log('Ticket Inspection Code : ${ticketInspection.code} $successMessage');
            },
            (context, errorMessage) async {
              await Future.delayed(const Duration(seconds: 1));
              log('Ticket Inspection Code : ${ticketInspection.code} $errorMessage');
            },
          );
        }

        if (dataToDoInspection.isNotEmpty) {
          for (final toDoInspection in dataToDoInspection) {
            if (toDoInspection.responses.isNotEmpty) {
              await InspectionRepository().createResponseInspection(
                context,
                toDoInspection,
                (context, successMessage) async {
                  await Future.delayed(const Duration(seconds: 1));
                  log('ToDo Inspection Code : ${toDoInspection.code} $successMessage');
                },
                (context, errorMessage) async {
                  await Future.delayed(const Duration(seconds: 1));
                  log('ToDo Inspection Code : ${toDoInspection.code} $errorMessage');
                },
              );
            }
          }

          await getMyInspection(context);
          await getTodoInspection(context);
        } else {
          await getMyInspection(context);
          await getTodoInspection(context);
        }
      } else if (dataToDoInspection.isNotEmpty) {
        for (final toDoInspection in dataToDoInspection) {
          if (toDoInspection.responses.isNotEmpty) {
            await InspectionRepository().createResponseInspection(
              context,
              toDoInspection,
              (context, successMessage) async {
                await Future.delayed(const Duration(seconds: 1));
                log('ToDo Inspection Code : ${toDoInspection.code} $successMessage');
              },
              (context, errorMessage) async {
                await Future.delayed(const Duration(seconds: 1));
                log('ToDo Inspection Code : ${toDoInspection.code} $errorMessage');
              },
            );
          }
        }

        await getMyInspection(context);
        await getTodoInspection(context);
      } else {
        await getMyInspection(context);
        await getTodoInspection(context);
      }
    } else {
      FlushBarManager.showFlushBarWarning(
        context,
        "Gagal Upload",
        "Anda tidak memiliki akses internet",
      );
    }
  }
}
