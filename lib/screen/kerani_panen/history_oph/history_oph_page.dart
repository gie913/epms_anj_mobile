import 'package:epms/screen/kerani_panen/history_oph/history_oph_notifier.dart';
import 'package:epms/screen/kerani_panen/history_oph/history_oph_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryOPHPage extends StatefulWidget {
  final String method;
  const HistoryOPHPage({Key? key, required this.method}) : super(key: key);

  @override
  _HistoryOPHPageState createState() => _HistoryOPHPageState();
}

class _HistoryOPHPageState extends State<HistoryOPHPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HistoryOPHNotifier(), child: HistoryOPHScreen(method: widget.method));
  }
}
