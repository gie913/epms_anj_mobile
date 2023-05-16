import 'package:epms/base/ui/style.dart';
import 'package:epms/model/oph_supervise.dart';
import 'package:epms/screen/supervisor/detail_supervise_harvest/detail_supervise_harvest_notifier.dart';
import 'package:epms/screen/supervisor/detail_supervise_harvest/supervise_harvest_detail_edit_fruit.dart';
import 'package:epms/screen/supervisor/detail_supervise_harvest/supervise_harvest_detail_tab.dart';
import 'package:epms/screen/supervisor/detail_supervise_harvest/supervisor_harvest_detail_fruit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailSuperviseHarvestScreen extends StatefulWidget {
  final OPHSupervise ophSupervise;

  const DetailSuperviseHarvestScreen({Key? key, required this.ophSupervise})
      : super(key: key);

  @override
  State<DetailSuperviseHarvestScreen> createState() =>
      _DetailSuperviseHarvestScreenState();
}

class _DetailSuperviseHarvestScreenState
    extends State<DetailSuperviseHarvestScreen> {
  @override
  void initState() {
    context.read<DetailSuperviseHarvestNotifier>().onInit(widget.ophSupervise);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailSuperviseHarvestNotifier>(
      builder: (context, notifier, child) {
        return DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: MediaQuery(
            data: Style.mediaQueryText(context),
            child: Scaffold(
              appBar: AppBar(
                title: Text('Detail Laporan Supervisi'),
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
                  SuperviseHarvestDetailTab(),
                  notifier.onEdit ? SuperviseDetailEditFruit() : SuperviseHarvestDetailFruit()
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
