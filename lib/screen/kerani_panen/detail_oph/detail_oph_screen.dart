import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/screen/kerani_panen/detail_oph/detail_oph_edit_fruit.dart';
import 'package:epms/screen/kerani_panen/detail_oph/detail_oph_notifier.dart';
import 'package:epms/screen/kerani_panen/detail_oph/detail_oph_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'detail_oph_fruit.dart';

class DetailOPHScreen extends StatefulWidget {
  final OPH oph;
  final String method;
  final bool restan;

  const DetailOPHScreen({Key? key, required this.oph, required this.method, required this.restan})
      : super(key: key);

  @override
  State<DetailOPHScreen> createState() => _DetailOPHScreenState();
}

class _DetailOPHScreenState extends State<DetailOPHScreen> {
  @override
  void initState() {
    context
        .read<DetailOPHNotifier>()
        .onInit(context, widget.oph, widget.method, widget.restan);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailOPHNotifier>(builder: (context, notifier, child) {
      return WillPopScope(
        onWillPop: () async {
          if (notifier.onEdit) {
            return NavigatorService().onWillPopForm(context);
          } else if (notifier.onChangeCard) {
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
                title: const Text('Detail OPH'),
                bottom: const TabBar(
                  tabs: <Widget>[
                    Tab(
                      icon: Text("Detail"),
                    ),
                    Tab(
                      icon: Text("Grading"),
                    ),
                  ],
                ),
              ),
              body: TabBarView(children: <Widget>[
                DetailOPHTab(),
                notifier.onEdit ? DetailOPHEditFruit() : DetailOPHFruit()
              ]),
            ),
          ),
        ),
      );
    });
  }
}
