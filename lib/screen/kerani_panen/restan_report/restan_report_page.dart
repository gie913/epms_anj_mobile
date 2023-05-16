import 'package:epms/screen/kerani_panen/restan_report/restan_report_notifier.dart';
import 'package:epms/screen/kerani_panen/restan_report/restan_report_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class RestanReportPage extends StatefulWidget {
  final String method;

  const RestanReportPage({Key? key, required this.method}) : super(key: key);

  @override
  _RestanReportPageState createState() => _RestanReportPageState();
}

class _RestanReportPageState extends State<RestanReportPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => RestanReportNotifier(),
        child: RestanReportScreen(method: widget.method));
  }
}
