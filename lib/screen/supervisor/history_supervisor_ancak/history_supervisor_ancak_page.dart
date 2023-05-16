
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'history_supervisor_ancak_notifier.dart';
import 'history_supervisor_ancak_screen.dart';

class HistorySuperviseAncakPage extends StatefulWidget {
  const HistorySuperviseAncakPage({Key? key}) : super(key: key);

  @override
  State<HistorySuperviseAncakPage> createState() => _HistorySuperviseAncakPageState();
}

class _HistorySuperviseAncakPageState extends State<HistorySuperviseAncakPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HistorySuperviseAncakNotifier(),
        child: HistorySuperviseAncakScreen());
  }
}