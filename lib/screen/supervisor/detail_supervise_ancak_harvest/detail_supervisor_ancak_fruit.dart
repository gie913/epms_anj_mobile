import 'package:epms/base/ui/style.dart';
import 'package:epms/screen/supervisor/detail_supervise_ancak_harvest/detail_supervisor_ancak_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailSupervisorAncakFormFruit extends StatefulWidget {
  const DetailSupervisorAncakFormFruit({Key? key}) : super(key: key);

  @override
  State<DetailSupervisorAncakFormFruit> createState() =>
      _DetailSupervisorAncakFormFruitState();
}

class _DetailSupervisorAncakFormFruitState
    extends State<DetailSupervisorAncakFormFruit> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailSupervisorAncakNotifier>(
        builder: (context, notifier, child) {
      return SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(children: [
              Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text("Pokok Panen"),
                            SizedBox(height: 20),
                          ]),
                        ),
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text("Total Janjang"),
                            SizedBox(height: 20),
                          ]),
                        ),
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text("Total Brondolan"),
                            SizedBox(height: 20),
                          ]),
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Container(
                          width: 110,
                          child: Text(
                            "${notifier.ophSuperviseAncak?.pokokSample ?? "0"}",
                            style: Style.textBold20,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 110,
                          child: Text(
                            "${notifier.ophSuperviseAncak?.bunchesTotal}",
                            style: Style.textBold20,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 110,
                          child: Text(
                            "${notifier.ophSuperviseAncak?.looseFruits}",
                            style: Style.textBold20,
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    TableRow(children: <Widget>[
                      Container(
                        height: 80,
                      ),
                      Text("KUALITAS ANCAK", style: Style.textBold14),
                      Container(
                        height: 80,
                      )
                    ]),
                    TableRow(
                      children: <Widget>[
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text("Rat"),
                            SizedBox(height: 20),
                          ]),
                        ),
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text("V Cut"),
                            SizedBox(height: 20),
                          ]),
                        ),
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text("Tangkai Panjang"),
                            SizedBox(height: 20),
                          ]),
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Container(
                          width: 110,
                          child: Text(
                            "${notifier.ophSuperviseAncak?.bunchesRat}",
                            style: Style.textBold20,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 110,
                          child: Text(
                            "${notifier.ophSuperviseAncak?.bunchesVCut}",
                            style: Style.textBold20,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 110,
                          child: Text(
                            "${notifier.ophSuperviseAncak?.bunchesTangkaiPanjang}",
                            style: Style.textBold20,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text("Pelepah Sengkleh", textAlign: TextAlign.center,),
                            SizedBox(height: 20),
                          ]),
                        ),
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text("Janjang Tinggal", textAlign: TextAlign.center,),
                            SizedBox(height: 20),
                          ]),
                        ),
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text("Brondolan Tinggal", textAlign: TextAlign.center,),
                            SizedBox(height: 20),
                          ]),
                        ),
                      ],
                    ),
                    TableRow(children: <Widget>[
                      Container(
                        width: 110,
                        child: Text(
                          "${notifier.ophSuperviseAncak?.pelepahSengkleh}",
                          style: Style.textBold20,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: 110,
                        child: Text(
                          "${notifier.ophSuperviseAncak?.bunchesTinggal}",
                          style: Style.textBold20,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: 110,
                        child: Text(
                          "${notifier.ophSuperviseAncak?.bunchesBrondolanTinggal}",
                          style: Style.textBold20,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
                  ]),
              SizedBox(height: 30),
              Column(
                children: [
                  Text("Catatan"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "${notifier.ophSuperviseAncak?.supervisiAncakNotes}"),
                  )
                ],
              ),
            ]),
          ),
        ),
      );
    });
  }
}
