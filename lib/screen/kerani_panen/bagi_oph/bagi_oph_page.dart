import 'package:epms/screen/kerani_panen/bagi_oph/bagi_oph_notifier.dart';
import 'package:epms/screen/kerani_panen/bagi_oph/bagi_oph_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BagiOPHPage extends StatefulWidget {
  const BagiOPHPage({Key? key}) : super(key: key);

  @override
  _BagiOPHPageState createState() => _BagiOPHPageState();
}

class _BagiOPHPageState extends State<BagiOPHPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => BagiOPHNotifier(),
        child: BagiOPHScreen());
  }
}
