import 'package:epms/base/common/routes.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/database/helper/convert_helper.dart';
import 'package:epms/database/service/database_subordinate_inspection.dart';
import 'package:epms/model/ticket_inspection_model.dart';
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
  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionNotifier>(
      builder: (context, provider, _) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: provider.listSubordinateInspection.isNotEmpty
              ? ListView.builder(
                  itemCount: provider.listSubordinateInspection.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final data = provider.listSubordinateInspection[index];
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
                        await provider.navigationService.push(
                          Routes.INSPECTION_DETAIL,
                          arguments: data,
                        );
                        await DatabaseSubordinateInspection.updateData(
                          inspectionTemp,
                        );
                        await provider.updateSubordinateInspectionFromLocal();
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
