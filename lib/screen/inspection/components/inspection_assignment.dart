import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/screen/inspection/components/inspection_item.dart';
import 'package:flutter/material.dart';

class InspectionAssignment extends StatefulWidget {
  const InspectionAssignment({super.key});

  @override
  State<InspectionAssignment> createState() => _InspectionAssignmentState();
}

class _InspectionAssignmentState extends State<InspectionAssignment> {
  NavigatorService _navigationService = locator<NavigatorService>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: 1,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return InspectionItem(
            onTap: () {
              _navigationService.push(Routes.INSPECTION_ASSIGNMENT);
            },
          );
        },
      ),
    );
  }
}
