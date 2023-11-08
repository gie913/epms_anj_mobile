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

  // final listMyInspection = [
  //   {
  //     'id': 'INSPECTION120102023',
  //     'date': '20-10-2023',
  //     'longitude': -6.2299939,
  //     'latitude': 106.8276762,
  //     'category': 'Kategori 1',
  //     'company': 'Company 1',
  //     'divisi': 'Divisi 1',
  //     'user_assign': 'User 1',
  //     'status': 'Re-Assign',
  //     'report': 'Test Pengaduan Inspection',
  //     'history': [
  //       {
  //         'user': 'User 1',
  //         'date': '20-10-2023',
  //         'category': 'Kategori 1',
  //         'company': 'Company 1',
  //         'divisi': 'Divisi 1',
  //         'response': 'Bukan Salah Saya',
  //         'status': 'Re-Assign',
  //         'user_re_assign': 'User 2',
  //       },
  //     ],
  //   },
  //   {
  //     'id': 'INSPECTION220102023',
  //     'date': '20-10-2023',
  //     'longitude': -6.2299939,
  //     'latitude': 106.8276762,
  //     'category': 'Kategori 2',
  //     'company': 'Company 2',
  //     'divisi': 'Divisi 2',
  //     'user_assign': 'User 1',
  //     'status': 'On Progress',
  //     'report': 'Test Pengaduan Inspection',
  //     'history': [],
  //   },
  //   {
  //     'id': 'INSPECTION320102023',
  //     'date': '20-10-2023',
  //     'longitude': -6.2299939,
  //     'latitude': 106.8276762,
  //     'category': 'Kategori 3',
  //     'company': 'Company 3',
  //     'divisi': 'Divisi 3',
  //     'user_assign': 'User 3',
  //     'status': 'Complete',
  //     'report': 'Test Pengaduan Inspection',
  //     'history': [],
  //   },
  // ];

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
