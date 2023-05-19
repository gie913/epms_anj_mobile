import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_form/supervisor_tbs_luar_from_screen.dart';
import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_form/supervisor_tbs_luar_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorTBSLuarFormPage extends StatefulWidget {
  const SupervisorTBSLuarFormPage({Key? key}) : super(key: key);

  @override
  State<SupervisorTBSLuarFormPage> createState() => _SupervisorTBSLuarFormPageState();
}

class _SupervisorTBSLuarFormPageState extends State<SupervisorTBSLuarFormPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SupervisorTBSLuarNotifier(),
        child: SupervisorTBSLuarFormScreen());
  }
}
