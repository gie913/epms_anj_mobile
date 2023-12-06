import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/screen/supervisor/supervisor_harvest_form/supervisor_form_fruit.dart';
import 'package:epms/screen/supervisor/supervisor_harvest_form/supervisor_form_tab.dart';
import 'package:epms/screen/supervisor/supervisor_harvest_form/supervisor_harvest_form_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorHarvestFormScreen extends StatefulWidget {
  SupervisorHarvestFormScreen({Key? key}) : super(key: key);

  @override
  State<SupervisorHarvestFormScreen> createState() =>
      _SupervisorHarvestFormScreenState();
}

class _SupervisorHarvestFormScreenState
    extends State<SupervisorHarvestFormScreen> {
  @override
  void initState() {
    context.read<SupervisorHarvestFormNotifier>().generateVariable();
    context.read<SupervisorHarvestFormNotifier>().getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // onWillPop: () async => NavigatorService().onWillPopForm(context),
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop == false) {
          final res = await NavigatorService().onWillPopForm(context);
          if (res) {
            Navigator.pop(context);
          }
        }
      },
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: MediaQuery(
          data: Style.mediaQueryText(context),
          child: Scaffold(
            appBar: AppBar(
              title: Text('Supervisi Panen'),
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
              children: <Widget>[SupervisorFormTab(), SupervisorFormFruit()],
            ),
          ),
        ),
      ),
    );
  }
}
