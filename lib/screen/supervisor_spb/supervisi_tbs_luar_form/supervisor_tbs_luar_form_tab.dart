import 'dart:io';

import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/model/m_vendor_schema.dart';
import 'package:epms/screen/qr_reader/qr_reader_screen.dart';
import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_form/supervisor_tbs_luar_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorTBSLuarFormTab extends StatefulWidget {
  const SupervisorTBSLuarFormTab({Key? key}) : super(key: key);

  @override
  State<SupervisorTBSLuarFormTab> createState() =>
      _SupervisorTBSLuarFormTabState();
}

class _SupervisorTBSLuarFormTabState extends State<SupervisorTBSLuarFormTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SupervisorTBSLuarNotifier>(
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
                    Text("ID Supervisi:"),
                    Text("${notifier.supervisiTBSID}", style: Style.textBold16)
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Tanggal:"), Text("${notifier.date} ${notifier.time}")],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Nama:"), Text("${notifier.mConfigSchema?.employeeName}")],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("GPS Geolocation:"), Text("${notifier.gpsLocation}")],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Quantity:"),
                  Flexible(
                    child: Container(
                      width: 200,
                      child: TextFormField(
                        textCapitalization: TextCapitalization.characters,
                        controller: notifier.quantity,
                        textAlign: TextAlign.center,
                        decoration:
                        InputDecoration(hintText: "Quantity"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Contract No:"),
                  Flexible(
                    child: Container(
                      width: 200,
                      child: TextFormField(
                        textCapitalization: TextCapitalization.characters,
                        controller: notifier.contractNumber,
                        textAlign: TextAlign.center,
                        decoration:
                        InputDecoration(hintText: "No Kontrak"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Supplier:"),
                  Flexible(
                    child: Container(
                      width: 200,
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text("Pilih Supplier"),
                        value: notifier.vendor,
                        items: notifier.listVendor.map((value) {
                          return DropdownMenuItem(
                            child: Text(
                                "${value.vendorName}"),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (MVendorSchema? value) {
                          notifier.onChangeVendor(value!);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Driver:"),
                  Flexible(
                    child: Container(
                      width: 200,
                      child: TextFormField(
                        textCapitalization: TextCapitalization.characters,
                        controller: notifier.driver,
                        textAlign: TextAlign.center,
                        decoration:
                        InputDecoration(hintText: "Nama Supir"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Text("Nomor Kendaraan"),
                Container(
                  width: 160,
                  child: TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    controller: notifier.vehicleNumber,
                    textAlign: TextAlign.center,
                    decoration:
                        InputDecoration(hintText: "Tulis No. Kendaraan"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Text("No ID DO"),
                              Container(
                                width: 160,
                                child: Focus(
                                  child: TextFormField(
                                    enabled: notifier.activeText,
                                    controller: notifier.deliveryID,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    onChanged: (value) {
                                      if(value.length >= 17) {

                                      }
                                    },
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        hintText: "Tulis No Kartu SPB"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text("Aktifkan Tulisan"),
                              Container(
                                width: 160,
                                child: Switch(
                                    activeColor: Palette.greenColor,
                                    value: notifier.activeText,
                                    onChanged: (value) {
                                      notifier.onChangeActiveText(value);
                                    }),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async {
                            String? result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QRReaderScreen()));
                            if (result != null) {
                                notifier.setQRResult(result);
                            }
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.green,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Scan QR DO",
                                style: Style.whiteBold14,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            notifier.pickedFile != null
                ? Image.file(
                    File("${notifier.pickedFile}"),
                    height: 400,
                  )
                : Container(),
            Padding(
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
                        "FOTO HASIL GRADING",
                        style: Style.whiteBold14,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
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
            ),
          ]),
        ),
      );
    });
  }
}
