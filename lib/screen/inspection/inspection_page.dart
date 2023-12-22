import 'package:epms/screen/inspection/inspection_notifier.dart';
import 'package:epms/screen/inspection/inspection_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InspectionPage extends StatefulWidget {
  const InspectionPage({super.key, this.arguments = ''});

  final String arguments;

  @override
  State<InspectionPage> createState() => _InspectionPageState();
}

class _InspectionPageState extends State<InspectionPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => InspectionNotifier(),
      child: InspectionView(arguments: widget.arguments),
    );
  }
}
