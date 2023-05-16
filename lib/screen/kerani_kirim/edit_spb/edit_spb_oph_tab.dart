import 'package:epms/base/ui/style.dart';
import 'package:epms/screen/kerani_kirim/edit_spb/edit_spb_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditSPBOPHTab extends StatefulWidget {
  const EditSPBOPHTab({Key? key}) : super(key: key);

  @override
  State<EditSPBOPHTab> createState() => _EditSPBOPHTabState();
}

class _EditSPBOPHTabState extends State<EditSPBOPHTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EditSPBNotifier>(
      builder: (context, editSPB, child) {
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
                    child: Text("Daftar OPH (${editSPB.listSPBDetail.length})"),
                  ),
                  SizedBox(height: 6),
                  editSPB.listSPBDetail.isEmpty
                      ? Text(
                          "Tidak Ada OPH yang dibuat",
                          style: Style.textBold14,
                        )
                      : Flexible(
                          child: ListView.builder(
                              itemCount: editSPB.listSPBDetail.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${editSPB.listSPBDetail[index].ophId}",
                                                    style: Style.textBold18,
                                                  ),
                                                  SizedBox(height: 16),
                                                  Text(
                                                      "Janjang terkirim : ${editSPB.listSPBDetail[index].ophBunchesDelivered}"),
                                                  Text(
                                                      "Brondolan (kg) : ${editSPB.listSPBDetail[index].ophLooseFruitDelivered}")
                                                ]),
                                          ]),
                                      Divider(),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "Blok: ${editSPB.listSPBDetail[index].ophBlockCode}"),
                                            Text(
                                                "TPH: ${editSPB.listSPBDetail[index].ophTphCode}"),
                                            Text(
                                                "Kartu: ${editSPB.listSPBDetail[index].ophCardId}")
                                          ])
                                    ]),
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
