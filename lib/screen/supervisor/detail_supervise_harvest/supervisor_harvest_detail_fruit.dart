import 'package:epms/base/ui/style.dart';
import 'package:epms/screen/supervisor/detail_supervise_harvest/detail_supervise_harvest_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuperviseHarvestDetailFruit extends StatefulWidget {
  const SuperviseHarvestDetailFruit({Key? key}) : super(key: key);

  @override
  State<SuperviseHarvestDetailFruit> createState() => _SuperviseHarvestDetailFruitState();
}

class _SuperviseHarvestDetailFruitState extends State<SuperviseHarvestDetailFruit> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailSuperviseHarvestNotifier>(
      builder: (context, notifier, child) {
        return           Center(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(children: [
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("Masak"),
                          SizedBox(height:20),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("Lewat Masak"),
                          SizedBox(height:20),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("Mengkal"),
                          SizedBox(height:20),
                        ]),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text(
                            "${notifier.ophSupervise?.bunchesRipe ?? 0}",
                            style: Style.textBold20
                          ),
                          SizedBox(height: 20),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text(
                            "${notifier.ophSupervise?.bunchesOverripe ?? 0}",
                            style: Style.textBold20,
                          ),
                          SizedBox(height: 20),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text(
                            "${notifier.ophSupervise?.bunchesHalfripe ?? 0}",
                            style: Style.textBold20,
                          ),
                          SizedBox(height: 20),
                        ]),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("Mentah"),
                          SizedBox(height:20),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("Tidak Normal"),
                          SizedBox(height:20),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("Janjang Kosong"),
                          SizedBox(height:20),
                        ]),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("${notifier.ophSupervise?.bunchesUnripe ?? 0}",
                              style: Style.textBold20),
                          SizedBox(height: 20),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("${notifier.ophSupervise?.bunchesAbnormal ?? 0}",
                              style: Style.textBold20),
                          SizedBox(height: 20),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("${notifier.ophSupervise?.bunchesEmpty ?? 0}",
                              style: Style.textBold20),
                          SizedBox(height: 20),
                        ]),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("Total Janjang"),
                          SizedBox(height:20),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("Brondolan (Kg)"),
                          SizedBox(height:20),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Container(
                              width: 100,
                              child: Text(
                                "Janjang Tidak Dikirim",
                                textAlign: TextAlign.center,
                              )),
                          SizedBox(height:20),
                        ]),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("${notifier.ophSupervise?.bunchesTotal ?? 0}",
                              style: Style.textBold20),
                          SizedBox(height: 20),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("${notifier.ophSupervise?.looseFruits ?? 0}",
                              style: Style.textBold20),
                          SizedBox(height: 20),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("${notifier.ophSupervise?.bunchesNotSent ?? 0}",
                              style: Style.textBold20),
                          SizedBox(height: 20),
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(children: [
                Text(
                    "Catatan (${notifier.ophSupervise?.supervisiNotes != null ? 50 - notifier.ophSupervise!.supervisiNotes!.length : 50})"),
                SizedBox(height:20),
                Text("${notifier.ophSupervise?.supervisiNotes ?? "Tidak ada catatan"}")
              ]),
            ]),
          ),
        );

      }
    );
  }
}
