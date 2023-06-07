import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'history_oph_notifier.dart';

class HistoryOPHScreen extends StatefulWidget {
  final String method;

  const HistoryOPHScreen({Key? key, required this.method}) : super(key: key);

  @override
  _HistoryOPHScreenState createState() => _HistoryOPHScreenState();
}

class _HistoryOPHScreenState extends State<HistoryOPHScreen> {
  @override
  void initState() {
    context.read<HistoryOPHNotifier>().getListOPH();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryOPHNotifier>(
      builder: (context, historyOPH, child) {
        return MediaQuery(
          data: Style.mediaQueryText(context),
          child: Scaffold(
            appBar: AppBar(
              title: Text("Riwayat OPH"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Blok:"),
                            Flexible(
                              child: Container(
                                width: 120,
                                child: DropdownButton(
                                  isExpanded: true,
                                  value: historyOPH.filterBlockValue,
                                  items: historyOPH.blockList.map((value) {
                                    return DropdownMenuItem(
                                      child: Text(value),
                                      value: value,
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    historyOPH.onChangeFilterBlock(value!);
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
                            Text("Jumlah OPH:"),
                            Text("${historyOPH.countOPH}")
                          ],
                        ),
                        SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Janjang:"),
                            Text(
                                "${ValueService.thousandSeparator(historyOPH.totalBunches)}")
                          ],
                        ),
                        SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Brondolan (Kg):"),
                            Text(
                                "${ValueService.thousandSeparator(historyOPH.totalLooseFruits)}")
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  historyOPH.listOPH.isEmpty
                      ? Container(
                          alignment: Alignment.center,
                          height: 200,
                          child: Text(
                            "Tidak ada OPH yang dibuat",
                            style: Style.textBold16,
                          ))
                      : historyOPH.listOPHResult.isNotEmpty
                          ? Flexible(
                              child: ListView.builder(
                                  itemCount: historyOPH.listOPHResult.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        historyOPH.onSelectedOPH(
                                            historyOPH.listOPHResult[index],
                                            widget.method);
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${historyOPH.listOPHResult[index].ophId}",
                                                    style: Style.textBold16,
                                                  ),
                                                  Text(
                                                      "${historyOPH.listOPHResult[index].bunchesTotal} Janjang"),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Pekerja:"),
                                                  Expanded(
                                                    child: Text(
                                                      "${historyOPH.listOPHResult[index].employeeCode ?? ""} ${historyOPH.listOPHResult[index].employeeName ?? ""}",
                                                      textAlign: TextAlign.end,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "Blok: ${historyOPH.listOPHResult[index].ophBlockCode ?? ""}"),
                                                  Text(
                                                      "TPH: ${historyOPH.listOPHResult[index].ophTphCode ?? ""}"),
                                                  Text(
                                                      "Kartu: ${historyOPH.listOPHResult[index].ophCardId ?? ""}"),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "Tanggal: ${historyOPH.listOPH[index].createdDate ?? ""} "),
                                                  Text(
                                                      "Waktu: ${historyOPH.listOPH[index].createdTime ?? ""}"),
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
                                  itemCount: historyOPH.listOPH.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        historyOPH.onSelectedOPH(
                                            historyOPH.listOPH[index],
                                            widget.method);
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${historyOPH.listOPH[index].ophId}",
                                                    style: Style.textBold16,
                                                  ),
                                                  Text(
                                                      "${historyOPH.listOPH[index].bunchesTotal} Janjang"),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Pekerja:"),
                                                  Expanded(
                                                    child: Text(
                                                      "${historyOPH.listOPH[index].employeeCode ?? ""} ${historyOPH.listOPH[index].employeeName ?? ""}",
                                                      textAlign: TextAlign.end,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "Blok: ${historyOPH.listOPH[index].ophBlockCode ?? ""}"),
                                                  Text(
                                                      "TPH: ${historyOPH.listOPH[index].ophTphCode ?? ""}"),
                                                  Text(
                                                      "Kartu: ${historyOPH.listOPH[index].ophCardId ?? ""}"),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "Tanggal: ${historyOPH.listOPH[index].createdDate ?? ""} "),
                                                  Text(
                                                      "Waktu: ${historyOPH.listOPH[index].createdTime ?? ""}"),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
