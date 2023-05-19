import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/model/oph_supervise_ancak.dart';
import 'package:epms/screen/supervisor/detail_supervise_ancak_harvest/detail_supervisor_ancak_fruit.dart';
import 'package:epms/screen/supervisor/detail_supervise_ancak_harvest/detail_supervisor_ancak_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'detail_supervisor_ancak_tab.dart';
import 'edit_supervisor_ancak_fruit.dart';

class DetailSuperviseAncakHarvestScreen extends StatefulWidget {
  final OPHSuperviseAncak ophSuperviseAncak;

  const DetailSuperviseAncakHarvestScreen({Key? key, required this.ophSuperviseAncak})
      : super(key: key);

  @override
  State<DetailSuperviseAncakHarvestScreen> createState() =>
      _DetailSuperviseAncakHarvestScreenState();
}

class _DetailSuperviseAncakHarvestScreenState
    extends State<DetailSuperviseAncakHarvestScreen> {
  @override
  void initState() {
    context.read<DetailSupervisorAncakNotifier>().onInit(widget.ophSuperviseAncak);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailSupervisorAncakNotifier>(
        builder: (context, notifier, child) {
          return WillPopScope(
            onWillPop: () async {
              if (notifier.onEdit) {
                return NavigatorService().onWillPopForm(context);
              } else {
                return true;
              }
            },
            child: DefaultTabController(
              initialIndex: 0,
              length: 2,
              child: MediaQuery(
                data: Style.mediaQueryText(context),
                child: Scaffold(
                  appBar: AppBar(
                    title: Text('Detail Laporan Supervisi Ancak Panen'),
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
                      DetailSupervisorAncakTab(),
                      notifier.onEdit ? EditSupervisorAncakFormFruit() : DetailSupervisorAncakFormFruit()
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}