import 'package:epms/model/oph_supervise_ancak.dart';
import 'package:epms/screen/supervisor/detail_supervise_ancak_harvest/detail_supervisor_ancak_harvest_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'detail_supervisor_ancak_notifier.dart';

class DetailSuperviseAncakHarvestPage extends StatefulWidget {
  final OPHSuperviseAncak ophSuperviseAncak;
  const DetailSuperviseAncakHarvestPage({Key? key, required this.ophSuperviseAncak}) : super(key: key);

  @override
  State<DetailSuperviseAncakHarvestPage> createState() => _DetailSuperviseAncakHarvestPageState();
}

class _DetailSuperviseAncakHarvestPageState extends State<DetailSuperviseAncakHarvestPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DetailSupervisorAncakNotifier(),
        child: DetailSuperviseAncakHarvestScreen(ophSuperviseAncak: widget.ophSuperviseAncak));
  }
}
