import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/model/spb_supervise.dart';
import 'package:epms/screen/supervisor_spb/supervisor_spb_detail/supervisor_spb_detail_edit_fruit.dart';
import 'package:epms/screen/supervisor_spb/supervisor_spb_detail/supervisor_spb_detail_fruit.dart';
import 'package:epms/screen/supervisor_spb/supervisor_spb_detail/supervisor_spb_detail_notifier.dart';
import 'package:epms/screen/supervisor_spb/supervisor_spb_detail/supervisor_spb_detail_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorSPBDetailScreen extends StatefulWidget {
  final SPBSupervise spbSupervise;

  const SupervisorSPBDetailScreen({Key? key, required this.spbSupervise})
      : super(key: key);

  @override
  State<SupervisorSPBDetailScreen> createState() =>
      _SupervisorSPBDetailScreenState();
}

class _SupervisorSPBDetailScreenState extends State<SupervisorSPBDetailScreen> {
  @override
  void initState() {
    context.read<SupervisorSPBDetailNotifier>().onInit(widget.spbSupervise);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SupervisorSPBDetailNotifier>(
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
                  title: Text('Detail Supervisi SPB'),
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
                    SupervisorSPBDetailTab(),
                    notifier.onEdit ? SupervisorSPBFormEditFruit() : SupervisorSPBDetailFruit()
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
