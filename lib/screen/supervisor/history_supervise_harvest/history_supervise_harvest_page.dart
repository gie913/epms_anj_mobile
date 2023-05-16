import 'package:epms/screen/supervisor/history_supervise_harvest/history_supervise_harvest_notifier.dart';
import 'package:epms/screen/supervisor/history_supervise_harvest/history_supervise_harvest_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistorySuperviseHarvestPage extends StatefulWidget {
  const HistorySuperviseHarvestPage({Key? key}) : super(key: key);

  @override
  State<HistorySuperviseHarvestPage> createState() => _HistorySuperviseHarvestPageState();
}

class _HistorySuperviseHarvestPageState extends State<HistorySuperviseHarvestPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HistorySuperviseHarvestNotifier(),
        child: HistorySuperviseHarvestScreen());
  }
}
