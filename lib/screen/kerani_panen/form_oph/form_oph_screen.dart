import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/screen/kerani_panen/form_oph/form_oph_fruit.dart';
import 'package:epms/screen/kerani_panen/form_oph/form_oph_notifier.dart';
import 'package:epms/screen/kerani_panen/form_oph/form_oph_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormOPHScreen extends StatefulWidget {
  const FormOPHScreen({Key? key}) : super(key: key);

  @override
  _FormOPHScreenState createState() => _FormOPHScreenState();
}

class _FormOPHScreenState extends State<FormOPHScreen> {
  @override
  void initState() {
    context.read<FormOPHNotifier>().generateVariable();
    context.read<FormOPHNotifier>().onInitFormOPH(context);
    context.read<FormOPHNotifier>().getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => NavigatorService().onWillPopForm(context),
      child: Consumer<FormOPHNotifier>(builder: (context, formOPH, child) {
        return DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: MediaQuery(
            data: Style.mediaQueryText(context),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Form OPH'),
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
              body: TabBarView(
                children: <Widget>[
                  FormOPHTab(),
                  FormOPHFruit(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
