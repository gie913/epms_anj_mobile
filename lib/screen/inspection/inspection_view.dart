import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/screen/inspection/components/tab_inspection_assignment.dart';
import 'package:epms/screen/inspection/components/tab_inspection_history.dart';
import 'package:flutter/material.dart';

class InspectionView extends StatefulWidget {
  const InspectionView({super.key});

  @override
  State<InspectionView> createState() => _InspectionViewState();
}

class _InspectionViewState extends State<InspectionView> {
  NavigatorService _navigationService = locator<NavigatorService>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: MediaQuery(
        data: Style.mediaQueryText(context),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Inspection'),
            actions: [
              IconButton(
                onPressed: () {
                  _navigationService.push(Routes.INSPECTION_FORM);
                },
                icon: Icon(
                  Icons.add_box_rounded,
                  color: Colors.white,
                ),
              ),
            ],
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Text("History"),
                ),
                Tab(
                  icon: Text("Assignment"),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: const [
              TabInspectionHistory(),
              TabInspectionAssignment(),
            ],
          ),
        ),
      ),
    );
  }
}
