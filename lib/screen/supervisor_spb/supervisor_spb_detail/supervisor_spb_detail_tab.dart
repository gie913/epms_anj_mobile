import 'dart:io';

import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/screen/supervisor_spb/supervisor_spb_detail/supervisor_spb_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorSPBDetailTab extends StatefulWidget {
  const SupervisorSPBDetailTab({Key? key}) : super(key: key);

  @override
  State<SupervisorSPBDetailTab> createState() => _SupervisorSPBDetailTabState();
}

class _SupervisorSPBDetailTabState extends State<SupervisorSPBDetailTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SupervisorSPBDetailNotifier>(
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
                    Text("${notifier.spbSupervise.spbSuperviseId}",
                        style: Style.textBold16)
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tanggal:"),
                  Text("${notifier.spbSupervise.createdDate}")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Nama:"),
                  Text("${notifier.spbSupervise.supervisiSpbEmployeeName}")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("GPS Geolocation:"),
                  Text(
                      "${notifier.spbSupervise.supervisiSpbLat ?? ""}, ${notifier.spbSupervise.supervisiSpbLong ?? ""}")
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
                        Text(
                            "${ValueService.spbSourceDataText(notifier.spbSupervise.supervisiSpbType!)}")
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Jenis Pekerja:"),
                        Text(
                            "${ValueService.typeOfFormToText(notifier.spbSupervise.supervisiSpbMethod!)}")
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Nama Supir:"),
                        Text(
                            "${notifier.spbSupervise.supervisiSpbDriverEmployeeCode},\n${notifier.spbSupervise.supervisiSpbDriverEmployeeName}")
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Divisi:"),
                        Text(
                            "${notifier.spbSupervise.supervisiSpbDivisionCode}")
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("No Kendaraan:"),
                        Text(
                            "${notifier.spbSupervise.supervisiSpbLicenseNumber}")
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Estate:"),
                        Text(
                            "${notifier.spbSupervise.supervisiEstateCode}")
                      ],
                    ),
                    SizedBox(height: 8),
                    notifier.onEdit ?
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
                    ) : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("No ID SPB:"),
                        Text(
                            "${notifier.spbSupervise.spbId}")
                      ],
                    ),
                  ]),
            ),
            SizedBox(height: 10),
            notifier.spbSupervise.supervisiSpbPhoto != null
                ? Image.file(
                    File("${notifier.spbSupervise.supervisiSpbPhoto}"),
                    height: 400,
                  )
                : Container(),
            notifier.onEdit
                ? Padding(
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
                              "FOTO HASIL PANEN",
                              style: Style.whiteBold14,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            notifier.onEdit
                ? Padding(
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
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        notifier.onChangeEdit();
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
                            "UBAH DATA",
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
