import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/screen/supervisor/detail_supervise_harvest/detail_supervise_harvest_page.dart';
import 'package:epms/screen/supervisor/history_supervise_harvest/history_supervise_harvest_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistorySuperviseHarvestScreen extends StatefulWidget {
  const HistorySuperviseHarvestScreen({Key? key}) : super(key: key);

  @override
  State<HistorySuperviseHarvestScreen> createState() =>
      _HistorySuperviseHarvestScreenState();
}

class _HistorySuperviseHarvestScreenState
    extends State<HistorySuperviseHarvestScreen> {
  @override
  void initState() {
    context.read<HistorySuperviseHarvestNotifier>().onInit();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistorySuperviseHarvestNotifier>(
      builder: (context, notifier, child) {
        return MediaQuery(
          data: Style.mediaQueryText(context),
          child: Scaffold(
            appBar: AppBar(
              title: Text("Laporan Supervisi Panen"),
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
                          Text("Jumlah Supervisi OPH:"),
                          Text("${notifier.listOPHSupervise.length}")
                        ],
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Janjang:"),
                          Text("${notifier.totalBunches}")
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
                                      NavigatorService.navigateTo(
                                          context,
                                          DetailSuperviseHarvestPage(
                                            ophSupervise: notifier
                                                .listOPHSuperviseResult[index],
                                          ));
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
                                                  "${notifier.listOPHSuperviseResult[index].ophSupervisiId}",
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
                                                Text("Pemanen:"),
                                                Text(
                                                    "${notifier.listOPHSuperviseResult[index].supervisiPemanenEmployeeName}"),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                    "Blok: ${notifier.listOPHSuperviseResult[index].supervisiBlockCode}"),
                                                Text(
                                                    "Estate: ${notifier.listOPHSuperviseResult[index].supervisiEstateCode}"),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                    "Tanggal: ${notifier.listOPHSuperviseResult[index].createdDate} "),
                                                Text(
                                                    "Waktu: ${notifier.listOPHSuperviseResult[index].createdTime}"),
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
                                      NavigatorService.navigateTo(
                                          context,
                                          DetailSuperviseHarvestPage(
                                            ophSupervise: notifier
                                                .listOPHSupervise[index],
                                          ));
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
                                                "${notifier.listOPHSupervise[index].ophSupervisiId}",
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
                                              Text("Pemanen:"),
                                              Text(
                                                  "${notifier.listOPHSupervise[index].supervisiPemanenEmployeeName}"),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "Blok: ${notifier.listOPHSupervise[index].supervisiBlockCode}"),
                                              Text(
                                                  "Estate: ${notifier.listOPHSupervise[index].supervisiEstateCode}"),
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
