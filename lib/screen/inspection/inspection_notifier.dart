import 'dart:developer';

import 'package:epms/base/common/locator.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/inspection_service.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/database/service/database_attachment_inspection.dart';
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

  int _totalCreateInspection = 0;
  int get totalCreateInspection => _totalCreateInspection;

  int _totalInspectionNotClose = 0;
  int get totalInspectionNotClose => _totalInspectionNotClose;

  int _totalInspectionToDo = 0;
  int get totalInspectionToDo => _totalInspectionToDo;

  int _totalInspectionClose = 0;
  int get totalInspectionClose => _totalInspectionClose;

  int _totalInspectionNeedUpload = 0;
  int get totalInspectionNeedUpload => _totalInspectionNeedUpload;

  Future<void> initData(BuildContext context) async {
    await updateMyInspectionFromLocal();
    await updateTodoInspectionFromLocal();
    await updateSubordinateInspectionFromLocal();
    updateTotalInspection();
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

  void updateTotalInspection() {
    _totalCreateInspection = _listMyInspection.length;
    _totalInspectionNotClose = _listSubordinateInspection
        .where((element) => element.status != 'close')
        .length;
    _totalInspectionToDo = _listTodoInspection
        .where((element) => element.isSynchronize == 1)
        .length;
    _totalInspectionClose = _listSubordinateInspection
        .where((element) => element.status == 'close')
        .length;
    var myInspectionNeedUpload =
        _listMyInspection.where((element) => element.isSynchronize == 0).length;
    var myToDoInspectionNeedUpload = _listTodoInspection
        .where((element) => element.isSynchronize == 0)
        .length;
    _totalInspectionNeedUpload =
        myInspectionNeedUpload + myToDoInspectionNeedUpload;
    notifyListeners();
  }

  Future<void> getDataInspection(BuildContext context) async {
    final isInternetExist = await InspectionService.isInternetConnectionExist();
    if (isInternetExist) {
      await DatabaseSubordinateInspection.deleteTable();
      await _dialogService.showLoadingDialog(title: "Sync Data");

      await InspectionRepository().getMyInspectionClose(
        context,
        (context, data) async {
          await DatabaseTicketInspection.addAllData(data);
          await DatabaseSubordinateInspection.addAllData(data);
          await DatabaseAttachmentInspection.addAllDataNew(data);
          await updateMyInspectionFromLocal();

          await InspectionRepository().getMyInspectionNotClose(
            context,
            (context, data) async {
              await DatabaseTicketInspection.addAllData(data);
              await DatabaseSubordinateInspection.addAllData(data);
              await DatabaseAttachmentInspection.addAllDataNew(data);
              await updateMyInspectionFromLocal();

              await InspectionRepository().getToDoInspection(
                context,
                (context, data) async {
                  await DatabaseTodoInspection.addAllData(data);
                  await DatabaseAttachmentInspection.addAllDataNew(data);
                  await updateTodoInspectionFromLocal();

                  await InspectionRepository().getOnGoingInspectionClose(
                    context,
                    (context, data) async {
                      await DatabaseSubordinateInspection.addAllData(data);
                      await DatabaseAttachmentInspection.addAllDataNew(data);
                      await updateSubordinateInspectionFromLocal();

                      await InspectionRepository().getOnGoingInspectionNotClose(
                        context,
                        (context, data) async {
                          await DatabaseSubordinateInspection.addAllData(data);
                          await DatabaseAttachmentInspection.addAllDataNew(
                              data);
                          await updateSubordinateInspectionFromLocal();

                          await InspectionRepository().getToDoInspectionClose(
                            context,
                            (context, data) async {
                              await DatabaseSubordinateInspection.addAllData(
                                  data);
                              await DatabaseAttachmentInspection.addAllDataNew(
                                  data);
                              await updateSubordinateInspectionFromLocal();

                              await InspectionRepository()
                                  .getToDoInspectionNotClose(
                                context,
                                (context, data) async {
                                  await DatabaseSubordinateInspection
                                      .addAllData(data);
                                  await DatabaseAttachmentInspection
                                      .addAllDataNew(data);
                                  await updateSubordinateInspectionFromLocal();

                                  updateTotalInspection();
                                  FlushBarManager.showFlushBarSuccess(
                                    context,
                                    "Berhasil Synchronize",
                                    "Data Inspection Berhasil Diperbaharui",
                                  );
                                  log('list My Inspection : $_listMyInspection');
                                  log('list Todo Inspection : $_listTodoInspection');
                                  log('list Subordinate Inspection : $_listSubordinateInspection');
                                  _dialogService.popDialog();
                                },
                                (context, errorMessage) {
                                  FlushBarManager.showFlushBarError(context,
                                      "Gagal Synchronize", errorMessage);
                                  _dialogService.popDialog();
                                },
                              );
                            },
                            (context, errorMessage) {
                              FlushBarManager.showFlushBarError(
                                  context, "Gagal Synchronize", errorMessage);
                              _dialogService.popDialog();
                            },
                          );
                        },
                        (context, errorMessage) {
                          FlushBarManager.showFlushBarError(
                              context, "Gagal Synchronize", errorMessage);
                          _dialogService.popDialog();
                        },
                      );
                    },
                    (context, errorMessage) {
                      FlushBarManager.showFlushBarError(
                          context, "Gagal Synchronize", errorMessage);
                      _dialogService.popDialog();
                    },
                  );
                },
                (context, errorMessage) {
                  FlushBarManager.showFlushBarError(
                      context, "Gagal Synchronize", errorMessage);
                  _dialogService.popDialog();
                },
              );
            },
            (context, errorMessage) {
              FlushBarManager.showFlushBarError(
                  context, "Gagal Synchronize", errorMessage);
              _dialogService.popDialog();
            },
          );
        },
        (context, errorMessage) {
          FlushBarManager.showFlushBarError(
              context, "Gagal Synchronize", errorMessage);
          _dialogService.popDialog();
        },
      );

      // await InspectionRepository().getMyInspection(
      //   context,
      //   (context, data) async {
      //     await DatabaseTicketInspection.addAllData(data);
      //     await DatabaseAttachmentInspection.addAllDataNew(data);
      //     await updateMyInspectionFromLocal();
      //     await InspectionRepository().getToDoInspection(
      //       context,
      //       (context, data) async {
      //         await DatabaseTodoInspection.addAllData(data);
      //         await DatabaseAttachmentInspection.addAllDataNew(data);
      //         await updateTodoInspectionFromLocal();
      //         await InspectionRepository().getMySubordinate(
      //           context,
      //           (context, data) async {
      //             await DatabaseSubordinateInspection.addAllData(data);
      //             await DatabaseAttachmentInspection.addAllDataNew(data);
      //             await updateSubordinateInspectionFromLocal();
      //             updateTotalInspection();
      //             FlushBarManager.showFlushBarSuccess(
      //               context,
      //               "Berhasil Synchronize",
      //               "Data Inspection Berhasil Diperbaharui",
      //             );
      //             log('list My Inspection : $_listMyInspection');
      //             log('list Todo Inspection : $_listTodoInspection');
      //             log('list Subordinate Inspection : $_listSubordinateInspection');
      //             _dialogService.popDialog();
      //           },
      //           (context, errorMessage) {
      //             FlushBarManager.showFlushBarError(
      //               context,
      //               "Gagal Synchronize",
      //               errorMessage,
      //             );
      //             _dialogService.popDialog();
      //             log('list My Inspection : $_listMyInspection');
      //             log('list Todo Inspection : $_listTodoInspection');
      //             log('list Subordinate Inspection : $_listSubordinateInspection');
      //           },
      //         );
      //       },
      //       (context, errorMessage) async {
      //         await InspectionRepository().getMySubordinate(
      //           context,
      //           (context, data) async {
      //             await DatabaseSubordinateInspection.addAllData(data);
      //             await DatabaseAttachmentInspection.addAllDataNew(data);
      //             await updateSubordinateInspectionFromLocal();
      //             updateTotalInspection();
      //             FlushBarManager.showFlushBarSuccess(
      //               context,
      //               "Berhasil Synchronize",
      //               "Data Inspection Berhasil Diperbaharui",
      //             );
      //             _dialogService.popDialog();
      //             log('list My Inspection : $_listMyInspection');
      //             log('list Todo Inspection : $_listTodoInspection');
      //             log('list Subordinate Inspection : $_listSubordinateInspection');
      //           },
      //           (context, errorMessage) {
      //             FlushBarManager.showFlushBarError(
      //               context,
      //               "Gagal Synchronize",
      //               errorMessage,
      //             );
      //             _dialogService.popDialog();
      //             log('list My Inspection : $_listMyInspection');
      //             log('list Todo Inspection : $_listTodoInspection');
      //             log('list Subordinate Inspection : $_listSubordinateInspection');
      //           },
      //         );
      //       },
      //     );
      //   },
      //   (context, errorMessage) async {
      //     await InspectionRepository().getToDoInspection(
      //       context,
      //       (context, data) async {
      //         await DatabaseTodoInspection.addAllData(data);
      //         await DatabaseAttachmentInspection.addAllDataNew(data);
      //         await updateTodoInspectionFromLocal();
      //         await InspectionRepository().getMySubordinate(
      //           context,
      //           (context, data) async {
      //             await DatabaseSubordinateInspection.addAllData(data);
      //             await DatabaseAttachmentInspection.addAllDataNew(data);
      //             await updateSubordinateInspectionFromLocal();
      //             updateTotalInspection();
      //             FlushBarManager.showFlushBarSuccess(
      //               context,
      //               "Berhasil Synchronize",
      //               "Data Inspection Berhasil Diperbaharui",
      //             );
      //             _dialogService.popDialog();
      //             log('list My Inspection : $_listMyInspection');
      //             log('list Todo Inspection : $_listTodoInspection');
      //             log('list Subordinate Inspection : $_listSubordinateInspection');
      //           },
      //           (context, errorMessage) {
      //             FlushBarManager.showFlushBarError(
      //               context,
      //               "Gagal Synchronize",
      //               errorMessage,
      //             );
      //             _dialogService.popDialog();
      //             log('list My Inspection : $_listMyInspection');
      //             log('list Todo Inspection : $_listTodoInspection');
      //             log('list Subordinate Inspection : $_listSubordinateInspection');
      //           },
      //         );
      //       },
      //       (context, errorMessage) async {
      //         await InspectionRepository().getMySubordinate(
      //           context,
      //           (context, data) async {
      //             await DatabaseSubordinateInspection.addAllData(data);
      //             await DatabaseAttachmentInspection.addAllDataNew(data);
      //             await updateSubordinateInspectionFromLocal();
      //             updateTotalInspection();
      //             FlushBarManager.showFlushBarSuccess(
      //               context,
      //               "Berhasil Synchronize",
      //               "Data Inspection Berhasil Diperbaharui",
      //             );
      //             _dialogService.popDialog();
      //             log('list My Inspection : $_listMyInspection');
      //             log('list Todo Inspection : $_listTodoInspection');
      //             log('list Subordinate Inspection : $_listSubordinateInspection');
      //           },
      //           (context, errorMessage) {
      //             FlushBarManager.showFlushBarError(
      //               context,
      //               "Gagal Synchronize",
      //               errorMessage,
      //             );
      //             _dialogService.popDialog();
      //             log('list My Inspection : $_listMyInspection');
      //             log('list Todo Inspection : $_listTodoInspection');
      //             log('list Subordinate Inspection : $_listSubordinateInspection');
      //           },
      //         );
      //       },
      //     );
      //   },
      // );
    } else {
      await updateMyInspectionFromLocal();
      await updateTodoInspectionFromLocal();
      await updateSubordinateInspectionFromLocal();
      updateTotalInspection();
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
              await DatabaseTicketInspection.deleteTicketByCode(
                  ticketInspection);
              await DatabaseAttachmentInspection.deleteInspectionByCode(
                  ticketInspection);
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
              final responseInspection = toDoInspection.responses.last;

              await InspectionRepository().createResponseInspection(
                context,
                toDoInspection,
                responseInspection,
                (context, successMessage) async {
                  await DatabaseTodoInspection.deleteTodoByCode(toDoInspection);
                  await DatabaseAttachmentInspection.deleteInspectionByCode(
                    toDoInspection,
                  );
                  await Future.delayed(const Duration(seconds: 1));
                  log('Response Inspection Code : ${responseInspection.code} $successMessage');
                },
                (context, errorMessage) async {
                  await Future.delayed(const Duration(seconds: 1));
                  log('Response Inspection Code : ${responseInspection.code} $errorMessage');
                },
              );
            }
          }

          _dialogService.popDialog();
          notifyListeners();
          await getDataInspection(context);
        } else {
          _dialogService.popDialog();
          notifyListeners();
          await getDataInspection(context);
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
                await DatabaseTodoInspection.deleteTodoByCode(toDoInspection);
                await DatabaseAttachmentInspection.deleteInspectionByCode(
                  toDoInspection,
                );
                await Future.delayed(const Duration(seconds: 1));
                log('Response Inspection Code : ${responseInspection.code} $successMessage');
              },
              (context, errorMessage) async {
                await Future.delayed(const Duration(seconds: 1));
                log('Response Inspection Code : ${responseInspection.code} $errorMessage');
              },
            );
          }
        }

        _dialogService.popDialog();
        notifyListeners();
        await getDataInspection(context);
      } else {
        _dialogService.popDialog();
        notifyListeners();
        await getDataInspection(context);
      }
    } else {
      FlushBarManager.showFlushBarWarning(
        context,
        "Gagal Upload",
        "Anda tidak memiliki akses internet",
      );
    }
  }

  Future<void> initUploadAndSynch(BuildContext context) async {
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
              await DatabaseTicketInspection.deleteTicketByCode(
                  ticketInspection);
              await DatabaseAttachmentInspection.deleteInspectionByCode(
                  ticketInspection);
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
              final responseInspection = toDoInspection.responses.last;

              await InspectionRepository().createResponseInspection(
                context,
                toDoInspection,
                responseInspection,
                (context, successMessage) async {
                  await DatabaseTodoInspection.deleteTodoByCode(toDoInspection);
                  await DatabaseAttachmentInspection.deleteInspectionByCode(
                    toDoInspection,
                  );
                  await Future.delayed(const Duration(seconds: 1));
                  log('Response Inspection Code : ${responseInspection.code} $successMessage');
                },
                (context, errorMessage) async {
                  await Future.delayed(const Duration(seconds: 1));
                  log('Response Inspection Code : ${responseInspection.code} $errorMessage');
                },
              );
            }
          }

          _dialogService.popDialog();
          notifyListeners();
          await getDataInspection(context);
        } else {
          _dialogService.popDialog();
          notifyListeners();
          await getDataInspection(context);
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
                await DatabaseTodoInspection.deleteTodoByCode(toDoInspection);
                await DatabaseAttachmentInspection.deleteInspectionByCode(
                  toDoInspection,
                );
                await Future.delayed(const Duration(seconds: 1));
                log('Response Inspection Code : ${responseInspection.code} $successMessage');
              },
              (context, errorMessage) async {
                await Future.delayed(const Duration(seconds: 1));
                log('Response Inspection Code : ${responseInspection.code} $errorMessage');
              },
            );
          }
        }

        _dialogService.popDialog();
        notifyListeners();
        await getDataInspection(context);
      } else {
        _dialogService.popDialog();
        notifyListeners();
        await getDataInspection(context);
      }
    } else {
      await updateMyInspectionFromLocal();
      await updateTodoInspectionFromLocal();
      await updateSubordinateInspectionFromLocal();
      updateTotalInspection();
      log('list My Inspection : $_listMyInspection');
      log('list Todo Inspection : $_listTodoInspection');
      log('list Subordinate Inspection : $_listSubordinateInspection');
    }
  }
}
