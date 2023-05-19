import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_history/supervisor_tbs_luar_history_notifier.dart';
import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_history/supervisor_tbs_luar_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorTBSLuarHistoryPage extends StatefulWidget {
  const SupervisorTBSLuarHistoryPage({Key? key}) : super(key: key);

  @override
  State<SupervisorTBSLuarHistoryPage> createState() => _SupervisorTBSLuarHistoryPageState();
}

class _SupervisorTBSLuarHistoryPageState extends State<SupervisorTBSLuarHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SupervisorTBSLuarHistoryNotifier(),
        child: SupervisorTBSLuarHistoryScreen());
  }
}