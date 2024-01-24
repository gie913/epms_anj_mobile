import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/database/helper/convert_helper.dart';
import 'package:epms/database/service/database_subordinate_inspection.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/screen/inspection/components/input_search.dart';
import 'package:epms/screen/inspection/components/inspection_item.dart';
import 'package:epms/screen/inspection/inspection_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabOnGoing extends StatefulWidget {
  const TabOnGoing({super.key});

  @override
  State<TabOnGoing> createState() => _TabOnGoingState();
}

class _TabOnGoingState extends State<TabOnGoing> {
  NavigatorService _navigationService = locator<NavigatorService>();
  final searchController = TextEditingController();
  List<TicketInspectionModel> listInspection = const [];
  List<TicketInspectionModel> listSearchInspection = const [];

  void getInspection() {
    final data = context.read<InspectionNotifier>().listSubordinateInspection;
    listInspection = data;
    listSearchInspection = listInspection;
    setState(() {});
  }

  void searchUser(String keyword) {
    setState(() {
      final temp = <TicketInspectionModel>[];

      if (keyword.isEmpty) {
        listSearchInspection.addAll(listInspection);
      }

      for (final item in listInspection) {
        if (item.submittedByName
                .toLowerCase()
                .contains(keyword.toLowerCase()) ||
            item.assignee.toLowerCase().contains(keyword.toLowerCase()) ||
            item.closedByName.toLowerCase().contains(keyword.toLowerCase()) ||
            item.code.toLowerCase().contains(keyword.toLowerCase()) ||
            item.status.toLowerCase().contains(keyword.toLowerCase())) {
          temp.add(item);
        }
      }

      listSearchInspection = temp;
    });
  }

  void clearSearchUser() {
    searchController.clear();
    listSearchInspection = listInspection;
    setState(() {});
  }

  @override
  void initState() {
    getInspection();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Flex(
        direction: Axis.vertical,
        children: [
          InputSearch(
            controller: searchController,
            onTapSuffixIcon: clearSearchUser,
            onChanged: searchUser,
          ),
          Expanded(
            child: listSearchInspection.isNotEmpty
                ? ListView.builder(
                    itemCount: listSearchInspection.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final data = listSearchInspection[index];
                      return InspectionItem(
                        bgColor: ConvertHelper.intToBool(data.isClosed)
                            ? Colors.grey.shade800
                            : Palette.primaryColorProd,
                        data: data,
                        onTap: () async {
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
                            responses: data.responses,
                            status: data.status,
                            submittedAt: data.submittedAt,
                            submittedBy: data.submittedBy,
                            submittedByName: data.submittedByName,
                            trTime: data.trTime,
                            usingGps: data.usingGps,
                          );
                          await _navigationService.push(
                            Routes.INSPECTION_DETAIL,
                            arguments: data,
                          );
                          await DatabaseSubordinateInspection.updateData(
                            inspectionTemp,
                          );
                          await DatabaseTicketInspection
                              .updateDataFromListOnGoing(inspectionTemp);
                          await context
                              .read<InspectionNotifier>()
                              .updateSubordinateInspectionFromLocal();
                          setState(() {
                            listSearchInspection[index] = inspectionTemp;
                            final listInspectionTemp =
                                listInspection.map((e) => e.code).toList();
                            final indexTemp =
                                listInspectionTemp.indexOf(inspectionTemp.code);
                            listInspection[indexTemp] = inspectionTemp;
                          });
                        },
                      );
                    },
                  )
                : Center(child: Text('Data Tidak Ada')),
          ),
        ],
      ),
    );
    // return Consumer<InspectionNotifier>(
    //   builder: (context, provider, _) {
    //     return Padding(
    //       padding: EdgeInsets.all(12),
    //       child: provider.listSubordinateInspection.isNotEmpty
    //           ? ListView.builder(
    //               itemCount: provider.listSubordinateInspection.length,
    //               padding: EdgeInsets.zero,
    //               itemBuilder: (context, index) {
    //                 final data = provider.listSubordinateInspection[index];
    //                 return InspectionItem(
    //                   bgColor: ConvertHelper.intToBool(data.isClosed)
    //                       ? Colors.grey.shade800
    //                       : Palette.primaryColorProd,
    //                   data: data,
    //                   onTap: () async {
    //                     final inspectionTemp = TicketInspectionModel(
    //                       assignee: data.assignee,
    //                       assigneeId: data.assigneeId,
    //                       attachments: data.attachments,
    //                       closedAt: data.closedAt,
    //                       closedBy: data.closedBy,
    //                       closedByName: data.closedByName,
    //                       code: data.code,
    //                       description: data.description,
    //                       gpsLat: data.gpsLat,
    //                       gpsLng: data.gpsLng,
    //                       id: data.id,
    //                       isClosed: data.isClosed,
    //                       isNewResponse: 0,
    //                       isSynchronize: data.isSynchronize,
    //                       mCompanyAlias: data.mCompanyAlias,
    //                       mCompanyId: data.mCompanyId,
    //                       mCompanyName: data.mCompanyName,
    //                       mDivisionEstateCode: data.mDivisionEstateCode,
    //                       mDivisionId: data.mDivisionId,
    //                       mDivisionName: data.mDivisionName,
    //                       mTeamId: data.mTeamId,
    //                       mTeamName: data.mTeamName,
    //                       responses: data.responses,
    //                       status: data.status,
    //                       submittedAt: data.submittedAt,
    //                       submittedBy: data.submittedBy,
    //                       submittedByName: data.submittedByName,
    //                       trTime: data.trTime,
    //                       usingGps: data.usingGps,
    //                     );
    //                     await provider.navigationService.push(
    //                       Routes.INSPECTION_DETAIL,
    //                       arguments: data,
    //                     );
    //                     await DatabaseSubordinateInspection.updateData(
    //                       inspectionTemp,
    //                     );
    //                     await DatabaseTicketInspection
    //                         .updateDataFromListOnGoing(inspectionTemp);
    //                     await provider.updateSubordinateInspectionFromLocal();
    //                   },
    //                 );
    //               },
    //             )
    //           : Center(child: Text('Belum Ada Data')),
    //     );
    //   },
    // );
  }
}
