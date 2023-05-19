import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/screen/supervisor_spb/supervisor_spb_detail/supervisor_spb_detail_page.dart';
import 'package:epms/screen/supervisor_spb/supervisor_spb_history/supervisor_spb_history_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorSPBHistoryScreen extends StatefulWidget {
  const SupervisorSPBHistoryScreen({Key? key}) : super(key: key);

  @override
  State<SupervisorSPBHistoryScreen> createState() =>
      _SupervisorSPBHistoryScreenState();
}

class _SupervisorSPBHistoryScreenState
    extends State<SupervisorSPBHistoryScreen> {
  @override
  void initState() {
    context.read<SupervisorSPBHistoryNotifier>().onInit();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SupervisorSPBHistoryNotifier>(
      builder: (context, notifier, child) {
        return MediaQuery(
          data: Style.mediaQueryText(context),
          child: Scaffold(
            appBar: AppBar(
              title: Text("Laporan Supervisi SPB"),
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
                          Text("Sumber SPB:"),
                          Flexible(
                            child: Container(
                              width: 120,
                              child: DropdownButton(
                                isExpanded: true,
                                value: notifier.sourceSPBValue,
                                items: notifier.sourceSPB.map((value) {
                                  return DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  notifier.onChangeFilterSupervisiSPB(value!);
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
                          Text("Jumlah Supervisi SPB:"),
                          Text(
                              "${notifier.listSPBSuperviseResult.length == 0 ? notifier.listSPBSupervise.length : notifier.listSPBSuperviseResult.length}")
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
                if (notifier.listSPBSupervise.isEmpty)
                  Container(
                      alignment: Alignment.center,
                      height: 200,
                      child: Text(
                        "Tidak ada Supervisi SPB yang dibuat",
                        style: Style.textBold16,
                      ))
                else
                  notifier.listSPBSuperviseResult.isNotEmpty
                      ? Flexible(
                          child: ListView.builder(
                              itemCount: notifier.listSPBSuperviseResult.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    NavigatorService.navigateTo(
                                        context,
                                        SupervisorSPBDetailPage(
                                            spbSupervise:
                                                notifier.listSPBSuperviseResult[
                                                    index]));
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
                                              "${notifier.listSPBSuperviseResult[index].spbId}",
                                              style: Style.textBold16,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Total Janjang:"),
                                            Text(
                                                "${notifier.listSPBSuperviseResult[index].bunchesTotal} Janjang"),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Total Janjang Normal:"),
                                            Text(
                                                "${notifier.listSPBSuperviseResult[index].bunchesTotalNormal} Janjang"),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Total Brondolan:"),
                                            Text(
                                                "${notifier.listSPBSuperviseResult[index].looseFruits} Kg"),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            notifier.listSPBSuperviseResult[index]
                                                .supervisiSpbMethod ==
                                                3
                                                ? Text("Vendor:")
                                                : Text("Supir:"),
                                            notifier.listSPBSuperviseResult[index]
                                                .supervisiSpbDriverEmployeeCode ==
                                                notifier
                                                    .listSPBSuperviseResult[index]
                                                    .supervisiSpbDriverEmployeeName
                                                ? Text(
                                                "${notifier.listSPBSuperviseResult[index].supervisiSpbDriverEmployeeCode}")
                                                : Text(
                                                "${notifier.listSPBSuperviseResult[index].supervisiSpbDriverEmployeeCode} ${notifier.listSPBSupervise[index].supervisiSpbDriverEmployeeName}"),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "Truk: ${notifier.listSPBSuperviseResult[index].supervisiSpbLicenseNumber} "),
                                              Text(
                                                  "SPB Sumber: ${ValueService.spbSourceDataText(notifier.listSPBSuperviseResult[index].supervisiSpbType!)}"),
                                            ]),
                                        SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Jenis Pengangkutan:"),
                                              Text(
                                                  "${ValueService.typeOfFormToText(notifier.listSPBSuperviseResult[index].supervisiSpbMethod!)}"),
                                            ]),
                                        SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "Tanggal: ${notifier.listSPBSuperviseResult[index].createdDate} "),
                                              Text(
                                                  "Waktu: ${notifier.listSPBSuperviseResult[index].createdTime}"),
                                            ]),
                                      ]),
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Flexible(
                          child: ListView.builder(
                              itemCount: notifier.listSPBSupervise.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    NavigatorService.navigateTo(
                                        context,
                                        SupervisorSPBDetailPage(
                                            spbSupervise: notifier
                                                .listSPBSupervise[index]));
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
                                              "${notifier.listSPBSupervise[index].spbId}",
                                              style: Style.textBold16,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Total Janjang:"),
                                            Text(
                                                "${notifier.listSPBSupervise[index].bunchesTotal} Janjang"),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Total Janjang Normal:"),
                                            Text(
                                                "${notifier.listSPBSupervise[index].bunchesTotalNormal} Janjang"),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Total Brondolan:"),
                                            Text(
                                                "${notifier.listSPBSupervise[index].looseFruits} Kg"),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            notifier.listSPBSupervise[index]
                                                        .supervisiSpbMethod ==
                                                    3
                                                ? Text("Vendor:")
                                                : Text("Supir:"),
                                            notifier.listSPBSupervise[index]
                                                        .supervisiSpbDriverEmployeeCode ==
                                                    notifier
                                                        .listSPBSupervise[index]
                                                        .supervisiSpbDriverEmployeeName
                                                ? Text(
                                                    "${notifier.listSPBSupervise[index].supervisiSpbDriverEmployeeCode}")
                                                : Text(
                                                    "${notifier.listSPBSupervise[index].supervisiSpbDriverEmployeeCode} ${notifier.listSPBSupervise[index].supervisiSpbDriverEmployeeName}"),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "Truk: ${notifier.listSPBSupervise[index].supervisiSpbLicenseNumber} "),
                                              Text(
                                                  "SPB Sumber: ${ValueService.spbSourceDataText(notifier.listSPBSupervise[index].supervisiSpbType!)}"),
                                            ]),
                                        SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Jenis Pengangkutan:"),
                                              Text(
                                                  "${ValueService.typeOfFormToText(notifier.listSPBSupervise[index].supervisiSpbMethod!)}"),
                                            ]),
                                        SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "Tanggal: ${notifier.listSPBSupervise[index].createdDate} "),
                                              Text(
                                                  "Waktu: ${notifier.listSPBSupervise[index].createdTime}"),
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
