import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/screen/kerani_kirim/history_spb/history_spb_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistorySPBScreen extends StatefulWidget {
  final String method;

  const HistorySPBScreen({Key? key, required this.method}) : super(key: key);

  @override
  _HistorySPBScreenState createState() => _HistorySPBScreenState();
}

class _HistorySPBScreenState extends State<HistorySPBScreen> {
  @override
  void initState() {
    context.read<HistorySPBNotifier>().getDataSPBHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistorySPBNotifier>(builder: (context, historySPB, child) {
      return MediaQuery(
        data: Style.mediaQueryText(context),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Riwayat SPB"),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Jumlah SPB:"),
                      Text("${historySPB.listSPB.length}")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Janjang"),
                      Text("${ValueService.thousandSeparator(historySPB.totalBunches)}")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Brondolan:"),
                      Text("${ValueService.thousandSeparator(historySPB.totalLooseFruits)}")
                    ],
                  ),
                ),
                SizedBox(height: 30),
                historySPB.listSPB.isEmpty
                    ? Text("Tidak ada SPB yang dibuat", style: Style.textBold14)
                    : Flexible(
                        child: ListView.builder(
                            itemCount: historySPB.listSPB.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  historySPB.onClickSPB(historySPB.listSPB[index], widget.method);
                                },
                                child: Card(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${historySPB.listSPB[index].spbId}",
                                              style: Style.textBold16),
                                          SizedBox(height: 10),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Total Janjang:"),
                                                Text(
                                                    "${historySPB.listSPB[index].spbTotalBunches}")
                                              ]),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Total Brondolan:"),
                                                Text(
                                                    "${historySPB.listSPB[index].spbTotalLooseFruit}")
                                              ]),
                                          historySPB.listSPB[index].spbType != 1 ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Vendor:"),
                                                Text(
                                                    "${historySPB.listSPB[index].spbDriverEmployeeName ?? ""}")
                                              ]) : Container(),
                                          historySPB.listSPB[index].spbType == 1 ? Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Supir:"),
                                                Text(
                                                    "${historySPB.listSPB[index].spbDriverEmployeeName ?? ""}")
                                              ]) : Container(),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                    "Truk: ${historySPB.listSPB[index].spbLicenseNumber}"),
                                                Text(
                                                    "Kartu: ${historySPB.listSPB[index].spbCardId}")
                                              ]),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Tujuan:"),
                                                Text(
                                                    "${historySPB.listSPB[index].spbDeliverToCode} ${historySPB.listSPB[index].spbDeliverToName}")
                                              ]),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                    "Tanggal: ${historySPB.listSPB[index].createdDate}"),
                                                Text(
                                                    "Waktu: ${historySPB.listSPB[index].createdTime}")
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
        ),
      );
    });
  }
}
