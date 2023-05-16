import 'package:epms/screen/supervisor/workplan/workplan_notifier.dart';
import 'package:epms/screen/supervisor/workplan/workplan_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkPlanPage extends StatefulWidget {
  const WorkPlanPage({Key? key}) : super(key: key);

  @override
  State<WorkPlanPage> createState() => _WorkPlanPageState();
}

class _WorkPlanPageState extends State<WorkPlanPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => WorkPlanNotifier(),
        child: WorkPlanScreen());
  }
}
