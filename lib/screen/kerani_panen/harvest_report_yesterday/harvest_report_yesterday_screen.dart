import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'harvest_report_yesterday_notifier.dart';

class HarvestReportYesterdayScreen extends StatefulWidget {
  const HarvestReportYesterdayScreen({Key? key}) : super(key: key);

  @override
  _HarvestReportYesterdayScreenState createState() =>
      _HarvestReportYesterdayScreenState();
}

class _HarvestReportYesterdayScreenState
    extends State<HarvestReportYesterdayScreen> {
  @override
  void initState() {
    context.read<HarvestReportYesterdayNotifier>().getListLaporanPanenKemarin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HarvestReportYesterdayNotifier>(
        builder: (context, laporanKemarin, child) {
      return MediaQuery(
        data: Style.mediaQueryText(context),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Laporan Panen Harian"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: Text("Tanggal:")),
                        Flexible(
                          child: Container(
                            width: 180,
                            child: DropdownButton(
                              isExpanded: true,
                              value: laporanKemarin.dateFilterValue,
                              items: laporanKemarin.dateFilter.map((value) {
                                return DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                laporanKemarin.onSetDateFilter(value!);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Jumlah pemanen:"),
                        Text("${laporanKemarin.totalHarvester}")
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Janjang:"),
                        Text("${ValueService.thousandSeparator(laporanKemarin.totalBunches)}")
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Brondolan (Kg):"),
                        Text("${ValueService.thousandSeparator(laporanKemarin.totalLooseFruits)}")
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Jumlah janjang masak:"),
                        Text("${ValueService.thousandSeparator(laporanKemarin.totalBunchesRipe)}")
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Jumlah janjang lewat masak:"),
                        Text("${ValueService.thousandSeparator(laporanKemarin.totalBunchesOverRipe)}")
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Jumlah janjang mengkal:"),
                        Text("${ValueService.thousandSeparator(laporanKemarin.totalBunchesHalfRipe)}")
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Jumlah janjang mentah:"),
                        Text("${ValueService.thousandSeparator(laporanKemarin.totalBunchesUnRipe)}")
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Jumlah janjang tidak normal:"),
                        Text("${ValueService.thousandSeparator(laporanKemarin.totalBunchesAbNormal)}")
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Jumlah janjang kosong:"),
                        Text("${ValueService.thousandSeparator(laporanKemarin.totalBunchesEmpty)}")
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Jumlah janjang tidak dikirim:"),
                        Text("${ValueService.thousandSeparator(laporanKemarin.totalBunchesNotSent)}")
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14),
              laporanKemarin.listLaporanPanen.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      height: 200,
                      child: Text("Tidak ada OPH yang dibuat hari ini",
                          style: Style.textBold14),
                    )
                  : Flexible(
                      child: ListView.builder(
                          itemCount: laporanKemarin.listLaporanPanen.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(top: 2, bottom: 2),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Palette.primaryColorProd)),
                              child: ExpandablePanel(
                                header: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "${laporanKemarin.listLaporanPanen[index].employeeCode ?? ""} ${laporanKemarin.listLaporanPanen[index].employeeName ?? ""}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                expanded: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Table(
                                            defaultVerticalAlignment:
                                                TableCellVerticalAlignment.middle,
                                            children: <TableRow>[
                                              TableRow(
                                                children: <Widget>[
                                                  Container(
                                                    width: 110,
                                                    child: Column(children: [
                                                      Text("Masak"),
                                                      SizedBox(height: 8),
                                                    ]),
                                                  ),
                                                  Container(
                                                    width: 110,
                                                    child: Column(children: [
                                                      Text("Lewat Masak"),
                                                      SizedBox(height: 8),
                                                    ]),
                                                  ),
                                                  Container(
                                                    width: 110,
                                                    child: Column(children: [
                                                      Text("Mengkal"),
                                                      SizedBox(height: 8),
                                                    ]),
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: <Widget>[
                                                  Container(
                                                    width: 110,
                                                    child: Column(children: [
                                                      Text(
                                                        "${laporanKemarin.listLaporanPanen[index].bunchesRipe}",
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ),
                                                      SizedBox(height: 16),
                                                    ]),
                                                  ),
                                                  Container(
                                                    width: 110,
                                                    child: Column(children: [
                                                      Text(
                                                        "${laporanKemarin.listLaporanPanen[index].bunchesOverripe}",
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ),
                                                      SizedBox(height: 16),
                                                    ]),
                                                  ),
                                                  Container(
                                                    width: 110,
                                                    child: Column(children: [
                                                      Text(
                                                        "${laporanKemarin.listLaporanPanen[index].bunchesHalfripe}",
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ),
                                                      SizedBox(height: 16),
                                                    ]),
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: <Widget>[
                                                  Container(
                                                    width: 110,
                                                    child: Column(children: [
                                                      Text("Mentah"),
                                                      SizedBox(height: 8),
                                                    ]),
                                                  ),
                                                  Container(
                                                    width: 110,
                                                    child: Column(children: [
                                                      Text("Tidak Normal"),
                                                      SizedBox(height: 8),
                                                    ]),
                                                  ),
                                                  Container(
                                                    width: 110,
                                                    child: Column(children: [
                                                      Text("Janjang Kosong"),
                                                      SizedBox(height: 8),
                                                    ]),
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: <Widget>[
                                                  Container(
                                                    width: 110,
                                                    child: Column(children: [
                                                      Text(
                                                          "${laporanKemarin.listLaporanPanen[index].bunchesUnripe}",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                      SizedBox(height: 16),
                                                    ]),
                                                  ),
                                                  Container(
                                                    width: 110,
                                                    child: Column(children: [
                                                      Text(
                                                          "${laporanKemarin.listLaporanPanen[index].bunchesAbnormal}",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                      SizedBox(height: 16),
                                                    ]),
                                                  ),
                                                  Container(
                                                    width: 110,
                                                    child: Column(children: [
                                                      Text(
                                                          "${laporanKemarin.listLaporanPanen[index].bunchesEmpty}",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                      SizedBox(height: 16),
                                                    ]),
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: <Widget>[
                                                  Container(
                                                    width: 110,
                                                    child: Column(children: [
                                                      Text("Total Janjang"),
                                                      SizedBox(height: 8),
                                                    ]),
                                                  ),
                                                  Container(
                                                    width: 110,
                                                    child: Column(children: [
                                                      Text("Brondolan (Kg)"),
                                                      SizedBox(height: 8),
                                                    ]),
                                                  ),
                                                  Container(
                                                    width: 110,
                                                    child: Column(children: [
                                                      Container(
                                                          width: 100,
                                                          child: Text(
                                                            "Janjang Tidak Dikirim",
                                                            textAlign:
                                                                TextAlign.center,
                                                          )),
                                                      SizedBox(height: 8),
                                                    ]),
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: <Widget>[
                                                  Container(
                                                    width: 110,
                                                    child: Column(children: [
                                                      Text(
                                                          "${laporanKemarin.listLaporanPanen[index].bunchesTotal}",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                      SizedBox(height: 16),
                                                    ]),
                                                  ),
                                                  Container(
                                                    width: 110,
                                                    child: Column(children: [
                                                      Text(
                                                          "${laporanKemarin.listLaporanPanen[index].looseFruits}",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                      SizedBox(height: 16),
                                                    ]),
                                                  ),
                                                  Container(
                                                    width: 110,
                                                    child: Column(children: [
                                                      Text(
                                                          "${laporanKemarin.listLaporanPanen[index].bunchesNotSent}",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                      SizedBox(height: 16),
                                                    ]),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ]),
                                  ),
                                ),
                                collapsed: Container(),
                              ),
                            );
                          }),
                    ),
            ]),
          ),
        ),
      );
    });
  }
}
