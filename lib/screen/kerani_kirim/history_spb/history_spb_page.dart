import 'package:epms/screen/kerani_kirim/history_spb/history_spb_notifier.dart';
import 'package:epms/screen/kerani_kirim/history_spb/history_spb_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistorySPBPage extends StatefulWidget {
  final String method;
  const HistorySPBPage({Key? key, required this.method}) : super(key: key);

  @override
  _HistorySPBPageState createState() => _HistorySPBPageState();
}

class _HistorySPBPageState extends State<HistorySPBPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HistorySPBNotifier(), child: HistorySPBScreen(method: widget.method,));
  }
}
