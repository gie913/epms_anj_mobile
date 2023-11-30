import 'dart:developer';

import 'package:epms/base/common/routes.dart';
import 'package:epms/base/ui/palette.dart';
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
          padding: EdgeInsets.all(16),
          child: provider.listTodoInspection.isNotEmpty
              ? ListView.builder(
                  itemCount: provider.listTodoInspection.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final data = provider.listTodoInspection[index];
                    return InspectionItem(
                      bgColor: data.statusCategory == 'not_yet'
                          ? Colors.yellow.shade800
                          : Palette.primaryColorProd,
                      data: data,
                      onTap: () async {
                        log('is_synchronize : ${data.isSynchronize}');
                        log('status : ${data.status}');

                        if (data.statusCategory == 'done') {
                          provider.navigationService.push(
                            Routes.INSPECTION_DETAIL,
                            arguments: data,
                          );
                        } else if (data.statusCategory == 'not_yet') {
                          if (data.status == 'waiting' ||
                              data.status == 'on_progress' ||
                              data.status == 'revise') {
                            await provider.navigationService.push(
                              Routes.INSPECTION_ASSIGNMENT_DETAIL,
                              arguments: data,
                            );
                            await provider.updateTodoInspectionFromLocal();
                          } else if (data.status == 'reassign' ||
                              data.status == 'complete' ||
                              data.status == 'need_consultation' ||
                              data.status == 'consulted' ||
                              data.status == 'close') {
                            await provider.navigationService.push(
                              Routes.INSPECTION_APPROVAL,
                              arguments: data,
                            );
                            await provider.updateTodoInspectionFromLocal();
                          }
                        }

                        // if (ConvertHelper.intToBool(data.isSynchronize)) {
                        //   if (data.status == 'waiting' ||
                        //       data.status == 'on_progress' ||
                        //       data.status == 'revise') {
                        //     await provider.navigationService.push(
                        //       Routes.INSPECTION_ASSIGNMENT_DETAIL,
                        //       arguments: data,
                        //     );
                        //     await provider.updateTodoInspectionFromLocal();
                        //   } else if (data.status == 'reassign' ||
                        //       data.status == 'complete' ||
                        //       data.status == 'need_consultation' ||
                        //       data.status == 'consulted' ||
                        //       data.status == 'close') {
                        //     await provider.navigationService.push(
                        //       Routes.INSPECTION_APPROVAL,
                        //       arguments: data,
                        //     );
                        //     await provider.updateTodoInspectionFromLocal();
                        //   }
                        // } else {
                        //   if (data.status == 'waiting' ||
                        //       data.status == 'on_progress' ||
                        //       data.status == 'reassign' ||
                        //       data.status == 'complete') {
                        //     await provider.navigationService.push(
                        //       Routes.INSPECTION_ASSIGNMENT_DETAIL,
                        //       arguments: data,
                        //     );
                        //     await provider.updateTodoInspectionFromLocal();
                        //   } else if (data.status == 'accept-reassign' ||
                        //       data.status == 'revise' ||
                        //       data.status == 'need_consultation' ||
                        //       data.status == 'consulted' ||
                        //       data.status == 'close') {
                        //     await provider.navigationService.push(
                        //       Routes.INSPECTION_APPROVAL,
                        //       arguments: data,
                        //     );
                        //     await provider.updateTodoInspectionFromLocal();
                        //   }
                        // }
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
