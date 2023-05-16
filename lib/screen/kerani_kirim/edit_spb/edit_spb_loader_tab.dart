import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/bunches_formatter.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/m_vendor_schema.dart';
import 'package:epms/screen/kerani_kirim/edit_spb/edit_spb_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditSPBLoaderTab extends StatefulWidget {
  const EditSPBLoaderTab({Key? key}) : super(key: key);

  @override
  State<EditSPBLoaderTab> createState() => _EditSPBLoaderTabState();
}

class _EditSPBLoaderTabState extends State<EditSPBLoaderTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EditSPBNotifier>(
      builder: (context, editSPB, child) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Daftar Loader (${editSPB.spbLoaderList.length})"),
                  SizedBox(height: 12),
                  Text(
                      "Jumlah Presentase: (${editSPB.totalPercentageAngkut}) %"),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        editSPB.onAddLoader(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Palette.primaryColorProd,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("+ TAMBAH LOADER",
                                style: Style.whiteBold14,
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  editSPB.spbLoaderList.isEmpty
                      ? Text("Tidak Ada loader yang dibuat")
                      : Flexible(
                    child: ListView.builder(
                        controller: editSPB.scrollController,
                        itemCount: editSPB.spbLoaderList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "${index + 1}",
                                          style: Style.textBold18,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          editSPB.onDeleteLoader(index);
                                        },
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Icon(Icons.delete,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6.0, right: 6.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Jenis Loader:"),
                                        Flexible(
                                          child: Container(
                                            width: 170,
                                            child: DropdownButton(
                                              isExpanded: true,
                                              value: editSPB.loaderType[index],
                                              items: editSPB.typeDeliver
                                                  .map((value) {
                                                return DropdownMenuItem(
                                                  child: Text(value),
                                                  value: value,
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                editSPB.onChangeLoaderType(
                                                    index, value!);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  editSPB.loaderType[index] == "Internal"
                                      ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6.0, right: 6.0),
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text("Nama Loader:"),
                                          Flexible(
                                            child: Container(
                                              width: 170,
                                              child: DropdownButton(
                                                isExpanded: true,
                                                value: editSPB
                                                    .loaderName[index],
                                                items: editSPB
                                                    .driverNameList
                                                    .map((value) {
                                                  return DropdownMenuItem(
                                                    child: Text(
                                                      "${value.employeeName}",
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                    ),
                                                    value: value,
                                                  );
                                                }).toList(),
                                                onChanged:
                                                    (MEmployeeSchema?
                                                value) {
                                                  editSPB
                                                      .onChangeLoaderName(
                                                      index, value!);
                                                },
                                              ),
                                            ),
                                          ),
                                        ]),
                                  )
                                      : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6.0, right: 6.0),
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text("Nama Vendor:"),
                                          Flexible(
                                            child: Container(
                                              width: 170,
                                              child: DropdownButton(
                                                  isExpanded: true,
                                                  value: editSPB
                                                      .vendorName[index],
                                                  items: editSPB
                                                      .vendorList
                                                      .map((value) {
                                                    return DropdownMenuItem(
                                                      child: Text(
                                                          "${value.vendorName}",
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis),
                                                      value: value,
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (MVendorSchema?
                                                  value) {
                                                    editSPB
                                                        .onChangeVendorName(
                                                        index,
                                                        value!);
                                                  }),
                                            ),
                                          ),
                                        ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6.0, right: 6.0),
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Jenis Angkut:"),
                                          Flexible(
                                            child: Container(
                                              width: 170,
                                              child: DropdownButton(
                                                isExpanded: true,
                                                value: editSPB
                                                    .jenisAngkutValue[index],
                                                items: editSPB.jenisAngkut
                                                    .map((value) {
                                                  return DropdownMenuItem(
                                                      child: Text("$value",
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      value: value);
                                                }).toList(),
                                                onChanged: (String? value) {
                                                  editSPB.onChangeJenisAngkut(
                                                      index, value!);
                                                },
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Presentase Angkut (%):"),
                                          Flexible(
                                            child: Container(
                                              width: 170,
                                              child: TextFormField(
                                                maxLength: 3,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9]')),
                                                  BunchesFormatter()
                                                ],
                                                onChanged: (value) {
                                                  editSPB
                                                      .onChangePercentageAngkut(
                                                      context,
                                                      index,
                                                      value);
                                                },
                                                keyboardType:
                                                TextInputType.number,
                                                controller: editSPB
                                                    .percentageAngkut[index],
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                    hintText: "presentase"),
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ]),
                              ),
                            ),
                          );
                        }),
                  ),
                ]),
          ),
        );
      },
    );
  }
}
