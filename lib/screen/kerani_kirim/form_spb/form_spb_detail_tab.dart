import 'dart:io';

import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/model/m_destination_schema.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/m_vendor_schema.dart';
import 'package:epms/screen/kerani_kirim/form_spb/form_spb_notifier.dart';
import 'package:epms/screen/qr_reader/qr_reader_screen.dart';
import 'package:epms/screen/search/search_driver_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class FormSPBDetailTab extends StatefulWidget {
  const FormSPBDetailTab({Key? key}) : super(key: key);

  @override
  State<FormSPBDetailTab> createState() => _FormSPBDetailTabState();
}

class _FormSPBDetailTabState extends State<FormSPBDetailTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FormSPBNotifier>(builder: (context, formSPB, child) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ID SPB:"),
                    Expanded(
                      child: Text(
                        "${formSPB.spbID ?? ""}",
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tanggal:"),
                    Expanded(
                        child: Text("${formSPB.date ?? ""}",
                            textAlign: TextAlign.end)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("GPS Geolocation:"),
                    Expanded(
                        child: Text(
                      "${formSPB.gpsLocation}",
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
                    Text("Jenis Pengangkutan:"),
                    Flexible(
                      child: Container(
                        width: 140,
                        child: DropdownButton(
                          isExpanded: true,
                          value: formSPB.typeDeliverValue,
                          items: formSPB.typeDeliver.map((value) {
                            return DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            formSPB.onChangeDeliveryType(value!);
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
                    Expanded(child: Text("Tujuan:")),
                    Expanded(
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text("Pilih tujuan"),
                        value: formSPB.destinationValue,
                        items: formSPB.destinationList.map((value) {
                          return DropdownMenuItem(
                            child: Text(value.destinationName!),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (MDestinationSchema? value) {
                          formSPB.onChangeDestination(value!);
                        },
                      ),
                    )
                  ],
                ),
              ),
              formSPB.typeDeliverValue == "Internal"
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("Supir:")),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 145,
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: Text("Pilih Supir"),
                                    value: formSPB.driverNameValue,
                                    items: formSPB.driverNameList.map((value) {
                                      return DropdownMenuItem(
                                        child: Text(value.employeeName!),
                                        value: value,
                                      );
                                    }).toList(),
                                    onChanged: (MEmployeeSchema? value) {
                                      formSPB.onChangeDriver(value!);
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 2.0),
                                      child: Icon(Icons.search),
                                    ),
                                    onTap: () async {
                                      MEmployeeSchema? mEmployee =
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SearchDriverScreen()));
                                      formSPB.onChangeDriver(mEmployee!);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("Vendor:")),
                          Flexible(
                            child: Container(
                              width: 180,
                              child: DropdownButton(
                                isExpanded: true,
                                hint: Text("Pilih Vendor"),
                                value: formSPB.vendorSchemaValue,
                                items: formSPB.vendorList.map((value) {
                                  return DropdownMenuItem(
                                    child: Text(value.vendorName!),
                                    value: value,
                                  );
                                }).toList(),
                                onChanged: !formSPB.isOthersVendor
                                    ? (MVendorSchema? value) {
                                        formSPB.onChangeVendor(value!);
                                      }
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              formSPB.typeDeliverValue == "Kontrak"
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("Lainnya:"),
                              Checkbox(
                                checkColor: Colors.white,
                                value: formSPB.isOthersVendor,
                                onChanged: (bool? value) {
                                  formSPB.onCheckOtherVendor(value!);
                                },
                              )
                            ],
                          ),
                          Flexible(
                            child: Container(
                              width: 180,
                              child: TextFormField(
                                enabled: formSPB.isOthersVendor,
                                controller: formSPB.vendorOther,
                                textAlign: TextAlign.center,
                                decoration:
                                    InputDecoration(hintText: "Tulis Vendor"),
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
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("No. Kendaraan"),
                        Container(
                          width: 160,
                          child: Focus(
                            onFocusChange: (hasFocus) {
                              if (!hasFocus) {
                                formSPB.checkVehicle(
                                    context, formSPB.vehicleNumber.text);
                              }
                            },
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length >= 8) {
                                  formSPB.checkVehicle(context, value);
                                }
                              },
                              onFieldSubmitted: (value) {
                                formSPB.checkVehicle(context, value);
                              },
                              controller: formSPB.vehicleNumber,
                              textCapitalization: TextCapitalization.characters,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  hintText: "Tulis No Kendaraan"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
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
                              String? result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QRReaderScreen()));
                              if (result != null) {
                                setState(() {
                                  formSPB.vehicleNumber =
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
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text("Kartu SPB"),
                        Container(
                          width: 160,
                          child: Focus(
                            child: TextFormField(
                              controller: formSPB.spbCardNumber,
                              textAlign: TextAlign.center,
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (value) {
                                if (value.length >= 4) {
                                  formSPB.checkSPBCard(context, value);
                                }
                              },
                              onFieldSubmitted: (value) {
                                formSPB.checkSPBCard(context, value);
                              },
                              decoration:
                                  InputDecoration(hintText: "Tulis Kartu SPB"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
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
                              String? result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QRReaderScreen()));
                              if (result != null) {
                                setState(() {
                                  formSPB.spbCardNumber =
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
                                  "BACA QR KARTU",
                                  style: Style.whiteBold14,
                                  textAlign: TextAlign.center,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total OPH:"),
                    Text("${formSPB.listSPBDetail.length}")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total janjang:"),
                    Text(
                        "${ValueService.thousandSeparator(formSPB.totalBunches)}")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total brondolan (kg):"),
                    Text(
                        "${ValueService.thousandSeparator(formSPB.totalLooseFruits)}")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Estimasi berat (kg):"),
                    Text(
                        "${ValueService.thousandSeparator(formSPB.totalWeightEstimation.toInt())}")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sisa kapasitas truk (kg):"),
                    Text(
                      "${ValueService.thousandSeparator(formSPB.totalCapacityTruck)}",
                      style: formSPB.totalCapacityTruck < 0
                          ? TextStyle(color: Colors.red)
                          : Style.textBold,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Berat aktual (Kg):"), Text("${0}")],
                ),
              ),
              Column(
                children: [
                  Text("Catatan"),
                  Container(
                    child: TextFormField(
                      controller: formSPB.notesSPB,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(hintText: "Tulis Catatan"),
                      maxLength: 50,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    ),
                  ),
                ],
              ),
              formSPB.pickedFile != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        File("${formSPB.pickedFile}"),
                        height: 400,
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    formSPB.getCamera(context);
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
                          "AMBIL FOTO",
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
                  onTap: () async {
                    if (await Permission
                        .locationWhenInUse.serviceStatus.isEnabled) {
                      formSPB.onClickSaveSPB(context);
                    } else {
                      FlushBarManager.showFlushBarWarning(
                          context,
                          "Gps Tidak Aktif",
                          "Mohon mengaktifkan fitur gps pada perangkat Anda");
                    }
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
            ],
          ),
        ),
      );
    });
  }
}
