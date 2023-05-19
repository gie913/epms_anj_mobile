import 'package:epms/base/ui/style.dart';
import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_detail/supervisor_tbs_luar_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SupervisorTBSSortasiEdit extends StatefulWidget {
  const SupervisorTBSSortasiEdit({Key? key}) : super(key: key);

  @override
  State<SupervisorTBSSortasiEdit> createState() =>
      _SupervisorTBSSortasiEditState();
}

class _SupervisorTBSSortasiEditState extends State<SupervisorTBSSortasiEdit> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SupervisorTBSLuarDetailNotifier>(
        builder: (context, notifier, child) {
      return SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(children: [
              Container(height: 60,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: <Widget>[
                    Text("Tipe Input"),
                    Flexible(child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: ListTile(
                            title: const Text('Kg'),
                            leading: Radio<int>(
                              value: 1,
                              groupValue: notifier.tbsLuar?.formType,
                              onChanged: (int? value) {
                                notifier.onChangeFormType(value!);
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          child: ListTile(
                            title: const Text('%'),
                            leading: Radio<int>(
                              value: 2,
                              groupValue: notifier.tbsLuar?.formType,
                              onChanged: (int? value) {
                                notifier.onChangeFormType(value!);
                              },
                            ),
                          ),
                        ),
                      ],
                    ))
                  ],
                ),),
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
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: notifier.bunchesUnRipe,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Style.textBold20,
                            decoration: InputDecoration(hintText: "0"),
                            onChanged: (value) {
                              notifier.countBunchesTBSLuar(
                                  context, notifier.bunchesUnRipe);
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: notifier.bunchesHalfRipe,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Style.textBold20,
                            decoration: InputDecoration(hintText: "0"),
                            onChanged: (value) {
                              notifier.countBunchesTBSLuar(
                                  context, notifier.bunchesHalfRipe);
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: notifier.bunchesOverRipe,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Style.textBold20,
                            decoration: InputDecoration(hintText: "0"),
                            onChanged: (value) {
                              notifier.countBunchesTBSLuar(
                                  context, notifier.bunchesOverRipe);
                            },
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
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: notifier.bunchesRotten,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Style.textBold20,
                            decoration: InputDecoration(hintText: "0"),
                            onChanged: (value) {
                              notifier.countBunchesTBSLuar(
                                  context, notifier.bunchesRotten);
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: notifier.bunchesAbnormal,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Style.textBold20,
                            decoration: InputDecoration(hintText: "0"),
                            onChanged: (value) {
                              notifier.countBunchesTBSLuar(
                                  context, notifier.bunchesAbnormal);
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: notifier.bunchesEmpty,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Style.textBold20,
                            decoration: InputDecoration(hintText: "0"),
                            onChanged: (value) {
                              notifier.countBunchesTBSLuar(
                                  context, notifier.bunchesEmpty);
                            },
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
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: notifier.rubbish,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Style.textBold20,
                            decoration: InputDecoration(hintText: "0"),
                            onChanged: (value) {
                              notifier.countBunchesTBSLuar(context, notifier.rubbish);
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: notifier.water,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Style.textBold20,
                            decoration: InputDecoration(hintText: "0"),
                            onChanged: (value) {
                              notifier.countBunchesTBSLuar(context, notifier.water);
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: notifier.longStalk,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Style.textBold20,
                            decoration: InputDecoration(hintText: "0"),
                            onChanged: (value) {
                              notifier.countBunchesTBSLuar(
                                  context, notifier.longStalk);
                            },
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
                    //       padding: EdgeInsets.symmetric(horizontal: 16),
                    //       child: TextFormField(
                    //         controller: notifier.brondolanRotten,
                    //         keyboardType: TextInputType.number,
                    //         textAlign: TextAlign.center,
                    //         style: Style.textBold20,
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.allow(
                    //               RegExp(r'[0-9]')),
                    //         ],
                    //         decoration: InputDecoration(hintText: "0"),
                    //         onChanged: (value) {
                    //           notifier.countBunchesTBSLuar(
                    //               context, notifier.brondolanRotten);
                    //         },
                    //       ),
                    //     ),
                    //     Container(
                    //       width: 100,
                    //       padding: EdgeInsets.symmetric(horizontal: 16),
                    //       child: TextFormField(
                    //         controller: notifier.bunchesLess4Kg,
                    //         keyboardType: TextInputType.number,
                    //         textAlign: TextAlign.center,
                    //         style: Style.textBold20,
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.allow(
                    //               RegExp(r'[0-9]')),
                    //         ],
                    //         decoration: InputDecoration(hintText: "0"),
                    //         onChanged: (value) {
                    //           notifier.countBunchesTBSLuar(
                    //               context, notifier.bunchesLess4Kg);
                    //         },
                    //       ),
                    //     ),
                    //     Container(
                    //       width: 100,
                    //       padding: EdgeInsets.symmetric(horizontal: 16),
                    //       child: TextFormField(
                    //         controller: notifier.bunchesCengkeh,
                    //         keyboardType: TextInputType.number,
                    //         textAlign: TextAlign.center,
                    //         style: Style.textBold20,
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.allow(
                    //               RegExp(r'[0-9]')),
                    //         ],
                    //         decoration: InputDecoration(hintText: "0"),
                    //         onChanged: (value) {
                    //           notifier.countBunchesTBSLuar(
                    //               context, notifier.bunchesCengkeh);
                    //         },
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
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: notifier.bunchesTotal,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Style.textBold20,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration: InputDecoration(hintText: "0"),
                            onChanged: (value) {
                              notifier.countBunchesTBSLuar(
                                  context, notifier.bunchesTotal);
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            enabled: false,
                            controller: notifier.deduction,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Style.textBold20,
                            decoration: InputDecoration(hintText: "0"),
                            onChanged: (value) {
                              notifier.countBunchesTBSLuar(
                                  context, notifier.deduction);
                            },
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
                          child: TextFormField(
                            controller: notifier.bunchesSmall,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Style.textBold20,
                            decoration: InputDecoration(hintText: "0"),
                            onChanged: (value) {
                              notifier.countBunchesTBSLuar(
                                  context, notifier.bunchesSmall);
                            },
                          ),
                        ),
                        // Container(
                        //   width: 100,
                        //   padding: EdgeInsets.symmetric(horizontal: 16),
                        //   child: TextFormField(
                        //     controller: notifier.bunchesMedium,
                        //     keyboardType: TextInputType.number,
                        //     textAlign: TextAlign.center,
                        //     style: Style.textBold20,
                        //     decoration: InputDecoration(hintText: "0"),
                        //     inputFormatters: [
                        //       FilteringTextInputFormatter.allow(
                        //           RegExp(r'[0-9]')),
                        //     ],
                        //     onChanged: (value) {
                        //       notifier.countBunchesTBSLuar(
                        //           context, notifier.bunchesMedium);
                        //     },
                        //   ),
                        // ),
                        // Container(
                        //   width: 100,
                        //   padding: EdgeInsets.symmetric(horizontal: 16),
                        //   child: TextFormField(
                        //     controller: notifier.bunchesLarge,
                        //     keyboardType: TextInputType.number,
                        //     textAlign: TextAlign.center,
                        //     style: Style.textBold20,
                        //     decoration: InputDecoration(hintText: "0"),
                        //     inputFormatters: [
                        //       FilteringTextInputFormatter.allow(
                        //           RegExp(r'[0-9]')),
                        //     ],
                        //     onChanged: (value) {
                        //       notifier.countBunchesTBSLuar(
                        //           context, notifier.bunchesLarge);
                        //     },
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
                    child: TextFormField(
                      controller: notifier.notesOPH,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(hintText: "Catatan"),
                      keyboardType: TextInputType.multiline,
                      maxLength: 50,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
