import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/bunches_formatter.dart';
import 'package:epms/screen/supervisor/supervisor_ancak_harvest_form/supervisor_ancak_harvest_form_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SupervisorAncakFormFruit extends StatefulWidget {
  const SupervisorAncakFormFruit({Key? key}) : super(key: key);

  @override
  State<SupervisorAncakFormFruit> createState() =>
      _SupervisorAncakFormFruitState();
}

class _SupervisorAncakFormFruitState extends State<SupervisorAncakFormFruit> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SupervisorAncakFormNotifier>(
        builder: (context, notifier, child) {
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
                            SizedBox(height: 12),
                            Text("Pokok Panen"),
                            SizedBox(height: 6),
                          ]),
                        ),
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
                            Text("Total Brondolan"),
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
                            controller: notifier.pokokPanen,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Style.textBold20,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              BunchesFormatter()
                            ],
                            decoration: InputDecoration(hintText: "0"),
                            onChanged: (value) {
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: notifier.totalJanjang,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Style.textBold20,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              BunchesFormatter()
                            ],
                            decoration: InputDecoration(hintText: "0"),
                            onChanged: (value) {
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: notifier.totalBrondolan,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Style.textBold20,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              BunchesFormatter()
                            ],
                            decoration: InputDecoration(hintText: "0"),
                            onChanged: (value) {
                            },
                          ),
                        ),
                      ],
                    ),
                    TableRow(children: <Widget>[
                      Container(height: 80,),
                      Text("KUALITAS ANCAK", style: Style.textBold14),
                      Container(height: 80,)
                    ]),
                    TableRow(
                      children: <Widget>[
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text("Rat"),
                            SizedBox(height: 6),
                          ]),
                        ),
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text("V Cut"),
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
                            controller: notifier.rat,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Style.textBold20,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              BunchesFormatter()
                            ],
                            decoration: InputDecoration(hintText: "0"),
                            onChanged: (value) {
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: notifier.vCut,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Style.textBold20,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              BunchesFormatter()
                            ],
                            decoration: InputDecoration(hintText: "0"),
                            onChanged: (value) {
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: notifier.tangkaiPanjang,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: Style.textBold20,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              BunchesFormatter()
                            ],
                            decoration: InputDecoration(hintText: "0"),
                            onChanged: (value) {
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
                            Text("Pelepah Sengkleh"),
                            SizedBox(height: 6),
                          ]),
                        ),
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text("Janjang Tinggal"),
                            SizedBox(height: 6),
                          ]),
                        ),
                        Container(
                          width: 110,
                          child: Column(children: [
                            SizedBox(height: 12),
                            Text("Brondolan Tinggal"),
                            SizedBox(height: 6),
                          ]),
                        ),
                      ],
                    ),
                    TableRow(children: <Widget>[
                      Container(
                        width: 100,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextFormField(
                          controller: notifier.pelepahSengkleh,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: Style.textBold20,
                          onChanged: (value) {
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            BunchesFormatter()
                          ],
                          decoration: InputDecoration(hintText: "0"),
                        ),
                      ),
                      Container(
                        width: 100,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextFormField(
                          controller: notifier.janjangTinggal,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: Style.textBold20,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            BunchesFormatter()
                          ],
                          decoration: InputDecoration(hintText: "0"),
                          onChanged: (value) {
                          },
                        ),
                      ),
                      Container(
                        width: 100,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextFormField(
                          controller: notifier.brondolanTinggal,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: Style.textBold20,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            BunchesFormatter()
                          ],
                          decoration: InputDecoration(hintText: "0"),
                          onChanged: (value) {
                          },
                        ),
                      ),
                    ]),
                  ]),
              SizedBox(height: 30),
              Column(
                children: [
                  Text("Catatan"),
                  Container(
                    child: TextFormField(
                      controller: notifier.notes,
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
