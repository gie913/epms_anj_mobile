
import 'package:epms/base/ui/style.dart';
import 'package:epms/screen/kerani_panen/bagi_oph/bagi_oph_notifier.dart';
import 'package:epms/screen/kerani_panen/bagi_oph/new_oph_tab.dart';
import 'package:epms/screen/kerani_panen/bagi_oph/previous_oph_tab.dart';
import 'package:epms/widget/keep_alive_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BagiOPHScreen extends StatefulWidget {
  const BagiOPHScreen({Key? key}) : super(key: key);

  @override
  _BagiOPHScreenState createState() => _BagiOPHScreenState();
}

class _BagiOPHScreenState extends State<BagiOPHScreen> {

  @override
  void initState() {
    context.read<BagiOPHNotifier>().onInit(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BagiOPHNotifier>(builder: (context, bagiOPH, child) {
      return WillPopScope(
      onWillPop: () async => bagiOPH.checkAllSaved(),
      child:DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: MediaQuery(
            data: Style.mediaQueryText(context),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Bagi OPH'),
                bottom: const TabBar(
                  tabs: <Widget>[
                    Tab(
                      icon: Text("OPH Lama"),
                    ),
                    Tab(
                      icon: Text("OPH Baru"),
                    ),
                  ],
                ),
              ),
              body: TabBarView(children: <Widget>[
                KeepAliveWrapper(child: const PreviousOPHTab()),
                KeepAliveWrapper(child: const NewOPHTab())
              ]),
            ),
          ),
        ));}
    );
  }
}
