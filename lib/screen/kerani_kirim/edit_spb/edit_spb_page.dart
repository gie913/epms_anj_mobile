import 'package:epms/model/spb.dart';
import 'package:epms/model/spb_detail.dart';
import 'package:epms/model/spb_loader.dart';
import 'package:epms/screen/kerani_kirim/edit_spb/edit_spb_notifier.dart';
import 'package:epms/screen/kerani_kirim/edit_spb/edit_spb_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditSPBPage extends StatefulWidget {
  final SPB spb;
  final List<SPBDetail> spbDetail;
  final List<SPBLoader> spbLoader;

  const EditSPBPage(
      {Key? key,
      required this.spb,
      required this.spbDetail,
      required this.spbLoader})
      : super(key: key);

  @override
  State<EditSPBPage> createState() => _EditSPBPageState();
}

class _EditSPBPageState extends State<EditSPBPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => EditSPBNotifier(),
        child: EditSPBScreen(
          spb: widget.spb,
          listSPBDetail: widget.spbDetail,
          listSPBLoader: widget.spbLoader,
        ));
  }
}
