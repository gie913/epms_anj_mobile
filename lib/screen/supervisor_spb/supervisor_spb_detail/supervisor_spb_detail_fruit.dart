import 'package:epms/base/ui/style.dart';
import 'package:epms/screen/supervisor_spb/supervisor_spb_detail/supervisor_spb_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorSPBDetailFruit extends StatefulWidget {
  const SupervisorSPBDetailFruit({Key? key}) : super(key: key);

  @override
  State<SupervisorSPBDetailFruit> createState() => _SupervisorSPBDetailFruitState();
}

class _SupervisorSPBDetailFruitState extends State<SupervisorSPBDetailFruit> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SupervisorSPBDetailNotifier>(
        builder: (context, notifier, child) {
          return                 SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(children: [
                  Table(
                      defaultVerticalAlignment:
                      TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        TableRow(
                          children: <Widget>[
                            Container(
                              width: 110,
                              child: Column(children: [
                                SizedBox(height: 12),
                                Text("Masak"),
                                SizedBox(height: 6),
                              ]),
                            ),
                            Container(
                              width: 110,
                              child: Column(children: [
                                SizedBox(height: 12),
                                Text("Lewat Masak"),
                                SizedBox(height: 6),
                              ]),
                            ),
                            Container(
                              width: 110,
                              child: Column(children: [
                                SizedBox(height: 12),
                                Text("Mengkal"),
                                SizedBox(height: 6),
                              ]),
                            ),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            Container(
                              width: 100,
                              padding:
                              EdgeInsets.symmetric(horizontal: 16),
                              child: Text("${notifier.spbSupervise.bunchesRipe}", style: Style.textBold18, textAlign: TextAlign.center,)
                            ),
                            Container(
                              width: 100,
                              padding:
                              EdgeInsets.symmetric(horizontal: 16),
                              child: Text("${notifier.spbSupervise.bunchesOverripe}", style: Style.textBold18, textAlign: TextAlign.center,)
                            ),
                            Container(
                              width: 100,
                              padding:
                              EdgeInsets.symmetric(horizontal: 16),
                              child: Text("${notifier.spbSupervise.bunchesHalfripe}", style: Style.textBold18, textAlign: TextAlign.center,)
                            ),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            Container(
                              width: 110,
                              child: Column(children: [
                                SizedBox(height: 12),
                                Text("Mentah"),
                                SizedBox(height: 6),
                              ]),
                            ),
                            Container(
                              width: 110,
                              child: Column(children: [
                                SizedBox(height: 12),
                                Text("Tidak Normal"),
                                SizedBox(height: 6),
                              ]),
                            ),
                            Container(
                              width: 110,
                              child: Column(children: [
                                SizedBox(height: 12),
                                Text("Janjang Kosong"),
                                SizedBox(height: 6),
                              ]),
                            ),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            Container(
                              width: 100,
                              padding:
                              EdgeInsets.symmetric(horizontal: 16),
                              child: Text("${notifier.spbSupervise.bunchesUnripe}", style: Style.textBold18, textAlign: TextAlign.center,)
                            ),
                            Container(
                              width: 100,
                              padding:
                              EdgeInsets.symmetric(horizontal: 16),
                              child: Text("${notifier.spbSupervise.bunchesAbnormal}", style: Style.textBold18, textAlign: TextAlign.center,)
                            ),
                            Container(
                              width: 100,
                              padding:
                              EdgeInsets.symmetric(horizontal: 16),
                              child: Text("${notifier.spbSupervise.bunchesEmpty}", style: Style.textBold18, textAlign: TextAlign.center,)
                            ),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            Container(
                              width: 110,
                              child: Column(children: [
                                SizedBox(height: 12),
                                Text("Total Janjang"),
                                SizedBox(height: 6),
                              ]),
                            ),
                            Container(
                              width: 110,
                              child: Column(children: [
                                SizedBox(height: 12),
                                Text("Brondolan (Kg)"),
                                SizedBox(height: 6),
                              ]),
                            ),
                            Container(
                              width: 110,
                              child: Column(children: [
                                SizedBox(height: 12),
                                Container(
                                    width: 100,
                                    child: Text(
                                      "Total Janjang Normal",
                                      textAlign: TextAlign.center,
                                    )),
                                SizedBox(height: 6),
                              ]),
                            ),
                          ],
                        ),
                        TableRow(children: <Widget>[
                          Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text("${notifier.spbSupervise.bunchesTotal}", style: Style.textBold18, textAlign: TextAlign.center,)
                          ),
                          Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text("${notifier.spbSupervise.looseFruits}", style: Style.textBold18, textAlign: TextAlign.center,)
                          ),
                          Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text("${notifier.spbSupervise.bunchesTotalNormal}", style: Style.textBold18, textAlign: TextAlign.center,)
                          ),
                        ]),
                      ]),
                  SizedBox(height: 30),
                  Text("KUALITAS JANJANG", style: Style.textBold16),
                  SizedBox(height: 20),
                  Table(
                      defaultVerticalAlignment:
                      TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        TableRow(
                          children: <Widget>[
                            Container(
                              width: 110,
                              child: Column(children: [
                                SizedBox(height: 12),
                                Text("Janjang tangkai panjang", textAlign: TextAlign.center),
                                SizedBox(height: 6),
                              ]),
                            ),
                            Container(
                              width: 110,
                              child: Column(children: [
                                SizedBox(height: 12),
                                Text("Catatan janjang tangkai panjang", textAlign: TextAlign.center),
                                SizedBox(height: 6),
                              ]),
                            ),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            Container(
                              width: 100,
                              padding:
                              EdgeInsets.symmetric(horizontal: 16),
                              child: Text("${notifier.spbSupervise.bunchesTotal}", style: Style.textBold18, textAlign: TextAlign.center,)
                            ),
                            Container(
                              width: 100,
                              padding:
                              EdgeInsets.symmetric(horizontal: 16),
                              child: Text("${notifier.spbSupervise.catatanBunchesTangkaiPanjang}", textAlign: TextAlign.center,)
                            ),
                          ],
                        ),
                      ]),
                  SizedBox(height: 30),
                  Text("KUALITAS BRONDOLAN", style: Style.textBold16),
                  SizedBox(height: 20),
                  Table(
                      defaultVerticalAlignment:
                      TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        TableRow(
                          children: <Widget>[
                            Container(
                              width: 110,
                              child: Column(children: [
                                SizedBox(height: 12),
                                Text("Sampah"),
                                SizedBox(height: 6),
                              ]),
                            ),
                            Container(
                              width: 110,
                              child: Column(children: [
                                SizedBox(height: 12),
                                Text("Batu"),
                                SizedBox(height: 6),
                              ]),
                            ),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            Container(
                              width: 100,
                              padding:
                              EdgeInsets.symmetric(horizontal: 16),
                              child: Text("${notifier.spbSupervise.bunchesSampah}", style: Style.textBold18, textAlign: TextAlign.center,)
                            ),
                            Container(
                              width: 100,
                              padding:
                              EdgeInsets.symmetric(horizontal: 16),
                              child: Text("${notifier.spbSupervise.bunchesBatu}", style: Style.textBold18, textAlign: TextAlign.center,)
                            ),
                          ],
                        ),
                      ]),
                  SizedBox(height: 30),
                  Column(
                    children: [
                      Text("Catatan"),
                      Container(
                        child: Text("${notifier.spbSupervise.supervisiNotes}", textAlign: TextAlign.center,)
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          );
        }
    );
  }
}
