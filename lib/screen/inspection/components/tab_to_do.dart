import 'dart:developer';

import 'package:epms/base/common/routes.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/database/helper/convert_helper.dart';
import 'package:epms/database/service/database_response_inspection.dart';
import 'package:epms/database/service/database_todo_inspection.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/screen/inspection/components/inspection_item.dart';
import 'package:epms/screen/inspection/inspection_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabToDo extends StatefulWidget {
  const TabToDo({super.key});

  @override
  State<TabToDo> createState() => _TabToDoState();
}

class _TabToDoState extends State<TabToDo> {
  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionNotifier>(
      builder: (context, provider, _) {
        return Padding(
          padding: EdgeInsets.all(12),
          child: provider.listTodoInspection.isNotEmpty
              ? ListView.builder(
                  itemCount: provider.listTodoInspection.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final data = provider.listTodoInspection[index];
                    return InspectionItem(
                      bgColor: ConvertHelper.intToBool(data.isSynchronize)
                          ? Colors.yellow.shade800
                          : Palette.primaryColorProd,
                      data: data,
                      onTap: () async {
                        log('is_synchronize : ${data.isSynchronize}');
                        log('status : ${data.status}');
                        final inspectionTemp = TicketInspectionModel(
                          assignee: data.assignee,
                          assigneeId: data.assigneeId,
                          attachments: data.attachments,
                          closedAt: data.closedAt,
                          closedBy: data.closedBy,
                          closedByName: data.closedByName,
                          code: data.code,
                          description: data.description,
                          gpsLat: data.gpsLat,
                          gpsLng: data.gpsLng,
                          id: data.id,
                          isClosed: data.isClosed,
                          isNewResponse: 0,
                          isSynchronize: data.isSynchronize,
                          mCompanyAlias: data.mCompanyAlias,
                          mCompanyId: data.mCompanyId,
                          mCompanyName: data.mCompanyName,
                          mDivisionEstateCode: data.mDivisionEstateCode,
                          mDivisionId: data.mDivisionId,
                          mDivisionName: data.mDivisionName,
                          mTeamId: data.mTeamId,
                          mTeamName: data.mTeamName,
                          status: data.status,
                          submittedAt: data.submittedAt,
                          submittedBy: data.submittedBy,
                          submittedByName: data.submittedByName,
                          trTime: data.trTime,
                          usingGps: data.usingGps,
                        );

                        if (!ConvertHelper.intToBool(data.isSynchronize)) {
                          await DatabaseTodoInspection.updateData(
                            inspectionTemp,
                          );
                          await DatabaseResponseInspection
                              .updateResponseInspection(inspectionTemp.id);
                          await provider.updateTodoInspectionFromLocal();

                          await provider.navigationService.push(
                            Routes.INSPECTION_DETAIL,
                            arguments: data,
                          );
                        } else {
                          if (data.status == 'waiting' ||
                              data.status == 'on_progress' ||
                              data.status == 'revise') {
                            log('cek ini : ${data.isNewResponse}');
                            await DatabaseTodoInspection.updateData(
                              inspectionTemp,
                            );
                            await DatabaseResponseInspection
                                .updateResponseInspection(inspectionTemp.id);

                            await provider.navigationService.push(
                              Routes.INSPECTION_ASSIGNMENT_DETAIL,
                              arguments: data,
                            );

                            await provider.updateTodoInspectionFromLocal();
                            await provider.updateMyInspectionFromLocal();
                            await provider
                                .updateSubordinateInspectionFromLocal();
                            provider.updateTotalInspection();
                          } else if (data.status == 'reassign' ||
                              data.status == 'complete' ||
                              data.status == 'need_consultation' ||
                              data.status == 'consulted' ||
                              data.status == 'close') {
                            await DatabaseTodoInspection.updateData(
                              inspectionTemp,
                            );
                            await DatabaseResponseInspection
                                .updateResponseInspection(inspectionTemp.id);

                            await provider.navigationService.push(
                              Routes.INSPECTION_APPROVAL,
                              arguments: data,
                            );

                            await provider.updateTodoInspectionFromLocal();
                            await provider.updateMyInspectionFromLocal();
                            await provider
                                .updateSubordinateInspectionFromLocal();
                            provider.updateTotalInspection();
                          }
                        }
                      },
                    );
                  },
                )
              : Center(child: Text('Belum Ada Data')),
        );
      },
    );
  }
}
