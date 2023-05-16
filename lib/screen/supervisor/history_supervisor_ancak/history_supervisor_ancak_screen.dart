import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/screen/supervisor/detail_supervise_ancak_harvest/detail_supervisor_ancak_harvest_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'history_supervisor_ancak_notifier.dart';

class HistorySuperviseAncakScreen extends StatefulWidget {
  const HistorySuperviseAncakScreen({Key? key}) : super(key: key);

  @override
  State<HistorySuperviseAncakScreen> createState() =>
      _HistorySuperviseAncakScreenState();
}

class _HistorySuperviseAncakScreenState
    extends State<HistorySuperviseAncakScreen> {
  @override
  void initState() {
    context.read<HistorySuperviseAncakNotifier>().onInit();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistorySuperviseAncakNotifier>(
      builder: (context, notifier, child) {
        return MediaQuery(
          data: Style.mediaQueryText(context),
          child: Scaffold(
            appBar: AppBar(
              title: Text("Laporan Supervisi Ancak Panen"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tanggal:"),
                          Text("${TimeManager.dateWithDash(DateTime.now())}")
                        ],
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Divisi:"),
                          Flexible(
                            child: Container(
                              width: 120,
                              child: DropdownButton(
                                isExpanded: true,
                                value: notifier.valueDivision,
                                items: notifier.listDivision.map((value) {
                                  return DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  notifier.onChangeDivision(value!);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Jumlah Supervisi Ancak Panen:"),
                          Text("${notifier.listOPHSupervise.length}")
                        ],
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Pokok Panen:"),
                          Text("${notifier.totalPokokPanen}")
                        ],
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Brondolan (Kg):"),
                          Text("${notifier.totalLooseFruits}")
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14),
                notifier.listOPHSupervise.isEmpty
                    ? Container(
                    alignment: Alignment.center,
                    height: 200,
                    child: Text(
                      "Tidak ada Supervisi Panen yang dibuat",
                      style: Style.textBold16,
                    ))
                    : notifier.listOPHSuperviseResult.isNotEmpty
                    ? Flexible(
                  child: ListView.builder(
                      itemCount: notifier.listOPHSuperviseResult.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            NavigatorService.navigateTo(context, DetailSuperviseAncakHarvestPage(ophSuperviseAncak: notifier.listOPHSuperviseResult[index]));
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${notifier.listOPHSuperviseResult[index].supervisiAncakId}",
                                        style: Style.textBold16,
                                      ),
                                      Text(
                                          "${notifier.listOPHSuperviseResult[index].bunchesTotal} Janjang"),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Kemandoran:"),
                                      Text(
                                          "${notifier.listOPHSuperviseResult[index].supervisiAncakMandorEmployeeCode} ${notifier.listOPHSupervise[index].supervisiAncakMandorEmployeeName}"),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Blok: ${notifier.listOPHSupervise[index].supervisiAncakBlockCode}"),
                                      Text(
                                          "Estate: ${notifier.listOPHSupervise[index].supervisiAncakEstateCode}"),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Tanggal: ${notifier.listOPHSupervise[index].createdDate} "),
                                      Text(
                                          "Waktu: ${notifier.listOPHSupervise[index].createdTime}"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
                    : Flexible(
                  child: ListView.builder(
                      itemCount: notifier.listOPHSupervise.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            NavigatorService.navigateTo(context, DetailSuperviseAncakHarvestPage(ophSuperviseAncak: notifier.listOPHSupervise[index]));
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${notifier.listOPHSupervise[index].supervisiAncakId}",
                                      style: Style.textBold16,
                                    ),
                                    Text(
                                        "${notifier.listOPHSupervise[index].bunchesTotal} Janjang"),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Kemandoran:"),
                                    Text(
                                        "${notifier.listOPHSupervise[index].supervisiAncakMandorEmployeeCode} ${notifier.listOPHSupervise[index].supervisiAncakMandorEmployeeName}"),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "Blok: ${notifier.listOPHSupervise[index].supervisiAncakBlockCode}"),
                                    Text(
                                        "Estate: ${notifier.listOPHSupervise[index].supervisiAncakEstateCode}"),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Tanggal: ${notifier.listOPHSupervise[index].createdDate} "),
                                      Text(
                                          "Waktu: ${notifier.listOPHSupervise[index].createdTime}"),
                                    ]),
                              ]),
                            ),
                          ),
                        );
                      }),
                )
              ]),
            ),
          ),
        );
      },
    );
  }
}
