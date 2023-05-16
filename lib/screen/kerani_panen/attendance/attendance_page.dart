import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'attendance_notifier.dart';
import 'attendance_screen.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AttendanceNotifier(), child: AttendanceScreen());
  }
}
