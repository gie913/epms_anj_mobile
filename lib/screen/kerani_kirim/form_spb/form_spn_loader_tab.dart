import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/bunches_formatter.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/m_vendor_schema.dart';
import 'package:epms/screen/kerani_kirim/form_spb/form_spb_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FormSPBLoaderTab extends StatefulWidget {
  const FormSPBLoaderTab({Key? key}) : super(key: key);

  @override
  State<FormSPBLoaderTab> createState() => _FormSPBLoaderTabState();
}

class _FormSPBLoaderTabState extends State<FormSPBLoaderTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FormSPBNotifier>(builder: (context, formSPB, child) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text("Daftar Loader (${formSPB.spbLoaderList.length})"),
                      SizedBox(height: 12),
                      Text(
                          "Jumlah Presentase: (${formSPB.totalPercentageAngkut}) %"),
                      SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: InkWell(
                          onTap: () {
                            formSPB.onAddLoader(context);
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
                                child: Text(
                                  "+ TAMBAH LOADER",
                                  style: Style.whiteBold14,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (formSPB.spbLoaderList.isEmpty)
                  Text("Tidak Ada loader yang dibuat")
                else
                  Flexible(
                    child: ListView.builder(
                        controller: formSPB.scrollController,
                        itemCount: formSPB.spbLoaderList.length,
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
                                          formSPB.onDeleteLoader(index);
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
                                              value: formSPB.loaderType[index],
                                              items: formSPB.typeDeliver
                                                  .map((value) {
                                                return DropdownMenuItem(
                                                  child: Text(value),
                                                  value: value,
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                formSPB.onChangeLoaderType(
                                                    index, value!);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  formSPB.loaderType[index] == "Internal"
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
                                                      value: formSPB
                                                          .loaderName[index],
                                                      items: formSPB
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
                                                        formSPB
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
                                                        value: formSPB
                                                            .vendorName[index],
                                                        items: formSPB
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
                                                          formSPB
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
                                                value: formSPB
                                                    .jenisAngkutValue[index],
                                                items: formSPB.jenisAngkut
                                                    .map((value) {
                                                  return DropdownMenuItem(
                                                      child: Text("$value",
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      value: value);
                                                }).toList(),
                                                onChanged: (String? value) {
                                                  formSPB.onChangeJenisAngkut(
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
                                                  formSPB
                                                      .onChangePercentageAngkut(
                                                          context,
                                                          index,
                                                          value);
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: formSPB
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
    });
  }
}
