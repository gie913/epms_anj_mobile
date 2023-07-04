import 'dart:io';

import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/model/spb.dart';
import 'package:epms/screen/kerani_kirim/detail_spb/detail_spb_notifier.dart';
import 'package:epms/screen/qr_reader/qr_reader_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailSPBScreen extends StatefulWidget {
  final String method;
  final SPB spb;

  const DetailSPBScreen({Key? key, required this.spb, required this.method})
      : super(key: key);

  @override
  State<DetailSPBScreen> createState() => _DetailSPBScreenState();
}

class _DetailSPBScreenState extends State<DetailSPBScreen> {
  @override
  void initState() {
    context
        .read<DetailSPBNotifier>()
        .onInit(context, widget.spb, widget.method);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailSPBNotifier>(builder: (context, detailSPB, child) {
      return DefaultTabController(
        initialIndex: 0,
        length: detailSPB.isSPBExist ? 3 : 1,
        child: MediaQuery(
          data: Style.mediaQueryText(context),
          child: WillPopScope(
            onWillPop: () async {
              if (detailSPB.onChangeCard) {
                return NavigatorService().onWillPopForm(context);
              } else {
                return true;
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text('Detail SPB'),
                bottom: detailSPB.isSPBExist
                    ? TabBar(
                        tabs: <Widget>[
                          Tab(
                            icon: Text("Detail"),
                          ),
                          Tab(
                            icon:
                                Text("OPH (${detailSPB.listSPBDetail.length})"),
                          ),
                          Tab(
                            icon: Text(
                                "Loader (${detailSPB.listSPBLoader.length})"),
                          ),
                        ],
                      )
                    : TabBar(
                        tabs: <Widget>[
                          Tab(
                            icon: Text("Detail"),
                          ),
                        ],
                      ),
              ),
              body: detailSPB.isSPBExist
                  ? TabBarView(children: <Widget>[
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("ID SPB:"),
                                  Expanded(
                                    child: Text(
                                      "${detailSPB.spb?.spbId ?? ""}",
                                      style: Style.textBold16,
                                      textAlign: TextAlign.end,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Tanggal:"),
                                  Expanded(
                                      child: Text(
                                    "${detailSPB.spb?.createdDate ?? ""}",
                                    textAlign: TextAlign.end,
                                  ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("GPS Geolocation:"),
                                  Expanded(
                                    child: Text(
                                      "${detailSPB.spb?.spbLat ?? ""}, ${detailSPB.spb?.spbLong ?? ""}",
                                      textAlign: TextAlign.end,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Jenis Pengangkutan:"),
                                  Expanded(
                                    child: Text(
                                      "${ValueService.typeOfFormToText(detailSPB.spb?.spbType ?? 1)}",
                                      textAlign: TextAlign.end,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Estate:"),
                                  Expanded(
                                      child: Text(
                                          "${detailSPB.spb?.spbEstateCode ?? ""}",
                                          textAlign: TextAlign.end))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Tujuan:"),
                                  Expanded(
                                    child: Text(
                                        "${detailSPB.spb?.spbDeliverToCode ?? ""} ${detailSPB.spb?.spbDeliverToName ?? ""}",
                                        textAlign: TextAlign.end),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  detailSPB.spb?.spbType == 1
                                      ? Text("Supir:")
                                      : Text("Vendor:"),
                                  detailSPB.spb?.spbVendorOthers == "1"
                                      ? Expanded(
                                          child: Text(
                                              "${detailSPB.spb?.spbDriverEmployeeName ?? ""}",
                                              textAlign: TextAlign.end),
                                        )
                                      : Expanded(
                                          child: Text(
                                              "${detailSPB.spb?.spbDriverEmployeeCode ?? ""} \n${detailSPB.spb?.spbDriverEmployeeName ?? ""}",
                                              textAlign: TextAlign.end),
                                        ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Divisi:"),
                                  Expanded(
                                    child: Text(
                                        "${detailSPB.spb?.spbDivisionCode ?? ""}",
                                        textAlign: TextAlign.end),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Text("No. Kendaraan"),
                                    SizedBox(height: 20),
                                    Text(
                                      "${detailSPB.spb?.spbLicenseNumber ?? ""}",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                detailSPB.onChangeCard
                                    ? Column(
                                        children: [
                                          Text("Kartu SPB"),
                                          Container(
                                            width: 160,
                                            child: Focus(
                                              child: TextFormField(
                                                controller: detailSPB.spbNumber,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .characters,
                                                textAlign: TextAlign.center,
                                                onFieldSubmitted: (value) {
                                                  detailSPB.checkSPBCard(
                                                      context,
                                                      detailSPB.spbNumber.text);
                                                },
                                                onChanged: (value) {
                                                  if (value.length >= 4) {
                                                    detailSPB.checkSPBCard(
                                                        context,
                                                        detailSPB
                                                            .spbNumber.text);
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                    hintText:
                                                        "Tulis Kartu SPB"),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter some text';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () async {
                                                String? result =
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                QRReaderScreen()));
                                                if (result != null) {
                                                  setState(() {
                                                    detailSPB.spbNumber =
                                                        TextEditingController(
                                                            text: result);
                                                  });
                                                }
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                color: Colors.green,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Text(
                                                    "BACA QR KARTU",
                                                    style: Style.whiteBold14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Text("Kartu SPB"),
                                          SizedBox(height: 20),
                                          Text(
                                              "${detailSPB.spb?.spbCardId ?? ""}",
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                              ],
                            ),
                            SizedBox(height: 14),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total OPH:"),
                                  Text("${detailSPB.spb?.spbTotalOph}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total janjang:"),
                                  Text("${detailSPB.spb?.spbTotalBunches ?? 0}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total brondolan (kg):"),
                                  Text(
                                      "${detailSPB.spb?.spbTotalLooseFruit ?? 0}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Estimasi berat (kg):"),
                                  Text(
                                      "${detailSPB.spb?.spbEstimateTonnage ?? 0}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Sisa kapasitas truk (kg):"),
                                  Text(
                                      "${detailSPB.spb?.spbCapacityTonnage ?? 0}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Berat aktual (Kg):"),
                                  Text(
                                      "${detailSPB.spb?.spbActualTonnage ?? ""}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                      "Catatan (${50 - (detailSPB.spb?.spbDeliveryNote?.length ?? 0)})"),
                                  Text(
                                      "${detailSPB.spb?.spbDeliveryNote ?? ""}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                File("${detailSPB.spb?.spbPhoto}"),
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Container();
                                },
                                height: 300,
                              ),
                            ),
                            detailSPB.onChangeCard
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: InkWell(
                                      onTap: () {
                                        detailSPB.onClickSaveSPB(context);
                                      },
                                      child: Card(
                                        color: Palette.primaryColorProd,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(14),
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
                                  )
                                : Container(),
                            widget.method == "UBAH" && detailSPB.isSPBExist
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: InkWell(
                                      onTap: () {
                                        detailSPB.onClickChangeSPB();
                                      },
                                      child: Card(
                                        color: Palette.primaryColorProd,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(14),
                                          child: Text(
                                            "UBAH DATA SPB",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            widget.method == "GANTI" &&
                                    detailSPB.isSPBExist &&
                                    !detailSPB.onChangeCard
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: InkWell(
                                      onTap: () {
                                        detailSPB.onClickChangeCard();
                                      },
                                      child: Card(
                                        color: Palette.primaryColorProd,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(14),
                                          child: Text(
                                            "GANTI KARTU SPB",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            widget.method == "DETAIL" && detailSPB.isSPBExist
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: InkWell(
                                      onTap: () {
                                        detailSPB.onClickChangeSPB();
                                      },
                                      child: Card(
                                        color: Palette.primaryColorProd,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(14),
                                          child: Text(
                                            "UBAH DATA SPB",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            widget.method == "BACA" && detailSPB.isSPBExist
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: InkWell(
                                      onTap: () {
                                        detailSPB.onClickChangeSPB();
                                      },
                                      child: Card(
                                        color: Palette.primaryColorProd,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(14),
                                          child: Text(
                                            "UBAH DATA SPB",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ]),
                        ),
                      ),
                      Center(
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                                "Daftar OPH (${detailSPB.listSPBDetail.length})"),
                          ),
                          Flexible(
                            child: ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: detailSPB.listSPBDetail.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0),
                                            child: Text(
                                                "${detailSPB.listSPBDetail[index].ophId}",
                                                style: Style.textBold16),
                                          ),
                                          Text(
                                              "Janjang terkirim: ${detailSPB.listSPBDetail[index].ophBunchesDelivered}"),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0),
                                            child: Text(
                                                "Brondolan (kg)  : ${detailSPB.listSPBDetail[index].ophLooseFruitDelivered}"),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "Blok: ${detailSPB.listSPBDetail[index].ophBlockCode}"),
                                              Text(
                                                  "TPH: ${detailSPB.listSPBDetail[index].ophTphCode}"),
                                              Text(
                                                  "Kartu: ${detailSPB.listSPBDetail[index].ophCardId}"),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )
                        ]),
                      ),
                      Center(
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "Daftar Loader (${detailSPB.listSPBLoader.length})"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "Jumlah presentase: (${detailSPB.percentageLoader}) %"),
                          ),
                          Flexible(
                            child: ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: detailSPB.listSPBLoader.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Jenis Loader:"),
                                              Text(
                                                  "${ValueService.typeOfFormToText(detailSPB.listSPBLoader[index].loaderType!)}"),
                                            ],
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Nama Loader:"),
                                                Text(
                                                  "${detailSPB.listSPBLoader[index].loaderEmployeeCode}\n${detailSPB.listSPBLoader[index].loaderEmployeeName}",
                                                  textAlign: TextAlign.right,
                                                ),
                                              ]),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Jenis Angkut:"),
                                                Text(
                                                    "${ValueService.typeOfDestination(detailSPB.listSPBLoader[index].loaderDestinationType!)}"),
                                              ]),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Presentase Angkut:"),
                                                Text(
                                                    "${detailSPB.listSPBLoader[index].loaderPercentage} %"),
                                              ])
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )
                        ]),
                      ),
                    ])
                  : TabBarView(children: <Widget>[
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("ID SPB:"),
                                  Text(
                                    "${detailSPB.spb?.spbId ?? ""}",
                                    style: Style.textBold16,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Tanggal:"),
                                  Text("${detailSPB.spb?.createdDate ?? ""}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("GPS Geolocation:"),
                                  Text(
                                      "${detailSPB.spb?.spbLat ?? ""}, ${detailSPB.spb?.spbLong ?? ""}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Jenis Pengangkutan:"),
                                  Text(
                                      "${ValueService.typeOfFormToText(detailSPB.spb?.spbType ?? 1)}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Estate:"),
                                  Text("${detailSPB.spb?.spbEstateCode ?? ""}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Tujuan:"),
                                  Text(
                                      "${detailSPB.spb?.spbDeliverToCode ?? ""} ${detailSPB.spb?.spbDeliverToName ?? ""}"),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  detailSPB.spb?.spbType == 1
                                      ? Text("Supir:")
                                      : Text("Vendor:"),
                                  Text(
                                      "${detailSPB.spb?.spbDriverEmployeeCode ?? ""} ${detailSPB.spb?.spbDriverEmployeeName ?? ""}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Divisi:"),
                                  Text(
                                      "${detailSPB.spb?.spbDivisionCode ?? ""}")
                                ],
                              ),
                            ),
                            SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Text("No. Kendaraan"),
                                    SizedBox(height: 20),
                                    Text(
                                      "${detailSPB.spb?.spbLicenseNumber ?? ""}",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                detailSPB.onChangeCard
                                    ? Column(
                                        children: [
                                          Text("Kartu SPB"),
                                          Container(
                                            width: 160,
                                            child: Focus(
                                              child: TextFormField(
                                                controller: detailSPB.spbNumber,
                                                textAlign: TextAlign.center,
                                                onFieldSubmitted: (value) {
                                                  detailSPB.checkSPBCard(
                                                      context,
                                                      detailSPB.spbNumber.text);
                                                },
                                                onChanged: (value) {
                                                  if (value.length >= 4) {
                                                    detailSPB.checkSPBCard(
                                                        context,
                                                        detailSPB
                                                            .spbNumber.text);
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                    hintText:
                                                        "Tulis Kartu SPB"),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter some text';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () async {
                                                String? result =
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                QRReaderScreen()));
                                                if (result != null) {
                                                  setState(() {
                                                    detailSPB.spbNumber =
                                                        TextEditingController(
                                                            text: result);
                                                  });
                                                }
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                color: Colors.green,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Text(
                                                    "BACA QR KARTU",
                                                    style: Style.whiteBold14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Text("Kartu SPB"),
                                          SizedBox(height: 20),
                                          Text(
                                              "${detailSPB.spb?.spbCardId ?? ""}",
                                              style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                              ],
                            ),
                            SizedBox(height: 14),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total OPH:"),
                                  Text("${detailSPB.spb?.spbTotalOph}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total janjang:"),
                                  Text("${detailSPB.spb?.spbTotalBunches ?? 0}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total brondolan (kg):"),
                                  Text(
                                      "${detailSPB.spb?.spbTotalLooseFruit ?? 0}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Estimasi berat (kg):"),
                                  Text(
                                      "${detailSPB.spb?.spbEstimateTonnage ?? 0}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Sisa kapasitas truk (kg):"),
                                  Text(
                                      "${detailSPB.spb?.spbCapacityTonnage ?? 0}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Berat aktual (Kg):"),
                                  Text(
                                      "${detailSPB.spb?.spbActualTonnage ?? ""}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                      "Catatan (${50 - (detailSPB.spb?.spbDeliveryNote?.length ?? 0)})"),
                                  Text(
                                      "${detailSPB.spb?.spbDeliveryNote ?? ""}")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                File("${detailSPB.spb?.spbPhoto}"),
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Container();
                                },
                                height: 300,
                              ),
                            ),
                            detailSPB.onChangeCard
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: InkWell(
                                      onTap: () {
                                        detailSPB.onClickSaveSPB(context);
                                      },
                                      child: Card(
                                        color: Palette.primaryColorProd,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(14),
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
                                  )
                                : Container(),
                            widget.method == "UBAH" && detailSPB.isSPBExist
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: InkWell(
                                      onTap: () {
                                        detailSPB.onClickChangeSPB();
                                      },
                                      child: Card(
                                        color: Palette.primaryColorProd,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(14),
                                          child: Text(
                                            "UBAH DATA SPB",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            widget.method == "GANTI" &&
                                    detailSPB.isSPBExist &&
                                    !detailSPB.onChangeCard
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: InkWell(
                                      onTap: () {
                                        detailSPB.onClickChangeCard();
                                      },
                                      child: Card(
                                        color: Palette.primaryColorProd,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(14),
                                          child: Text(
                                            "GANTI KARTU SPB",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            widget.method == "DETAIL" && detailSPB.isSPBExist
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: InkWell(
                                      onTap: () {
                                        detailSPB.onClickChangeSPB();
                                      },
                                      child: Card(
                                        color: Palette.primaryColorProd,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(14),
                                          child: Text(
                                            "UBAH DATA SPB",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            widget.method == "BACA" && detailSPB.isSPBExist
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: InkWell(
                                      onTap: () {
                                        detailSPB.onClickChangeSPB();
                                      },
                                      child: Card(
                                        color: Palette.primaryColorProd,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(14),
                                          child: Text(
                                            "UBAH DATA SPB",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ]),
                        ),
                      ),
                    ]),
            ),
          ),
        ),
      );
    });
  }
}
