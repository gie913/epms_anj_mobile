import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/screen/home/home_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<HomeNotifier>().onInitHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeNotifier>(builder: (context, notifier, child) {
      return WillPopScope(
        onWillPop: () async => false,
        child: notifier.role != null
            ? MediaQuery(
          data: Style.mediaQueryText(context),
              child: Scaffold(
                  body: ValueService.getMenuFromRoles(notifier.role),
                ),
            )
            : Container(),
      );
    });
  }
}
