import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/screen/supervisor/supervisor_ancak_harvest_form/supervisor_ancak_form_fruit.dart';
import 'package:epms/screen/supervisor/supervisor_ancak_harvest_form/supervisor_ancak_form_tab.dart';
import 'package:epms/screen/supervisor/supervisor_ancak_harvest_form/supervisor_ancak_harvest_form_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorAncakHarvestFormScreen extends StatefulWidget {
  const SupervisorAncakHarvestFormScreen({Key? key}) : super(key: key);

  @override
  State<SupervisorAncakHarvestFormScreen> createState() =>
      _SupervisorAncakHarvestFormScreenState();
}

class _SupervisorAncakHarvestFormScreenState
    extends State<SupervisorAncakHarvestFormScreen> {
  @override
  void initState() {
    context.read<SupervisorAncakFormNotifier>().generateVariable();
    context.read<SupervisorAncakFormNotifier>().getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => NavigatorService().onWillPopForm(context),
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: MediaQuery(
          data: Style.mediaQueryText(context),
          child: Scaffold(
            appBar: AppBar(
              title: Text('Supervisi Ancak Panen'),
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
              children: <Widget>[
                SupervisorAncakFormTab(),
                SupervisorAncakFormFruit()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
