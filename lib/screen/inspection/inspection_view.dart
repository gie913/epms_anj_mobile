import 'dart:developer';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/inspection_service.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/database/service/database_todo_inspection.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/screen/inspection/components/tab_to_do.dart';
import 'package:epms/screen/inspection/components/tab_my_inspection.dart';
import 'package:epms/screen/inspection/inspection_repository.dart';
import 'package:flutter/material.dart';

class InspectionView extends StatefulWidget {
  const InspectionView({super.key});

  @override
  State<InspectionView> createState() => _InspectionViewState();
}

class _InspectionViewState extends State<InspectionView> {
  NavigatorService _navigationService = locator<NavigatorService>();

  List<TicketInspectionModel> listMyInspection = [];
  List<TicketInspectionModel> listToDo = [];
  int tabBarIndex = 0;

  @override
  void initState() {
    getMyInspection();
    getToDoInspection();
    super.initState();
  }

  Future<void> getMyInspectionFromLocal() async {
    final data = await DatabaseTicketInspection.selectData();
    listMyInspection = data;
    setState(() {});
  }

  Future<void> getMyInspection() async {
    final isInternetExist = await InspectionService.isInternetConnectionExist();
    if (isInternetExist) {
      await InspectionRepository().getMyInspection(
        context,
        (context, data) async {
          listMyInspection = data;
          DatabaseTicketInspection.deleteTable();
          await DatabaseTicketInspection.addAllData(listMyInspection);
          setState(() {});
        },
        (context, errorMessage) {},
      );
    }
  }

  Future<void> getToDoInspection() async {
    final isInternetExist = await InspectionService.isInternetConnectionExist();
    if (isInternetExist) {
      await InspectionRepository().getToDoInspection(
        context,
        (context, data) async {
          listToDo = data;
          DatabaseTodoInspection.deleteTable();
          await DatabaseTodoInspection.addAllData(listToDo);
          setState(() {});
        },
        (context, errorMessage) {},
      );
    }
  }

  Future<void> uploadAndSynch() async {
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

          await getMyInspection();
          await getToDoInspection();
        } else {
          await getMyInspection();
          await getToDoInspection();
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

        await getMyInspection();
        await getToDoInspection();
      } else {
        await getMyInspection();
        await getToDoInspection();
      }
    } else {
      FlushBarManager.showFlushBarWarning(
        context,
        "Gagal Upload",
        "Anda tidak memiliki akses internet",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: MediaQuery(
        data: Style.mediaQueryText(context),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Inspection'),
            bottom: TabBar(
              enableFeedback: true,
              onTap: (value) {
                tabBarIndex = value;
                setState(() {});
                getMyInspection();
                getToDoInspection();
              },
              tabs: [
                Tab(icon: Text("My Inspection")),
                Tab(icon: Text("To Do")),
              ],
            ),
          ),
          body: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    TabMyInspection(listMyInspection: listMyInspection),
                    TabToDo(listToDo: listToDo),
                  ],
                ),
              ),
              if (tabBarIndex == 0)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: InkWell(
                    onTap: () async {
                      await _navigationService.push(Routes.INSPECTION_FORM);
                      await getMyInspectionFromLocal();
                    },
                    child: Card(
                      color: Palette.primaryColorProd,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "CREATE INSPECTION",
                            style: Style.whiteBold14,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: InkWell(
                  onTap: () {
                    uploadAndSynch();
                  },
                  child: Card(
                    color: Colors.green,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "UPLOAD & SYNCH",
                          style: Style.whiteBold14,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
