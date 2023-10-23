import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/screen/inspection/components/inspection_item.dart';
import 'package:flutter/material.dart';

class TabToDo extends StatefulWidget {
  const TabToDo({super.key});

  @override
  State<TabToDo> createState() => _TabToDoState();
}

class _TabToDoState extends State<TabToDo> {
  NavigatorService _navigationService = locator<NavigatorService>();
  final listAssignment = [
    {
      'id': 'INSPECTION120102023',
      'date': '20-10-2023',
      'longitude': -6.2299939,
      'latitude': 106.8276762,
      'category': 'Kategori 1',
      'company': 'Company 1',
      'divisi': 'Divisi 1',
      'user_assign': 'User 2',
      'status': 'On Progress',
      'report': 'Test Pengaduan Inspection',
      'response': '',
      'history': [
        {
          'user': 'User 1',
          'date': '20-10-2023',
          'category': 'Kategori 1',
          'company': 'Company 1',
          'divisi': 'Divisi 1',
          'response': 'Bukan Salah Saya',
          'status': 'Re-Assign',
          'user_re_assign': 'User 2',
        },
      ],
    },
    {
      'id': 'INSPECTION220102023',
      'date': '20-10-2023',
      'longitude': -6.2299939,
      'latitude': 106.8276762,
      'category': 'Kategori 2',
      'company': 'Company 2',
      'divisi': 'Divisi 2',
      'user_assign': 'User 1',
      'status': 'On Progress',
      'report': 'Test Pengaduan Inspection',
      'response': '',
      'history': [],
    },
    {
      'id': 'INSPECTION320102023',
      'date': '20-10-2023',
      'longitude': -6.2299939,
      'latitude': 106.8276762,
      'category': 'Kategori 3',
      'company': 'Company 3',
      'divisi': 'Divisi 3',
      'user_assign': 'User 3',
      'status': 'Complete',
      'report': 'Test Pengaduan Inspection',
      'response': 'Pengaduan Sudah Ditanggapi',
      'history': [
        {
          'user': 'User 3',
          'date': '20-10-2023',
          'category': 'Kategori 3',
          'company': 'Company 3',
          'divisi': 'Divisi 3',
          'response': 'Pengaduan Sudah Ditanggapi',
          'status': 'Complete',
          'user_re_assign': '',
        },
      ],
    },
    {
      'id': 'INSPECTION420102023',
      'date': '20-10-2023',
      'longitude': -6.2299939,
      'latitude': 106.8276762,
      'category': 'Kategori 1',
      'company': 'Company 2',
      'divisi': 'Divisi 3',
      'user_assign': 'User 3',
      'status': 'Re-Assign',
      'report': 'Test Pengaduan Inspection',
      'history': [
        {
          'user': 'User 3',
          'date': '20-10-2023',
          'category': 'Kategori 3',
          'company': 'Company 3',
          'divisi': 'Divisi 3',
          'response': 'Bukan Tugas Saya',
          'status': 'Re-Assign',
          'user_re_assign': 'User 1',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: listAssignment.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final data = listAssignment[index];
          return InspectionItem(
            data: data,
            onTap: () {
              if (index == 2 || index == 3) {
                _navigationService.push(
                  Routes.INSPECTION_APPROVAL,
                  arguments: data,
                );
              } else {
                _navigationService.push(
                  Routes.INSPECTION_ASSIGNMENT_DETAIL,
                  arguments: data,
                );
              }
            },
          );
        },
      ),
    );
  }
}
