import 'package:epms/screen/supervisor/supervisor_harvest_form/supervisor_harvest_form_notifier.dart';
import 'package:epms/screen/supervisor/supervisor_harvest_form/supervisor_harvest_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorHarvestFormPage extends StatefulWidget {
  const SupervisorHarvestFormPage({Key? key}) : super(key: key);

  @override
  State<SupervisorHarvestFormPage> createState() =>
      _SupervisorHarvestFormPageState();
}

class _SupervisorHarvestFormPageState extends State<SupervisorHarvestFormPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SupervisorHarvestFormNotifier(),
        child: SupervisorHarvestFormScreen());
  }
}
