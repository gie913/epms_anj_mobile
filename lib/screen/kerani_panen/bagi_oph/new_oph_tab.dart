import 'dart:io';

import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/bunches_formatter.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/screen/qr_reader/qr_reader_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'bagi_oph_notifier.dart';

class NewOPHTab extends StatefulWidget {
  const NewOPHTab({Key? key}) : super(key: key);

  @override
  _NewOPHTabState createState() => _NewOPHTabState();
}

class _NewOPHTabState extends State<NewOPHTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BagiOPHNotifier>(builder: (context, bagiOPH, child) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("ID OPH:"),
                  Expanded(
                      child: Text("${bagiOPH.newOPH.ophId}",
                          textAlign: TextAlign.end, style: Style.textBold20))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tanggal:"),
                  Expanded(
                    child: Text(
                      "${bagiOPH.newOPH.createdDate} ${bagiOPH.newOPH.createdTime}",
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Jenis Pekerja:"),
                  Expanded(
                    child: Text(
                      "${ValueService.typeOfFormToText(bagiOPH.newOPH.ophHarvestingType ?? 1)}",
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Apakah Panen Mekanis?"),
                  Expanded(
                    child: Text(
                      "${ValueService.harvestingType(bagiOPH.newOPH.ophHarvestingMethod ?? 1)}",
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Kemandoran:"),
                    Expanded(
                      child: Container(
                        width: 200,
                        child: Text(
                            "${bagiOPH.newOPH.mandorEmployeeCode} ${bagiOPH.newOPH.mandorEmployeeName ?? ""}",
                            textAlign: TextAlign.end),
                      ),
                    )
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Pekerja:"),
                    Expanded(
                      child: Container(
                          width: 200,
                          child: Text(
                              "${bagiOPH.newOPH.employeeCode} ${bagiOPH.newOPH.employeeName ?? ""}",
                              textAlign: TextAlign.end)),
                    )
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Customer:"),
                    Expanded(
                      child: Container(
                        width: 200,
                        child: Text("${bagiOPH.newOPH.ophCustomerCode ?? ""}",
                            textAlign: TextAlign.end),
                      ),
                    )
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Estate:"),
                    Expanded(
                      child: Container(
                        width: 200,
                        child: Text("${bagiOPH.newOPH.ophEstateCode}",
                            textAlign: TextAlign.end),
                      ),
                    )
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Divisi:"),
                    Expanded(
                      child: Container(
                        width: 200,
                        child: Text(
                            "${bagiOPH.oph.ophDivisionCode == null || bagiOPH.oph.ophDivisionCode == "null" ? "" : bagiOPH.oph.ophDivisionCode}",
                            textAlign: TextAlign.end),
                      ),
                    )
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Blok:"),
                    Expanded(
                      child: Container(
                        width: 200,
                        child: Text("${bagiOPH.newOPH.ophBlockCode}",
                            textAlign: TextAlign.end),
                      ),
                    )
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Estimasi berat OPH (Kg):"),
                    Expanded(
                      child: Container(
                        width: 200,
                        child: Text("${bagiOPH.newOPH.ophEstimateTonnage ?? 0}",
                            textAlign: TextAlign.end),
                      ),
                    )
                  ]),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("TPH"),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("${bagiOPH.newOPH.ophTphCode}",
                                style: Style.textBold20),
                          )
                        ]),
                  ),
                  SizedBox(width: 80),
                  Flexible(
                      child: Column(children: [
                    Text("Kartu OPH"),
                    Container(
                      width: 160,
                      child: TextFormField(
                        enabled: !(bagiOPH.isNewSaved || bagiOPH.isOldSaved),
                        controller: bagiOPH.ophNumber,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.characters,
                        onChanged: (value) {
                          if (value.length >= 4) {
                            bagiOPH.cardOPHNumberCheck(context, value);
                          }
                        },
                        decoration:
                            InputDecoration(hintText: "Tulis Kartu OPH"),
                        onFieldSubmitted: (value) {
                          bagiOPH.cardOPHNumberCheck(context, value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          if (!(bagiOPH.isOldSaved || bagiOPH.isNewSaved) ==
                              true) {
                            String? result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QRReaderScreen()));
                            if (result != null) {
                              setState(() {
                                bagiOPH.ophNumber =
                                    TextEditingController(text: result);
                              });
                            }
                          } else {
                            FlushBarManager.showFlushBarWarning(
                                context,
                                "OPH Sudah tersimpah",
                                "OPH Sudah terbagi anda tidak boleh mengubah data");
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "BACA QR KARTU",
                              style: Style.whiteBold14,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    )
                  ]))
                ],
              ),
            ),
            Divider(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              enabled:
                                  !(bagiOPH.isNewSaved || bagiOPH.isOldSaved),
                              onChanged: (value) {
                                bagiOPH.countBunches(
                                    context,
                                    bagiOPH.bunchesRipe,
                                    bagiOPH.oph.bunchesRipe!);
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                BunchesFormatter()
                              ],
                              controller: bagiOPH.bunchesRipe,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(hintText: "0"),
                              style: Style.textBold20,
                            ),
                          ),
                          Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              enabled:
                                  !(bagiOPH.isNewSaved || bagiOPH.isOldSaved),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                BunchesFormatter()
                              ],
                              onChanged: (value) {
                                bagiOPH.countBunches(
                                    context,
                                    bagiOPH.bunchesOverRipe,
                                    bagiOPH.oph.bunchesOverripe!);
                              },
                              controller: bagiOPH.bunchesOverRipe,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: Style.textBold20,
                              decoration: InputDecoration(hintText: "0"),
                            ),
                          ),
                          Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              enabled:
                                  !(bagiOPH.isNewSaved || bagiOPH.isOldSaved),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                BunchesFormatter()
                              ],
                              onChanged: (value) {
                                bagiOPH.countBunches(
                                    context,
                                    bagiOPH.bunchesHalfRipe,
                                    bagiOPH.oph.bunchesHalfripe!);
                              },
                              controller: bagiOPH.bunchesHalfRipe,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: Style.textBold20,
                              decoration: InputDecoration(hintText: "0"),
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
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              enabled:
                                  !(bagiOPH.isNewSaved || bagiOPH.isOldSaved),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                BunchesFormatter()
                              ],
                              controller: bagiOPH.bunchesUnRipe,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                bagiOPH.countBunches(
                                    context,
                                    bagiOPH.bunchesUnRipe,
                                    bagiOPH.oph.bunchesUnripe!);
                              },
                              style: Style.textBold20,
                              decoration: InputDecoration(hintText: "0"),
                            ),
                          ),
                          Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              enabled:
                                  !(bagiOPH.isNewSaved || bagiOPH.isOldSaved),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                BunchesFormatter()
                              ],
                              controller: bagiOPH.bunchesAbnormal,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                bagiOPH.countBunches(
                                    context,
                                    bagiOPH.bunchesAbnormal,
                                    bagiOPH.oph.bunchesAbnormal!);
                              },
                              style: Style.textBold20,
                              decoration: InputDecoration(hintText: "0"),
                            ),
                          ),
                          Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              enabled:
                                  !(bagiOPH.isNewSaved || bagiOPH.isOldSaved),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                BunchesFormatter()
                              ],
                              controller: bagiOPH.bunchesEmpty,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                bagiOPH.countBunches(
                                    context,
                                    bagiOPH.bunchesEmpty,
                                    bagiOPH.oph.bunchesEmpty!);
                              },
                              style: Style.textBold20,
                              decoration: InputDecoration(hintText: "0"),
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
                                    "Janjang Tidak Dikirim",
                                    textAlign: TextAlign.center,
                                  )),
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
                              enabled: false,
                              controller: bagiOPH.bunchesTotal,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              onChanged: (value) {},
                              style: Style.textBold20,
                              decoration: InputDecoration(
                                  hintText: "0", border: InputBorder.none),
                            ),
                          ),
                          Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              enabled:
                                  !(bagiOPH.isNewSaved || bagiOPH.isOldSaved),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                BunchesFormatter()
                              ],
                              controller: bagiOPH.looseFruits,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: Style.textBold20,
                              decoration: InputDecoration(hintText: "0"),
                              onChanged: (value) {
                                bagiOPH.countBunches(
                                    context,
                                    bagiOPH.looseFruits,
                                    bagiOPH.oph.looseFruits!);
                              },
                            ),
                          ),
                          Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              enabled:
                                  !(bagiOPH.isNewSaved || bagiOPH.isOldSaved),
                              controller: bagiOPH.bunchesNotSent,
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
                                bagiOPH.countBunches(
                                    context,
                                    bagiOPH.bunchesNotSent,
                                    bagiOPH.oph.bunchesNotSent!);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(children: [
                    Text("Catatan"),
                    SizedBox(height: 8),
                    Text("${bagiOPH.newOPH.ophNotes}")
                  ]),
                  SizedBox(height: 20),
                  Image.file(
                    File("${bagiOPH.newOPH.ophPhoto}"),
                    height: 300,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Container();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: InkWell(
                      onTap: () {
                        bagiOPH.getCameraNewOPH(context);
                      },
                      child: Card(
                        color: Colors.green,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(14),
                          child: Text(
                            "AMBIL FOTO",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: InkWell(
                      onTap: () {
                        bagiOPH.showDialogQuestionNew();
                      },
                      child: Card(
                        color: Palette.primaryColorProd,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(14),
                          child: Text(
                            "SIMPAN OPH BARU",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      );
    });
  }
}
