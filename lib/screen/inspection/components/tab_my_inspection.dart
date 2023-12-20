import 'package:epms/base/common/routes.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/database/helper/convert_helper.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/screen/inspection/components/inspection_item.dart';
import 'package:epms/screen/inspection/inspection_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabMyInspection extends StatefulWidget {
  const TabMyInspection({super.key});

  @override
  State<TabMyInspection> createState() => _TabMyInspectionState();
}

class _TabMyInspectionState extends State<TabMyInspection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionNotifier>(
      builder: (context, provider, _) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: provider.listMyInspection.isNotEmpty
              ? ListView.builder(
                  itemCount: provider.listMyInspection.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final data = provider.listMyInspection[index];
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
                        );
                        await provider.navigationService.push(
                          Routes.INSPECTION_DETAIL,
                          arguments: data,
                        );
                        await DatabaseTicketInspection.updateData(
                          inspectionTemp,
                        );
                        provider.updateMyInspectionFromLocal();
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
