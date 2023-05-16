import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'harvest_report_yesterday_notifier.dart';
import 'harvest_report_yesterday_screen.dart';

class HarvestReportYesterdayPage extends StatefulWidget {
  const HarvestReportYesterdayPage({Key? key}) : super(key: key);

  @override
  _HarvestReportYesterdayPageState createState() =>
      _HarvestReportYesterdayPageState();
}

class _HarvestReportYesterdayPageState
    extends State<HarvestReportYesterdayPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HarvestReportYesterdayNotifier(),
        child: HarvestReportYesterdayScreen());
  }
}
