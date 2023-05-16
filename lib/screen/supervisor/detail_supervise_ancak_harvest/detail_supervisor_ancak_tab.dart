import 'dart:io';

import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/model/m_ancak_employee.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/screen/search/search_ancak_employee_screen.dart';
import 'package:epms/screen/search/search_employee_screen.dart';
import 'package:epms/screen/supervisor/detail_supervise_ancak_harvest/detail_supervisor_ancak_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailSupervisorAncakTab extends StatefulWidget {
  const DetailSupervisorAncakTab({Key? key}) : super(key: key);

  @override
  State<DetailSupervisorAncakTab> createState() => _DetailSupervisorAncakTabState();
}

class _DetailSupervisorAncakTabState extends State<DetailSupervisorAncakTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailSupervisorAncakNotifier>(
        builder: (context, notifier, child) {
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
                        Text("${notifier.ophSuperviseAncak?.supervisiAncakId}", style: Style.textBold16)
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Tanggal:"), Text("${notifier.ophSuperviseAncak?.createdDate}")],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Name:"),
                      Text("${notifier.ophSuperviseAncak?.supervisiAncakEmployeeName}")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("GPS Geolocation:"),
                      Text("${notifier.ophSuperviseAncak?.supervisiAncakLat}, ${notifier.ophSuperviseAncak?.supervisiAncakLon}")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("GPS Geolocation End:"),
                      Text("${notifier.ophSuperviseAncak?.supervisiAncakLatEnd}, ${notifier.ophSuperviseAncak?.supervisiAncakLongEnd}")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Kemandoran:"),
                            notifier.onEdit ? InkWell(
                              onTap: () async {
                                MEmployeeSchema? mEmployee = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SearchEmployeeScreen()));
                                notifier.onSetKemandoran(mEmployee!);
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.search),
                                ),
                              ),
                            ) : Container()
                          ],
                        ),
                        notifier.kemandoran != null
                            ? Table(border: TableBorder.all(), children: [
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                              Text("Kode", textAlign: TextAlign.center),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                              Text('Nama', textAlign: TextAlign.center),
                            ),
                          ]),
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "${notifier.kemandoran?.employeeCode}",
                                  textAlign: TextAlign.center),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "${notifier.kemandoran?.employeeName}",
                                  textAlign: TextAlign.center),
                            ),
                          ]),
                        ])
                            : Container()
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Pemanen:"),
                              notifier.onEdit ? InkWell(
                                onTap: () async {
                                  MEmployeeSchema? mEmployee = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SearchEmployeeScreen()));
                                  notifier.onSetPemanen(mEmployee!);
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.search),
                                  ),
                                ),
                              ) : Container()
                            ]),
                        notifier.pemanen != null
                            ? Table(border: TableBorder.all(), children: [
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                              Text("Kode", textAlign: TextAlign.center),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                              Text('Nama', textAlign: TextAlign.center),
                            ),
                          ]),
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${notifier.pemanen?.employeeCode}",
                                  textAlign: TextAlign.center),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${notifier.pemanen?.employeeName}",
                                  textAlign: TextAlign.center),
                            ),
                          ]),
                        ])
                            : Container()
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Assign To:"),
                              notifier.onEdit ? InkWell(
                                onTap: () async {
                                  MAncakEmployee? mAncakEmployee = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SearchAncakEmployeeScreen()));
                                  notifier.onSetAncakEmployee(mAncakEmployee!);
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.search),
                                  ),
                                ),
                              ) : Container()
                            ]),
                        notifier.ancakEmployee != null
                            ? Table(border: TableBorder.all(), children: [
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                              Text("User ID", textAlign: TextAlign.center),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                              Text('Nama', textAlign: TextAlign.center),
                            ),
                          ]),
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "${notifier.ancakEmployee?.userId}",
                                  textAlign: TextAlign.center),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "${notifier.ancakEmployee?.userName}",
                                  textAlign: TextAlign.center),
                            ),
                          ]),
                        ])
                            : Container()
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Estate Code:"),
                      Text("${notifier.ophSuperviseAncak?.supervisiAncakEstateCode}")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Blok:"),
                      Text("${notifier.ophSuperviseAncak?.supervisiAncakBlockCode}")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Losses buah tinggal (janjang/pokok):"),
                      Text("${notifier.janjangTinggal.text}")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Losses brondolan (butir/pokok):"),
                      Text("${notifier.ophSuperviseAncak?.bunchesBrondolanTinggal}")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Brondolan tinggal persentase:"),
                      Text("${notifier.ophSuperviseAncak?.bunchesBrondolanTinggalPercentage} %")
                    ],
                  ),
                ),
                SizedBox(height: 10),
                notifier.ophSuperviseAncak?.supervisiAncakPhoto != null
                    ? Image.file(
                  File("${notifier.ophSuperviseAncak?.supervisiAncakPhoto}"),
                  height: 400,
                )
                    : Container(),
                notifier.onEdit ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      notifier.getCamera(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "FOTO HASIL PANEN",
                            style: Style.whiteBold14,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ) : Container(),
                notifier.onEdit ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      notifier.showDialogQuestion(context);
                    },
                    child: Card(
                      color: Palette.primaryColorProd,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(14),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "SIMPAN",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ) : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      notifier.onChangeEdit();
                    },
                    child: Card(
                      color: Palette.primaryColorProd,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(14),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "UBAH DATA",
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
          );
        });
  }
}
