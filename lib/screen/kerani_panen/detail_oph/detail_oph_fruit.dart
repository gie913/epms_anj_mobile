import 'package:epms/base/ui/style.dart';
import 'package:epms/screen/kerani_panen/detail_oph/detail_oph_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailOPHFruit extends StatefulWidget {
  const DetailOPHFruit({Key? key}) : super(key: key);

  @override
  State<DetailOPHFruit> createState() => _DetailOPHFruitState();
}

class _DetailOPHFruitState extends State<DetailOPHFruit> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailOPHNotifier>(builder: (context, notifier, child) {
      return SingleChildScrollView(
        child: Center(
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
                          SizedBox(height: 8),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("Lewat Masak"),
                          SizedBox(height: 8),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("Mengkal"),
                          SizedBox(height: 8),
                        ]),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Container(
                        width: 110,
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${notifier.oph.bunchesRipe ?? 0}",
                              style: Style.textBold20,
                            ),
                          ),
                          SizedBox(height: 20),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text(
                            "${notifier.oph.bunchesOverripe ?? 0}",
                            style: Style.textBold20,
                          ),
                          SizedBox(height: 20),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text(
                            "${notifier.oph.bunchesHalfripe ?? 0}",
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
                          SizedBox(height: 8),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("Tidak Normal"),
                          SizedBox(height: 8),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("Janjang Kosong"),
                          SizedBox(height: 8),
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
                            "${notifier.oph.bunchesUnripe ?? 0}",
                            style: Style.textBold20,
                          ),
                          SizedBox(height: 20),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text(
                            "${notifier.oph.bunchesAbnormal ?? 0}",
                            style: Style.textBold20,
                          ),
                          SizedBox(height: 20),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text(
                            "${notifier.oph.bunchesEmpty ?? 0}",
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
                          Text("Total Janjang"),
                          SizedBox(height: 8),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("Brondolan (Kg)"),
                          SizedBox(height: 8),
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
                          SizedBox(height: 8),
                        ]),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text("${notifier.oph.bunchesTotal ?? 0}",
                              style: Style.textBold20),
                          SizedBox(height: 20),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text(
                            "${notifier.oph.looseFruits ?? 0}",
                            style: Style.textBold20,
                          ),
                          SizedBox(height: 20),
                        ]),
                      ),
                      Container(
                        width: 110,
                        child: Column(children: [
                          Text(
                            "${notifier.oph.bunchesNotSent ?? 0}",
                            style: Style.textBold20,
                          ),
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
                    "Catatan (${notifier.oph.ophNotes != null ? 50 - notifier.oph.ophNotes!.length : 50})"),
                SizedBox(height: 8),
                Text("${notifier.oph.ophNotes ?? "Tidak ada catatan"}")
              ]),
            ]),
          ),
        ),
      );
    });
  }
}
