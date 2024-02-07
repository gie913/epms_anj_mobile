import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/database/helper/convert_helper.dart';
import 'package:epms/database/service/database_subordinate_inspection.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/screen/inspection/components/inspection_item.dart';
import 'package:flutter/material.dart';

class InspectionListView extends StatefulWidget {
  const InspectionListView({super.key, required this.listMyInspection});

  final List<TicketInspectionModel> listMyInspection;

  @override
  State<InspectionListView> createState() => _InspectionListViewState();
}

class _InspectionListViewState extends State<InspectionListView> {
  NavigatorService _navigationService = locator<NavigatorService>();
  List<TicketInspectionModel> myInspection = [];

  @override
  void initState() {
    myInspection = widget.listMyInspection;
    super.initState();
  }

  Future<void> updateMyInspectionFromLocal() async {
    final data = await DatabaseTicketInspection.selectData();
    myInspection = data;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: Style.mediaQueryText(context),
      child: Scaffold(
        appBar: AppBar(title: Text('My Inspection')),
        body: Padding(
          padding: EdgeInsets.all(12),
          child: myInspection.isNotEmpty
              ? ListView.builder(
                  itemCount: myInspection.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final data = myInspection[index];
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
                        await DatabaseTicketInspection.updateData(
                          inspectionTemp,
                        );
                        await DatabaseSubordinateInspection
                            .updateDataFromListMyInspection(
                          inspectionTemp,
                        );
                        updateMyInspectionFromLocal();
                      },
                    );
                  },
                )
              : Center(child: Text('Belum Ada Data')),
        ),
      ),
    );
  }
}
