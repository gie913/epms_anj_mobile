import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'form_spb_notifier.dart';
import 'form_spb_screen.dart';

class FormSPBPage extends StatefulWidget {
  const FormSPBPage({Key? key}) : super(key: key);

  @override
  _FormSPBPageState createState() => _FormSPBPageState();
}

class _FormSPBPageState extends State<FormSPBPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => FormSPBNotifier(), child: FormSPBScreen());
  }
}
