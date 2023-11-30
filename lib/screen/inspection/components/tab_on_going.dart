import 'package:epms/base/common/routes.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/database/helper/convert_helper.dart';
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
                      onTap: () {
                        provider.navigationService.push(
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
