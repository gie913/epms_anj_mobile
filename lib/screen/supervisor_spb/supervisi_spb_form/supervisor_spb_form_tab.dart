import 'dart:io';

import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/model/m_division_schema.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/m_estate_schema.dart';
import 'package:epms/model/m_vendor_schema.dart';
import 'package:epms/screen/qr_reader/qr_reader_screen.dart';
import 'package:epms/screen/search/search_driver_screen.dart';
import 'package:epms/screen/supervisor_spb/supervisi_spb_form/supervisor_spb_form_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorSPBFormTab extends StatefulWidget {
  const SupervisorSPBFormTab({Key? key}) : super(key: key);

  @override
  State<SupervisorSPBFormTab> createState() => _SupervisorSPBFormTabState();
}

class _SupervisorSPBFormTabState extends State<SupervisorSPBFormTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SupervisorSPBFormNotifier>(
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
                    Text("${notifier.supervisiID}", style: Style.textBold16)
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Tanggal:"), Text("${notifier.date}")],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Nama:"),
                  Text("${notifier.mConfigSchema?.employeeName ?? ""}")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("GPS Geolocation:"),
                  Text("${notifier.gpsLocation}")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Sumber SPB:"),
                        Flexible(
                          child: Container(
                            width: 140,
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
                                notifier.onChangeSourceSPB(value!);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    notifier.sourceSPBValue == "Internal"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Jenis Pekerja:"),
                              Flexible(
                                child: Container(
                                  width: 140,
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: notifier.employeeTypeValue,
                                    items: notifier.employeeType.map((value) {
                                      return DropdownMenuItem(
                                        child: Text(value),
                                        value: value,
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      notifier.onChangeTypeEmployee(value!);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    SizedBox(height: 8),
                    notifier.sourceSPBValue == "External"
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Driver:"),
                                Flexible(
                                  child: Container(
                                    width: 200,
                                    child: TextFormField(
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      controller: notifier.driverTBSLuar,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                          hintText: "Nama Supir"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    notifier.sourceSPBValue == "Internal" &&
                            notifier.employeeTypeValue == "Internal"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Nama Supir:"),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 180,
                                    child: DropdownButton(
                                      isExpanded: true,
                                      icon: Visibility(
                                          visible: false,
                                          child: Icon(Icons.arrow_downward)),
                                      hint: Text("Nama Supir"),
                                      value: notifier.driver,
                                      items: notifier.listDriver.map((value) {
                                        return DropdownMenuItem(
                                          child: Text(
                                            value.employeeName!,
                                            style: Style.textBold14,
                                          ),
                                          value: value,
                                        );
                                      }).toList(),
                                      onChanged: null,
                                    ),
                                  ),
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.search),
                                    ),
                                    onTap: () async {
                                      MEmployeeSchema? mEmployee =
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SearchDriverScreen()));
                                      notifier.onSetDriver(mEmployee!);
                                    },
                                  ),
                                ],
                              )
                            ],
                          )
                        : Container(),
                    SizedBox(height: 8),
                    notifier.employeeTypeValue == "Kontrak" ||
                            notifier.sourceSPBValue == "External"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Vendor:"),
                              Flexible(
                                child: Container(
                                  width: 200,
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: Text("Pilih Vendor"),
                                    value: notifier.vendor,
                                    items: notifier.listVendor.map((value) {
                                      return DropdownMenuItem(
                                        child: Text("${value.vendorName}"),
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
                          )
                        : Container(),
                    SizedBox(height: 8),
                    notifier.employeeTypeValue == "Kontrak" ||
                            notifier.sourceSPBValue == "External"
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: notifier.isChecked,
                                  onChanged: (bool? value) {
                                    notifier.onChangeChecked(value!);
                                  },
                                ),
                                Flexible(
                                  child: Container(
                                    width: 200,
                                    child: TextFormField(
                                      enabled: notifier.isChecked,
                                      controller: notifier.vendorOther,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                          hintText: "Tulis Vendor"),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(height: 8),
                    notifier.sourceSPBValue == "Internal"
                        ? Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Estate Code:"),
                                Flexible(
                                  child: Container(
                                    width: 140,
                                    child: DropdownButton(
                                      isExpanded: true,
                                      hint: Text("Pilih Estate"),
                                      value: notifier.mEstateSchemaValue,
                                      items: notifier.listMEstateSchema
                                          .map((value) {
                                        return DropdownMenuItem(
                                          child: Text("${value.estateCode}"),
                                          value: value,
                                        );
                                      }).toList(),
                                      onChanged: (MEstateSchema? value) {
                                        notifier.onChangeEstateSchema(value!);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ]),
            ),
            notifier.sourceSPBValue == "Internal"
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Divisi:"),
                        Flexible(
                          child: Container(
                            width: 140,
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Text("Pilih Divisi"),
                              value: notifier.division,
                              items: notifier.listDivision.map((value) {
                                return DropdownMenuItem(
                                  child: Text("${value.divisionCode}"),
                                  value: value,
                                );
                              }).toList(),
                              onChanged: (MDivisionSchema? value) {
                                notifier.onChangeDivision(value!);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
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
                if (notifier.sourceSPBValue == 'Internal')
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        String? result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QRReaderScreen()));
                        if (result != null) {
                          setState(() {
                            notifier.vehicleNumber =
                                TextEditingController(text: result);
                          });
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
                            "BACA QR Truk",
                            style: Style.whiteBold14,
                          ),
                        ),
                      ),
                    ),
                  )
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
                              Text("No ID SPB"),
                              Container(
                                width: 160,
                                child: Focus(
                                  child: TextFormField(
                                    enabled: notifier.activeText,
                                    controller: notifier.spbID,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    onChanged: (value) {
                                      if (value.length >= 17) {
                                        notifier.checkDONumber(value);
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
                      notifier.sourceSPBValue == "External"
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () async {
                                  String? result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              QRReaderScreen()));
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
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  notifier.dialogNFC(context);
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.green,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "Scan SPB",
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
                        "FOTO HASIL SUPERVISI",
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
