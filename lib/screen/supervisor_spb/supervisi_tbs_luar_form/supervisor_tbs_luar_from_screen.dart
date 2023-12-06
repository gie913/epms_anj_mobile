import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_form/supervisor_tbs_luar_form_tab.dart';
import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_form/supervisor_tbs_luar_notifier.dart';
import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_form/supervisor_tbs_sortasi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorTBSLuarFormScreen extends StatefulWidget {
  const SupervisorTBSLuarFormScreen({Key? key}) : super(key: key);

  @override
  State<SupervisorTBSLuarFormScreen> createState() =>
      _SupervisorTBSLuarFormScreenState();
}

class _SupervisorTBSLuarFormScreenState
    extends State<SupervisorTBSLuarFormScreen> {
  @override
  void initState() {
    context.read<SupervisorTBSLuarNotifier>().onInit();
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
              title: Text('Supervisi TBS Luar'),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Text("Form"),
                  ),
                  Tab(
                    icon: Text("Sortasi"),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                SupervisorTBSLuarFormTab(),
                SupervisorTBSSortasi()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
