import 'package:epms/base/ui/style.dart';
import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_detail/supervisor_tbs_luar_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorTBSLuarDetailSortasi extends StatefulWidget {
  const SupervisorTBSLuarDetailSortasi({Key? key}) : super(key: key);

  @override
  State<SupervisorTBSLuarDetailSortasi> createState() =>
      _SupervisorTBSLuarDetailSortasiState();
}

class _SupervisorTBSLuarDetailSortasiState
    extends State<SupervisorTBSLuarDetailSortasi> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SupervisorTBSLuarDetailNotifier>(
        builder: (context, notifier, child) {
      return SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(children: [
              Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: <Widget>[
                    Text("Tipe Input"),
                    Flexible(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: ListTile(
                            title: const Text('Kg'),
                            leading: Radio<int>(
                              value: 1,
                              groupValue: notifier.tbsLuar!.formType,
                              onChanged: (int? value) {},
                            ),
                          ),
                        ),
                        Flexible(
                          child: ListTile(
                            title: const Text('%'),
                            leading: Radio<int>(
                              value: 2,
                              groupValue: notifier.tbsLuar!.formType!,
                              onChanged: (int? value) {},
                            ),
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              Divider(),
              Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
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
                            Text("Mengkal"),
                            SizedBox(height: 6),
                          ]),
                        ),
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text("Terlalu Masak"),
                            SizedBox(height: 6),
                          ]),
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Text(
                            "${notifier.tbsLuar?.bunchesUnripe}",
                            style: Style.textBold18,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Text(
                            "${notifier.tbsLuar?.bunchesHalfripe}",
                            style: Style.textBold18,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Text(
                            "${notifier.tbsLuar?.bunchesOverripe}",
                            style: Style.textBold18,
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
                            Text("Busuk"),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Text(
                            "${notifier.tbsLuar?.bunchesRotten}",
                            style: Style.textBold18,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Text(
                            "${notifier.tbsLuar?.bunchesAbnormal}",
                            style: Style.textBold18,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Text(
                            "${notifier.tbsLuar?.bunchesEmpty}",
                            style: Style.textBold18,
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
                            Text("Sampah"),
                            SizedBox(height: 6),
                          ]),
                        ),
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text("Air"),
                            SizedBox(height: 6),
                          ]),
                        ),
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text("Tangkai Panjang"),
                            SizedBox(height: 6),
                          ]),
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Text(
                            "${notifier.tbsLuar?.rubbish}",
                            style: Style.textBold18,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Text(
                            "${notifier.tbsLuar?.water}",
                            style: Style.textBold18,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Text(
                            "${notifier.tbsLuar?.longStalk}",
                            style: Style.textBold18,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    // TableRow(
                    //   children: <Widget>[
                    //     Container(
                    //       width: 110,
                    //       child: Column(children: [
                    //         SizedBox(height: 12),
                    //         Text("Brondolan Busuk"),
                    //         SizedBox(height: 6),
                    //       ]),
                    //     ),
                    //     Container(
                    //       width: 110,
                    //       child: Column(children: [
                    //         SizedBox(height: 12),
                    //         Text("Buah < 4 kg"),
                    //         SizedBox(height: 6),
                    //       ]),
                    //     ),
                    //     Container(
                    //       width: 110,
                    //       child: Column(children: [
                    //         SizedBox(height: 12),
                    //         Text("Buah Cengkeh"),
                    //         SizedBox(height: 6),
                    //       ]),
                    //     ),
                    //   ],
                    // ),
                    // TableRow(
                    //   children: <Widget>[
                    //     Container(
                    //       width: 100,
                    //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    //       child: Text("${notifier.tbsLuar?.brondolanRotten}",
                    //           style: Style.textBold18,
                    //           textAlign: TextAlign.center,
                    //       ),
                    //     ),
                    //     Container(
                    //       width: 100,
                    //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    //       child: Text("${notifier.tbsLuar?.bunchesLess4Kg}",
                    //         style: Style.textBold18,
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ),
                    //     Container(
                    //       width: 100,
                    //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    //       child: Text("${notifier.tbsLuar?.bunchesCengkeh}",
                    //         style: Style.textBold18,
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ]),
              SizedBox(height: 30),
              Divider(),
              SizedBox(height: 20),
              Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text("Jumlah Janjang", textAlign: TextAlign.center),
                            SizedBox(height: 6),
                          ]),
                        ),
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text("Potongan", textAlign: TextAlign.center),
                            SizedBox(height: 6),
                          ]),
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Text(
                            "${notifier.tbsLuar?.bunchesTotal}",
                            style: Style.textBold18,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Text(
                            "${notifier.tbsLuar?.deduction}",
                            style: Style.textBold18,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ]),
              SizedBox(height: 30),
              Text("KOMIDAL", style: Style.textBold16),
              SizedBox(height: 20),
              Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text(
                              "BJR",
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 6),
                          ]),
                        ),
                        // Container(
                        //   width: 110,
                        //   child: Column(children: [
                        //     SizedBox(height: 12),
                        //     Text(
                        //       "Sedang",
                        //       textAlign: TextAlign.center,
                        //     ),
                        //     SizedBox(height: 6),
                        //   ]),
                        // ),
                        // Container(
                        //   width: 110,
                        //   child: Column(children: [
                        //     SizedBox(height: 12),
                        //     Text(
                        //       "Besar",
                        //       textAlign: TextAlign.center,
                        //     ),
                        //     SizedBox(height: 6),
                        //   ]),
                        // ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "${notifier.tbsLuar?.small}",
                            style: Style.textBold18,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Container(
                        //   width: 100,
                        //   padding: EdgeInsets.symmetric(horizontal: 16),
                        //   child: Text("${notifier.tbsLuar?.medium}",
                        //     style: Style.textBold18,
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ),
                        // Container(
                        //   width: 100,
                        //   padding: EdgeInsets.symmetric(horizontal: 16),
                        //   child: Text("${notifier.tbsLuar?.large}",
                        //     style: Style.textBold18,
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ),
                      ],
                    ),
                  ]),
              SizedBox(height: 30),
              Column(
                children: [
                  Text("Catatan"),
                  Container(
                    width: 100,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "${notifier.tbsLuar?.notes ?? ""}",
                      style: Style.textBold18,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      );
    });
  }
}
