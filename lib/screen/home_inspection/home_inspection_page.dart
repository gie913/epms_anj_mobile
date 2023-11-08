import 'package:epms/screen/home_inspection/home_inspection_notifier.dart';
import 'package:epms/screen/home_inspection/home_inspection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeInspectionPage extends StatefulWidget {
  const HomeInspectionPage({super.key});

  @override
  State<HomeInspectionPage> createState() => _HomeInspectionPageState();
}

class _HomeInspectionPageState extends State<HomeInspectionPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HomeInspectionNotifier(),
        child: HomeInspectionScreen());
  }
}
