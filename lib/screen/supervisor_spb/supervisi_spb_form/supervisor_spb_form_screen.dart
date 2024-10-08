import 'package:epms/base/ui/style.dart';
import 'package:epms/screen/supervisor_spb/supervisi_spb_form/supervisor_spb_form_fruit.dart';
import 'package:epms/screen/supervisor_spb/supervisi_spb_form/supervisor_spb_form_notifier.dart';
import 'package:epms/screen/supervisor_spb/supervisi_spb_form/supervisor_spb_form_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorSPBFormScreen extends StatefulWidget {
  const SupervisorSPBFormScreen({Key? key}) : super(key: key);

  @override
  State<SupervisorSPBFormScreen> createState() => _SupervisorSPBFormScreenState();
}

class _SupervisorSPBFormScreenState extends State<SupervisorSPBFormScreen> {
  @override
  void initState() {
    context.read<SupervisorSPBFormNotifier>().onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: MediaQuery(
        data: Style.mediaQueryText(context),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Supervisi SPB'),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Text("Form"),
                ),
                Tab(
                  icon: Text("Hasil"),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[SupervisorSPBFormTab(), SupervisorSPBFormFruit()],
          ),
        ),
      ),
    );
  }
}
