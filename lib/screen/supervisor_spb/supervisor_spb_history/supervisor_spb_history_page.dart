import 'package:epms/screen/supervisor_spb/supervisor_spb_history/supervisor_spb_history_notifier.dart';
import 'package:epms/screen/supervisor_spb/supervisor_spb_history/supervisor_spb_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorSPBHistoryPage extends StatefulWidget {
  const SupervisorSPBHistoryPage({Key? key}) : super(key: key);

  @override
  State<SupervisorSPBHistoryPage> createState() => _SupervisorSPBHistoryPageState();
}

class _SupervisorSPBHistoryPageState extends State<SupervisorSPBHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SupervisorSPBHistoryNotifier(),
        child: SupervisorSPBHistoryScreen());
  }
}
