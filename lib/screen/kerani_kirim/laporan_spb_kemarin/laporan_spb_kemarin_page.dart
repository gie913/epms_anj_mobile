import 'package:epms/screen/kerani_kirim/laporan_spb_kemarin/laporan_spb_kemarin_notifier.dart';
import 'package:epms/screen/kerani_kirim/laporan_spb_kemarin/laporan_spb_kemarin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LaporanSPBKemarinPage extends StatefulWidget {
  const LaporanSPBKemarinPage({Key? key}) : super(key: key);

  @override
  State<LaporanSPBKemarinPage> createState() => _LaporanSPBKemarinPageState();
}

class _LaporanSPBKemarinPageState extends State<LaporanSPBKemarinPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LaporanSPBKemarinNotifier(),
        child: LaporanSPBKemarinScreen());
  }
}
