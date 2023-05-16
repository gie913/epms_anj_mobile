import 'package:epms/screen/supervisor/supervisor_ancak_harvest_form/supervisor_ancak_harvest_form_notifier.dart';
import 'package:epms/screen/supervisor/supervisor_ancak_harvest_form/supervisor_ancak_harvest_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorAncakHarvestFormPage extends StatefulWidget {
  const SupervisorAncakHarvestFormPage({Key? key}) : super(key: key);

  @override
  State<SupervisorAncakHarvestFormPage> createState() => _SupervisorAncakHarvestFormPageState();
}

class _SupervisorAncakHarvestFormPageState extends State<SupervisorAncakHarvestFormPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SupervisorAncakFormNotifier(),
        child: SupervisorAncakHarvestFormScreen());
  }
}
