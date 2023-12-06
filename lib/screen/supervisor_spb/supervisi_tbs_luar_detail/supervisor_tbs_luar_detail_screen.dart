import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/model/tbs_luar.dart';
import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_detail/supervisor_tbs_luar_detail_notifier.dart';
import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_detail/supervisor_tbs_luar_detail_sortasi.dart';
import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_detail/supervisor_tbs_luar_detail_tab.dart';
import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_detail/supervisor_tbs_luar_sortasi_edit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorTBSLuarDetailScreen extends StatefulWidget {
  final TBSLuar? tbsLuar;
  final String method;

  const SupervisorTBSLuarDetailScreen(
      {Key? key, this.tbsLuar, required this.method})
      : super(key: key);

  @override
  State<SupervisorTBSLuarDetailScreen> createState() =>
      _SupervisorTBSLuarDetailScreenState();
}

class _SupervisorTBSLuarDetailScreenState
    extends State<SupervisorTBSLuarDetailScreen> {
  @override
  void initState() {
    context
        .read<SupervisorTBSLuarDetailNotifier>()
        .onInit(context, widget.tbsLuar, widget.method);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SupervisorTBSLuarDetailNotifier>(
        builder: (context, notifier, child) {
      return PopScope(
        // onWillPop: () async {
        //   if (notifier.onEdit) {
        //     return NavigatorService().onWillPopForm(context);
        //   } else {
        //     return true;
        //   }
        // },
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop == false) {
            if (notifier.onEdit) {
              final res = await NavigatorService().onWillPopForm(context);
              if (res) {
                Navigator.pop(context);
              }
            } else {
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
                      icon: Text("Detail"),
                    ),
                    Tab(
                      icon: Text("Sortasi"),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  SupervisorTBSLuarDetailTab(),
                  notifier.onEdit
                      ? SupervisorTBSSortasiEdit()
                      : SupervisorTBSLuarDetailSortasi()
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
