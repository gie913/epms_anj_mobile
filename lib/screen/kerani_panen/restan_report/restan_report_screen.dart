import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/screen/kerani_panen/restan_report/restan_report_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestanReportScreen extends StatefulWidget {
  final String method;

  const RestanReportScreen({Key? key, required this.method}) : super(key: key);

  @override
  _RestanReportScreenState createState() => _RestanReportScreenState();
}

class _RestanReportScreenState extends State<RestanReportScreen> {
  @override
  void initState() {
    context.read<RestanReportNotifier>().getListLaporanRestan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RestanReportNotifier>(
      builder: (context, restanReport, child) {
        return MediaQuery(
          data: Style.mediaQueryText(context),
          child: Scaffold(
            appBar: AppBar(
              title: Text("Laporan Restan Hari Ini"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tanggal:"),
                          Text("${TimeManager.todayWithSlash(DateTime.now())}")
                        ],
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Divisi:"),
                          Flexible(
                            child: Container(
                              width: 160,
                              child: DropdownButton(
                                isExpanded: true,
                                value: restanReport.divisionValue,
                                items: restanReport.listDivision.map((value) {
                                  return DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  restanReport.setDivisionValue(value!);

                                  // restanReport.onSetDivisionValue(value!);
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
                          Text("Blok:"),
                          Flexible(
                            child: Container(
                              width: 160,
                              child: DropdownButton(
                                isExpanded: true,
                                value: restanReport.blockValue,
                                items: restanReport.listBlock.map((value) {
                                  return DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  restanReport.setBlockValue(value!);

                                  // restanReport.onSetBlockValue(value!);
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
                          Text("${restanReport.countOPHRestan}")
                        ],
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Janjang:"),
                          Text("${restanReport.totalBunches}")
                        ],
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Brondolan (Kg):"),
                          Text("${restanReport.totalLooseFruits}")
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
                restanReport.listRestanResult.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        height: 200,
                        child:
                            Text("Tidak ada Restan", style: Style.textBold16))
                    : Flexible(
                        child: ListView.builder(
                            itemCount: restanReport.listRestanResult.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  restanReport.onClickRestan(widget.method,
                                      restanReport.listRestanResult[index]);
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
                                              "${restanReport.listRestanResult[index].ophDivisionCode}",
                                              style: Style.textBold16),
                                          Text(
                                              "${restanReport.listRestanResult[index].ophId}",
                                              style: Style.textBold16),
                                          Text(
                                              "${restanReport.listRestanResult[index].bunchesTotal} Janjang"),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "Blok: ${restanReport.listRestanResult[index].ophBlockCode}"),
                                          Text(
                                              "TPH: ${restanReport.listRestanResult[index].ophTphCode}"),
                                          Text(
                                              "Kartu: ${restanReport.listRestanResult[index].ophCardId}"),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "${restanReport.listRestanResult[index].createdDate} ${restanReport.listRestanResult[index].createdTime}"),
                                            Text(
                                              "${TimeManager.countDaysRestan(restanReport.listRestanResult[index].createdDate!)} Hari",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ]),
                                    ]),
                                  ),
                                ),
                              );
                            }),
                      ),

                // restanReport.listRestan.isEmpty
                //     ? Container(
                //         alignment: Alignment.center,
                //         height: 200,
                //         child:
                //             Text("Tidak ada Restan", style: Style.textBold16))
                //     : restanReport.listRestanResult.isNotEmpty
                //         ? Flexible(
                //             child: ListView.builder(
                //                 itemCount: restanReport.listRestanResult.length,
                //                 itemBuilder: (BuildContext context, int index) {
                //                   return InkWell(
                //                     onTap: () {
                //                       restanReport.onClickRestan(widget.method,
                //                           restanReport.listRestanResult[index]);
                //                     },
                //                     child: Card(
                //                       child: Padding(
                //                         padding: const EdgeInsets.all(8.0),
                //                         child: Column(children: [
                //                           Row(
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.spaceBetween,
                //                             children: [
                //                               Text(
                //                                   "${restanReport.listRestanResult[index].ophDivisionCode}",
                //                                   style: Style.textBold16),
                //                               Text(
                //                                   "${restanReport.listRestanResult[index].ophId}",
                //                                   style: Style.textBold16),
                //                               Text(
                //                                   "${restanReport.listRestanResult[index].bunchesTotal} Janjang"),
                //                             ],
                //                           ),
                //                           SizedBox(height: 12),
                //                           Row(
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.spaceBetween,
                //                             children: [
                //                               Text(
                //                                   "Blok: ${restanReport.listRestanResult[index].ophBlockCode}"),
                //                               Text(
                //                                   "TPH: ${restanReport.listRestanResult[index].ophTphCode}"),
                //                               Text(
                //                                   "Kartu: ${restanReport.listRestanResult[index].ophCardId}"),
                //                             ],
                //                           ),
                //                           SizedBox(height: 12),
                //                           Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment
                //                                       .spaceBetween,
                //                               children: [
                //                                 Text(
                //                                     "${restanReport.listRestanResult[index].createdDate} ${restanReport.listRestanResult[index].createdTime}"),
                //                                 Text(
                //                                   "${TimeManager.countDaysRestan(restanReport.listRestanResult[index].createdDate!)} Hari",
                //                                   style: TextStyle(
                //                                       color: Colors.red,
                //                                       fontWeight:
                //                                           FontWeight.bold),
                //                                 )
                //                               ]),
                //                         ]),
                //                       ),
                //                     ),
                //                   );
                //                 }),
                //           )
                //         : Flexible(
                //             child: ListView.builder(
                //                 itemCount: restanReport.listRestan.length,
                //                 itemBuilder: (BuildContext context, int index) {
                //                   return InkWell(
                //                     onTap: () {
                //                       restanReport.onClickRestan(widget.method,
                //                           restanReport.listRestan[index]);
                //                     },
                //                     child: Card(
                //                       child: Padding(
                //                         padding: const EdgeInsets.all(8.0),
                //                         child: Column(children: [
                //                           Row(
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.spaceBetween,
                //                             children: [
                //                               Text(
                //                                   "${restanReport.listRestan[index].ophDivisionCode}",
                //                                   style: Style.textBold16),
                //                               Text(
                //                                   "${restanReport.listRestan[index].ophId}",
                //                                   style: Style.textBold16),
                //                               Text(
                //                                   "${restanReport.listRestan[index].bunchesTotal} Janjang"),
                //                             ],
                //                           ),
                //                           SizedBox(height: 12),
                //                           Row(
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.spaceBetween,
                //                             children: [
                //                               Text(
                //                                   "Blok: ${restanReport.listRestan[index].ophBlockCode}"),
                //                               Text(
                //                                   "TPH: ${restanReport.listRestan[index].ophTphCode}"),
                //                               Text(
                //                                   "Kartu: ${restanReport.listRestan[index].ophCardId}"),
                //                             ],
                //                           ),
                //                           SizedBox(height: 12),
                //                           Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment
                //                                       .spaceBetween,
                //                               children: [
                //                                 Text(
                //                                     "${restanReport.listRestan[index].createdDate} ${restanReport.listRestan[index].createdTime}"),
                //                                 Text(
                //                                   "${TimeManager.countDaysRestan(restanReport.listRestan[index].createdDate!)} Hari",
                //                                   style: TextStyle(
                //                                       color: Colors.red,
                //                                       fontWeight:
                //                                           FontWeight.bold),
                //                                 )
                //                               ]),
                //                         ]),
                //                       ),
                //                     ),
                //                   );
                //                 }),
                //           )
              ]),
            ),
          ),
        );
      },
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
