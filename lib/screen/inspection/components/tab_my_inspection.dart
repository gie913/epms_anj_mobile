import 'package:epms/screen/inspection/components/item_row_inspection.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ItemRowInspection(
                  label: 'Inspeksi Dibuat :',
                  value: '${provider.totalCreateInspection}'),
              ItemRowInspection(
                  label: 'Inspeksi Sedang Berlangsung :',
                  value: '${provider.totalInspectionNotClose}'),
              ItemRowInspection(
                  label: 'Inspeksi Yang Perlu Tindakan :',
                  value: '${provider.totalInspectionToDo}'),
              ItemRowInspection(
                  label: 'Inspeksi Selesai :',
                  value: '${provider.totalInspectionClose}'),
              ItemRowInspection(
                  label: 'Inspeksi Yang Belum Upload :',
                  value: '${provider.totalInspectionNeedUpload}'),
            ],
          ),
        );
      },
    );
  }
}
