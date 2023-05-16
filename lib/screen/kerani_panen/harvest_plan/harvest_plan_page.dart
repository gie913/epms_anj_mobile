import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'harvest_plan_notifier.dart';
import 'harvest_plan_screen.dart';

class HarvestPlanPage extends StatefulWidget {
  const HarvestPlanPage({Key? key}) : super(key: key);

  @override
  _HarvestPlanPageState createState() => _HarvestPlanPageState();
}

class _HarvestPlanPageState extends State<HarvestPlanPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HarvestPlanNotifier(), child: HarvestPlanScreen());
  }
}
