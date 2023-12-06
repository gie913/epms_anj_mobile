import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/model/spb_detail.dart';
import 'package:epms/model/spb_loader.dart';
import 'package:epms/screen/kerani_kirim/edit_spb/edit_spb_detail_tab.dart';
import 'package:epms/screen/kerani_kirim/edit_spb/edit_spb_loader_tab.dart';
import 'package:epms/screen/kerani_kirim/edit_spb/edit_spb_notifier.dart';
import 'package:epms/screen/kerani_kirim/edit_spb/edit_spb_oph_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditSPBScreen extends StatefulWidget {
  final SPB spb;
  final List<SPBDetail> listSPBDetail;
  final List<SPBLoader> listSPBLoader;
  const EditSPBScreen(
      {Key? key,
      required this.spb,
      required this.listSPBDetail,
      required this.listSPBLoader})
      : super(key: key);

  @override
  State<EditSPBScreen> createState() => _EditSPBScreenState();
}

class _EditSPBScreenState extends State<EditSPBScreen> {
  @override
  void initState() {
    context.read<EditSPBNotifier>().onInitEdit(
        context, widget.spb, widget.listSPBDetail, widget.listSPBLoader);
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
      child: Consumer<EditSPBNotifier>(builder: (context, editSPB, child) {
        return DefaultTabController(
          initialIndex: 0,
          length: 3,
          child: MediaQuery(
            data: Style.mediaQueryText(context),
            child: Scaffold(
              appBar: AppBar(
                title: Text('Ubah Data SPB'),
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(
                      icon: Text("Detail"),
                    ),
                    Tab(
                      icon: Text("OPH (${editSPB.listSPBDetail.length})"),
                    ),
                    Tab(
                      icon: Text("Loader (${editSPB.spbLoaderList.length})"),
                    ),
                  ],
                ),
              ),
              body: TabBarView(children: <Widget>[
                EditSPBDetailTab(),
                EditSPBOPHTab(),
                EditSPBLoaderTab()
              ]),
            ),
          ),
        );
      }),
    );
  }
}
