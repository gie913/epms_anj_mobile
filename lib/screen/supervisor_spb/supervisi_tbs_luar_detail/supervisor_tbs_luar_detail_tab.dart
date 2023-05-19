import 'dart:io';

import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_detail/supervisor_tbs_luar_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorTBSLuarDetailTab extends StatefulWidget {
  const SupervisorTBSLuarDetailTab({Key? key}) : super(key: key);

  @override
  State<SupervisorTBSLuarDetailTab> createState() =>
      _SupervisorTBSLuarDetailTabState();
}

class _SupervisorTBSLuarDetailTabState
    extends State<SupervisorTBSLuarDetailTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SupervisorTBSLuarDetailNotifier>(
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
                    Text("${notifier.tbsLuar?.sortasiID ?? ""}",
                        style: Style.textBold16)
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tanggal:"),
                  Text(
                      "${notifier.tbsLuar?.createdDate ?? ""} ${notifier.tbsLuar?.createdTime ?? ""}")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Nama Driver:"),
                  Text("${notifier.tbsLuar?.driverName ?? ""}")
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
                      "${notifier.tbsLuar?.gpsLat ?? ""},${notifier.tbsLuar?.gpsLong ?? ""}")
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text("Quantity:"),
            //       Text("${notifier.tbsLuar?.quantity ?? ""}"),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text("Contract No:"),
            //       Text("${notifier.tbsLuar?.contractNumber ?? ""}")
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Supplier:"),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("${notifier.tbsLuar?.supplierCode ?? ""}"),
                      Text("${ValueService.rightTrimVendor(notifier.tbsLuar!.supplierName!)}"),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Text("Nomor Kendaraan"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${notifier.tbsLuar?.licenseNumber ?? ""}",
                    style: Style.textBold18,
                    textAlign: TextAlign.center,
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${notifier.tbsLuar?.spdID ?? ""}",
                                  style: Style.textBold18,
                                  textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 18),
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
            notifier.onEdit ? Padding(
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
            ) : Container(),
            notifier.onEdit ? Column(
              children: [
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      notifier.onChangeEdit(false);
                    },
                    child: Card(
                      color: Palette.redColorDark,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(14),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "BATAL",
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
            ) : Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  notifier.onChangeEdit(true);
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
