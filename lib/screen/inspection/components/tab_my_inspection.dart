import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/navigator_service.dart';
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
  NavigatorService _navigationService = locator<NavigatorService>();

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
      },
    );
  }
}
