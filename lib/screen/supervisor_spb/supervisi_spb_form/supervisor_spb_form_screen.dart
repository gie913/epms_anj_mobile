import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/screen/supervisor_spb/supervisi_spb_form/supervisor_spb_form_fruit.dart';
import 'package:epms/screen/supervisor_spb/supervisi_spb_form/supervisor_spb_form_notifier.dart';
import 'package:epms/screen/supervisor_spb/supervisi_spb_form/supervisor_spb_form_tab.dart';
import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_form/supervisor_tbs_sortasi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorSPBFormScreen extends StatefulWidget {
  const SupervisorSPBFormScreen({Key? key}) : super(key: key);

  @override
  State<SupervisorSPBFormScreen> createState() =>
      _SupervisorSPBFormScreenState();
}

class _SupervisorSPBFormScreenState extends State<SupervisorSPBFormScreen> {
  @override
  void initState() {
    context.read<SupervisorSPBFormNotifier>().onInit();
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
        child: Consumer<SupervisorSPBFormNotifier>(
            builder: (context, notifier, child) {
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
                  children: <Widget>[
                    SupervisorSPBFormTab(),
                    notifier.sourceSPBValue == "Internal"
                        ? SupervisorSPBFormFruit()
                        : SupervisorTBSSortasi()
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
