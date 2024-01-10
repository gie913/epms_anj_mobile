import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/base/ui/theme_notifier.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/screen/kerani_kirim/form_spb/form_spb_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormSPBOPHTab extends StatefulWidget {
  const FormSPBOPHTab({Key? key}) : super(key: key);

  @override
  State<FormSPBOPHTab> createState() => _FormSPBOPHTabState();
}

class _FormSPBOPHTabState extends State<FormSPBOPHTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FormSPBNotifier>(builder: (context, formSPB, child) {
      return Container(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Daftar OPH (${formSPB.listSPBDetail.length})"),
                ),
                SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      formSPB.onClickScanOPH(context);
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
                            "SCAN KARTU OPH",
                            style: Style.whiteBold14,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                formSPB.listSPBDetail.isEmpty
                    ? Text(
                        "Belum ada OPH",
                        style: Style.textBold14,
                      )
                    : Flexible(
                        child: ListView.builder(
                            itemCount: formSPB.listSPBDetail.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Consumer<ThemeNotifier>(
                                builder: (context, themeNotifier, _) {
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${formSPB.listSPBDetail[index].ophId}",
                                                        style: Style.textBold18
                                                            .copyWith(
                                                          color: ValueService.plasmaValidator(formSPB
                                                                      .listSPBDetail[
                                                                          index]
                                                                      .ophEstateCode!) ==
                                                                  1
                                                              ? themeNotifier.status ==
                                                                          true ||
                                                                      MediaQuery.of(context)
                                                                              .platformBrightness ==
                                                                          Brightness
                                                                              .dark
                                                                  ? Colors.white
                                                                  : Colors.black
                                                              : Colors
                                                                  .orangeAccent,
                                                        ),
                                                      ),
                                                      SizedBox(height: 16),
                                                      Text(
                                                        "Janjang terkirim : ${formSPB.listSPBDetail[index].ophBunchesDelivered}",
                                                        style: TextStyle(
                                                          color: ValueService.plasmaValidator(formSPB
                                                                      .listSPBDetail[
                                                                          index]
                                                                      .ophEstateCode!) ==
                                                                  1
                                                              ? themeNotifier.status ==
                                                                          true ||
                                                                      MediaQuery.of(context)
                                                                              .platformBrightness ==
                                                                          Brightness
                                                                              .dark
                                                                  ? Colors.white
                                                                  : Colors.black
                                                              : Colors
                                                                  .orangeAccent,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Brondolan (kg) : ${formSPB.listSPBDetail[index].ophLooseFruitDelivered}",
                                                        style: TextStyle(
                                                          color: ValueService.plasmaValidator(formSPB
                                                                      .listSPBDetail[
                                                                          index]
                                                                      .ophEstateCode!) ==
                                                                  1
                                                              ? themeNotifier.status ==
                                                                          true ||
                                                                      MediaQuery.of(context)
                                                                              .platformBrightness ==
                                                                          Brightness
                                                                              .dark
                                                                  ? Colors.white
                                                                  : Colors.black
                                                              : Colors
                                                                  .orangeAccent,
                                                        ),
                                                      )
                                                    ]),
                                                InkWell(
                                                  onTap: () {
                                                    formSPB.onDeleteOPH(index);
                                                  },
                                                  child: Card(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Icon(Icons.delete,
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                          Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Blok: ${formSPB.listSPBDetail[index].ophBlockCode}",
                                                style: TextStyle(
                                                  color: ValueService.plasmaValidator(
                                                              formSPB
                                                                  .listSPBDetail[
                                                                      index]
                                                                  .ophEstateCode!) ==
                                                          1
                                                      ? themeNotifier.status ==
                                                                  true ||
                                                              MediaQuery.of(
                                                                          context)
                                                                      .platformBrightness ==
                                                                  Brightness
                                                                      .dark
                                                          ? Colors.white
                                                          : Colors.black
                                                      : Colors.orangeAccent,
                                                ),
                                              ),
                                              Text(
                                                "TPH: ${formSPB.listSPBDetail[index].ophTphCode}",
                                                style: TextStyle(
                                                  color: ValueService.plasmaValidator(
                                                              formSPB
                                                                  .listSPBDetail[
                                                                      index]
                                                                  .ophEstateCode!) ==
                                                          1
                                                      ? themeNotifier.status ==
                                                                  true ||
                                                              MediaQuery.of(
                                                                          context)
                                                                      .platformBrightness ==
                                                                  Brightness
                                                                      .dark
                                                          ? Colors.white
                                                          : Colors.black
                                                      : Colors.orangeAccent,
                                                ),
                                              ),
                                              Text(
                                                "Kartu: ${formSPB.listSPBDetail[index].ophCardId}",
                                                style: TextStyle(
                                                  color: ValueService.plasmaValidator(
                                                              formSPB
                                                                  .listSPBDetail[
                                                                      index]
                                                                  .ophEstateCode!) ==
                                                          1
                                                      ? themeNotifier.status ==
                                                                  true ||
                                                              MediaQuery.of(
                                                                          context)
                                                                      .platformBrightness ==
                                                                  Brightness
                                                                      .dark
                                                          ? Colors.white
                                                          : Colors.black
                                                      : Colors.orangeAccent,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                      ),
              ]),
        ),
      );
    });
  }
}
