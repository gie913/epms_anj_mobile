import 'package:epms/model/spb_supervise.dart';
import 'package:epms/screen/supervisor_spb/supervisor_spb_detail/supervisor_spb_detail_notifier.dart';
import 'package:epms/screen/supervisor_spb/supervisor_spb_detail/supervisor_spb_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorSPBDetailPage extends StatefulWidget {
  final SPBSupervise spbSupervise;
  const SupervisorSPBDetailPage({Key? key, required this.spbSupervise}) : super(key: key);

  @override
  State<SupervisorSPBDetailPage> createState() => _SupervisorSPBDetailPageState();
}

class _SupervisorSPBDetailPageState extends State<SupervisorSPBDetailPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SupervisorSPBDetailNotifier(),
        child: SupervisorSPBDetailScreen(spbSupervise: widget.spbSupervise));
  }
}
