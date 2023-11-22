import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/screen/inspection/components/inspection_item.dart';
import 'package:flutter/material.dart';

class TabMyInspection extends StatefulWidget {
  const TabMyInspection({super.key, this.listMyInspection = const []});

  final List<TicketInspectionModel> listMyInspection;

  @override
  State<TabMyInspection> createState() => _TabMyInspectionState();
}

class _TabMyInspectionState extends State<TabMyInspection> {
  NavigatorService _navigationService = locator<NavigatorService>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: widget.listMyInspection.isNotEmpty
          ? ListView.builder(
              itemCount: widget.listMyInspection.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final data = widget.listMyInspection[index];
                return InspectionItem(
                  data: data,
                  onTap: () {
                    _navigationService.push(
                      Routes.INSPECTION_DETAIL,
                      arguments: data,
                    );
                  },
                );
              },
            )
          : Center(child: Text('Belum Ada Data')),
    );
  }
}
