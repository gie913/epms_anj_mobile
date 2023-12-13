import 'dart:developer';

import 'package:epms/base/common/locator.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/inspection_service.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/database/service/database_subordinate_inspection.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/database/service/database_todo_inspection.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/screen/inspection/inspection_repository.dart';
import 'package:flutter/material.dart';

class InspectionNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();
  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();
  DialogService get dialogService => _dialogService;

  List<TicketInspectionModel> _listMyInspection = [];
  List<TicketInspectionModel> get listMyInspection => _listMyInspection;

  List<TicketInspectionModel> _listTodoInspection = [];
  List<TicketInspectionModel> get listTodoInspection => _listTodoInspection;

  List<TicketInspectionModel> _listSubordinateInspection = [];
  List<TicketInspectionModel> get listSubordinateInspection =>
      _listSubordinateInspection;

  Future<void> initData(BuildContext context) async {
    await updateMyInspectionFromLocal();
    await updateTodoInspectionFromLocal();
    await updateSubordinateInspectionFromLocal();
    // await getDataInspection(context);
  }

  Future<void> updateMyInspectionFromLocal() async {
    final data = await DatabaseTicketInspection.selectData();
    _listMyInspection = data;
    notifyListeners();
  }

  Future<void> updateTodoInspectionFromLocal() async {
    final data = await DatabaseTodoInspection.selectData();
    _listTodoInspection = data;
    notifyListeners();
  }

  Future<void> updateSubordinateInspectionFromLocal() async {
    final data = await DatabaseSubordinateInspection.selectData();
    _listSubordinateInspection = data;
    notifyListeners();
  }

  Future<void> getDataInspection(BuildContext context) async {
    final isInternetExist = await InspectionService.isInternetConnectionExist();
    if (isInternetExist) {
      await InspectionRepository().getMyInspection(
        context,
        (context, data) async {
          await DatabaseTicketInspection.addAllData(data);
          await updateMyInspectionFromLocal();
          await InspectionRepository().getToDoInspection(
            context,
            (context, data) async {
              await DatabaseTodoInspection.addAllData(data);
              await updateTodoInspectionFromLocal();
              await InspectionRepository().getMySubordinate(
                context,
                (context, data) async {
                  await DatabaseSubordinateInspection.addAllData(data);
                  await updateSubordinateInspectionFromLocal();
                  log('list My Inspection : $_listMyInspection');
                  log('list Todo Inspection : $_listTodoInspection');
                  log('list Subordinate Inspection : $_listSubordinateInspection');
                },
                (context, errorMessage) {
                  log('list My Inspection : $_listMyInspection');
                  log('list Todo Inspection : $_listTodoInspection');
                  log('list Subordinate Inspection : $_listSubordinateInspection');
                },
              );
            },
            (context, errorMessage) async {
              await InspectionRepository().getMySubordinate(
                context,
                (context, data) async {
                  await DatabaseSubordinateInspection.addAllData(data);
                  await updateSubordinateInspectionFromLocal();
                  log('list My Inspection : $_listMyInspection');
                  log('list Todo Inspection : $_listTodoInspection');
                  log('list Subordinate Inspection : $_listSubordinateInspection');
                },
                (context, errorMessage) {
                  log('list My Inspection : $_listMyInspection');
                  log('list Todo Inspection : $_listTodoInspection');
                  log('list Subordinate Inspection : $_listSubordinateInspection');
                },
              );
            },
          );
        },
        (context, errorMessage) async {
          await InspectionRepository().getToDoInspection(
            context,
            (context, data) async {
              await DatabaseTodoInspection.addAllData(data);
              await updateTodoInspectionFromLocal();
              await InspectionRepository().getMySubordinate(
                context,
                (context, data) async {
                  await DatabaseSubordinateInspection.addAllData(data);
                  await updateSubordinateInspectionFromLocal();
                  log('list My Inspection : $_listMyInspection');
                  log('list Todo Inspection : $_listTodoInspection');
                  log('list Subordinate Inspection : $_listSubordinateInspection');
                },
                (context, errorMessage) {
                  log('list My Inspection : $_listMyInspection');
                  log('list Todo Inspection : $_listTodoInspection');
                  log('list Subordinate Inspection : $_listSubordinateInspection');
                },
              );
            },
            (context, errorMessage) async {
              await InspectionRepository().getMySubordinate(
                context,
                (context, data) async {
                  await DatabaseSubordinateInspection.addAllData(data);
                  await updateSubordinateInspectionFromLocal();
                  log('list My Inspection : $_listMyInspection');
                  log('list Todo Inspection : $_listTodoInspection');
                  log('list Subordinate Inspection : $_listSubordinateInspection');
                },
                (context, errorMessage) {
                  log('list My Inspection : $_listMyInspection');
                  log('list Todo Inspection : $_listTodoInspection');
                  log('list Subordinate Inspection : $_listSubordinateInspection');
                },
              );
            },
          );
        },
      );
    } else {
      await updateMyInspectionFromLocal();
      await updateTodoInspectionFromLocal();
      await updateSubordinateInspectionFromLocal();
      log('list My Inspection : $_listMyInspection');
      log('list Todo Inspection : $_listTodoInspection');
      log('list Subordinate Inspection : $_listSubordinateInspection');
    }
  }

  Future<void> uploadAndSynch(BuildContext context) async {
    final dataMyInspection =
        await DatabaseTicketInspection.selectDataNeedUpload();
    final dataToDoInspection =
        await DatabaseTodoInspection.selectDataNeedUpload();
    log('data my inspection unupload : $dataMyInspection');
    log('data todo inspection unupload : $dataToDoInspection');
    final isInternetExist = await InspectionService.isInternetConnectionExist();

    if (isInternetExist) {
      _dialogService.showLoadingDialog(title: "Upload Data");
      if (dataMyInspection.isNotEmpty) {
        for (final ticketInspection in dataMyInspection) {
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
              if (errorMessage == 'Tidak Ada Koneksi Internet') {
                _dialogService.popDialog();
              }
            },
          );
        }

        if (dataToDoInspection.isNotEmpty) {
          for (final toDoInspection in dataToDoInspection) {
            if (toDoInspection.responses.isNotEmpty) {
              final responseInspection = toDoInspection.responses.last;

              await InspectionRepository().createResponseInspection(
                context,
                toDoInspection,
                responseInspection,
                (context, successMessage) async {
                  await Future.delayed(const Duration(seconds: 1));
                  log('Response Inspection Code : ${responseInspection.code} $successMessage');
                },
                (context, errorMessage) async {
                  await Future.delayed(const Duration(seconds: 1));
                  log('Response Inspection Code : ${responseInspection.code} $errorMessage');
                  if (errorMessage == 'Tidak Ada Koneksi Internet') {
                    _dialogService.popDialog();
                  }
                },
              );
            }
          }

          await getDataInspection(context);
          _dialogService.popDialog();
        } else {
          await getDataInspection(context);
          _dialogService.popDialog();
        }
      } else if (dataToDoInspection.isNotEmpty) {
        for (final toDoInspection in dataToDoInspection) {
          if (toDoInspection.responses.isNotEmpty) {
            final responseInspection = toDoInspection.responses.last;

            await InspectionRepository().createResponseInspection(
              context,
              toDoInspection,
              responseInspection,
              (context, successMessage) async {
                await Future.delayed(const Duration(seconds: 1));
                log('Response Inspection Code : ${responseInspection.code} $successMessage');
              },
              (context, errorMessage) async {
                await Future.delayed(const Duration(seconds: 1));
                log('Response Inspection Code : ${responseInspection.code} $errorMessage');
                if (errorMessage == 'Tidak Ada Koneksi Internet') {
                  _dialogService.popDialog();
                }
              },
            );
          }
        }

        await getDataInspection(context);
        _dialogService.popDialog();
      } else {
        await getDataInspection(context);
        _dialogService.popDialog();
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
