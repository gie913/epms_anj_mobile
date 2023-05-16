import 'package:epms/screen/supervisor_spb/supervisi_spb_form/supervisor_spb_form_notifier.dart';
import 'package:epms/screen/supervisor_spb/supervisi_spb_form/supervisor_spb_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorSPBFormPage extends StatefulWidget {
  const SupervisorSPBFormPage({Key? key}) : super(key: key);

  @override
  State<SupervisorSPBFormPage> createState() => _SupervisorSPBFormPageState();
}

class _SupervisorSPBFormPageState extends State<SupervisorSPBFormPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SupervisorSPBFormNotifier(),
        child: SupervisorSPBFormScreen());
  }
}
