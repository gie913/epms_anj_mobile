import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/screen/synch/synch_notifier.dart';
import 'package:epms/screen/synch/synch_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SynchScreen extends StatefulWidget {
  @override
  _SynchScreenState createState() => _SynchScreenState();
}

class _SynchScreenState extends State<SynchScreen> {
  var lastSync;

  @override
  void initState() {
    context.read<SynchNotifier>().doSynchMasterData(context);
    super.initState();
  }

  @override
  void dispose() {
    SynchRepository().deleteMasterData(context);
    super.dispose();
  }

  @override
  void deactivate() {
    SynchRepository().deleteMasterData(context);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // onWillPop: () async => false,
      canPop: false,
      onPopInvoked: (didPop) {},
      child: Consumer<SynchNotifier>(builder: (context, synch, child) {
        return Scaffold(
          body: MediaQuery(
            data: Style.mediaQueryText(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: CircularProgressIndicator(
                      backgroundColor: Palette.greenColorDark,
                      strokeWidth: 4.0,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text("Sinkronisasi data.."),
                        Text("${synch.dataText}"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
