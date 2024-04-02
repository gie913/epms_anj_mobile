import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/model/laporan_restan.dart';
import 'package:flutter/material.dart';

class DetailRestanScreen extends StatefulWidget {
  final LaporanRestan laporanRestan;

  const DetailRestanScreen({Key? key, required this.laporanRestan})
      : super(key: key);

  @override
  _DetailRestanScreenState createState() => _DetailRestanScreenState();
}

class _DetailRestanScreenState extends State<DetailRestanScreen> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: Style.mediaQueryText(context),
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Detail Restan'),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Text("Detail"),
                ),
                Tab(
                  icon: Text("Grading"),
                ),
              ],
            ),
          ),
          body: TabBarView(children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("ID OPH:"),
                        Text(
                          "${widget.laporanRestan.ophId}",
                          style: Style.textBold16,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tanggal:"),
                        Text("${widget.laporanRestan.createdDate ?? ""}")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Jenis Pekerja:"),
                        Text(
                            "${ValueService.typeOfFormToText(widget.laporanRestan.ophHarvestingType)}")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Apakah Panen Mekanis?"),
                        Text(
                            "${ValueService.harvestingType(widget.laporanRestan.ophHarvestingMethod)}")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text("Kemandoran:"),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            "${widget.laporanRestan.mandorEmployeeCode} ${widget.laporanRestan.mandorEmployeeName}",
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
                        Expanded(
                          flex: 3,
                          child: Text("Pekerja:"),
                        ),
                        Expanded(
                            flex: 4,
                            child: Text(
                              "${widget.laporanRestan.employeeCode} ${widget.laporanRestan.employeeName}",
                              textAlign: TextAlign.end,
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text("Customer:"),
                        ),
                        Expanded(
                            flex: 4,
                            child: Text(
                              "${widget.laporanRestan.ophCustomerCode ?? ""}",
                              textAlign: TextAlign.end,
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text("Estate:"),
                        ),
                        Expanded(
                            flex: 4,
                            child: Text(
                              "${widget.laporanRestan.ophEstateCode ?? ""}",
                              textAlign: TextAlign.end,
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text("Divisi:"),
                        ),
                        Expanded(
                            flex: 4,
                            child: Text(
                              "${widget.laporanRestan.ophDivisionCode ?? ""}",
                              textAlign: TextAlign.end,
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text("Blok:"),
                        ),
                        Expanded(
                            flex: 4,
                            child: Text(
                              "${widget.laporanRestan.ophBlockCode ?? ""}",
                              textAlign: TextAlign.end,
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text("Estimasi berat OPH (Kg):"),
                        ),
                        Expanded(
                            flex: 3,
                            child: Text(
                              "${widget.laporanRestan.ophEstimateTonnage ?? ""}",
                              textAlign: TextAlign.end,
                            ))
                      ],
                    ),
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
                              Text("${widget.laporanRestan.ophTphCode ?? ""}")
                            ],
                          ),
                        ),
                        SizedBox(width: 80),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Kartu OPH"),
                              Text("${widget.laporanRestan.ophCardId ?? ""}")
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   child: InkWell(
                  //     onTap: () {
                  //       Navigator.pop(context);
                  //     },
                  //     child: Card(
                  //       color: Palette.redColorDark,
                  //       elevation: 2,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10.0),
                  //       ),
                  //       child: Container(
                  //         alignment: Alignment.center,
                  //         padding: EdgeInsets.all(14),
                  //         child: Text(
                  //           "KEMBALI",
                  //           style: TextStyle(
                  //               fontSize: 18,
                  //               fontWeight: FontWeight.bold,
                  //               color: Colors.white),
                  //           textAlign: TextAlign.center,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ]),
              ),
            ),
            Center(
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
                                "${widget.laporanRestan.bunchesRipe}",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 20),
                            ]),
                          ),
                          Container(
                            width: 110,
                            child: Column(children: [
                              Text(
                                "${widget.laporanRestan.bunchesOverripe}",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 20),
                            ]),
                          ),
                          Container(
                            width: 110,
                            child: Column(children: [
                              Text(
                                "${widget.laporanRestan.bunchesHalfripe}",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 20),
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
                              Text("${widget.laporanRestan.bunchesUnripe}",
                                  style: TextStyle(fontSize: 18)),
                              SizedBox(height: 20),
                            ]),
                          ),
                          Container(
                            width: 110,
                            child: Column(children: [
                              Text("${widget.laporanRestan.bunchesAbnormal}",
                                  style: TextStyle(fontSize: 18)),
                              SizedBox(height: 20),
                            ]),
                          ),
                          Container(
                            width: 110,
                            child: Column(children: [
                              Text("${widget.laporanRestan.bunchesEmpty}",
                                  style: TextStyle(fontSize: 18)),
                              SizedBox(height: 20),
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
                                    textAlign: TextAlign.center,
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
                              Text("${widget.laporanRestan.bunchesTotal}",
                                  style: TextStyle(fontSize: 18)),
                              SizedBox(height: 20),
                            ]),
                          ),
                          Container(
                            width: 110,
                            child: Column(children: [
                              Text("${widget.laporanRestan.looseFruits}",
                                  style: TextStyle(fontSize: 18)),
                              SizedBox(height: 20),
                            ]),
                          ),
                          Container(
                            width: 110,
                            child: Column(children: [
                              Text("${widget.laporanRestan.bunchesNotSent}",
                                  style: TextStyle(fontSize: 18)),
                              SizedBox(height: 20),
                            ]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(children: [
                    Text(
                        "Catatan (${50 - (widget.laporanRestan.ophNotes?.length ?? 0)})"),
                    SizedBox(height: 8),
                    Text("${widget.laporanRestan.ophNotes ?? ""}")
                  ]),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
