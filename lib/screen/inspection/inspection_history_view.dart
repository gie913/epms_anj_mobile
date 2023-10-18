import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/screen/inspection/components/input_primary.dart';
import 'package:flutter/material.dart';

class InspectionHistoryView extends StatefulWidget {
  const InspectionHistoryView({super.key});

  @override
  State<InspectionHistoryView> createState() => _InspectionHistoryViewState();
}

class _InspectionHistoryViewState extends State<InspectionHistoryView> {
  final inspectionController =
      TextEditingController(text: 'Test Pengaduan Inspection');
  final actionController =
      TextEditingController(text: 'Tindakan Inspection Test');

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: Style.mediaQueryText(context),
      child: Scaffold(
        appBar: AppBar(title: Text("Inspection History")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Kategori :'),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text('Kategori 1', textAlign: TextAlign.end))
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text('Company :'),
                    SizedBox(width: 12),
                    Expanded(child: Text('Company 1', textAlign: TextAlign.end))
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text('Divisi :'),
                    SizedBox(width: 12),
                    Expanded(child: Text('Divisi 1', textAlign: TextAlign.end))
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text('User Assign :'),
                    SizedBox(width: 12),
                    Expanded(child: Text('User 1', textAlign: TextAlign.end))
                  ],
                ),
                SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Foto Inspection :'),
                    SizedBox(height: 6),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 4,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width / 4,
                            height: MediaQuery.of(context).size.width / 4,
                            color: Colors.amber,
                            margin: EdgeInsets.only(right: 12),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
                Text('Pengaduan :'),
                SizedBox(height: 6),
                InputPrimary(
                  controller: inspectionController,
                  maxLines: 5,
                  validator: (value) => null,
                  readOnly: true,
                ),
                Text('Tindakan :'),
                SizedBox(height: 6),
                InputPrimary(
                  controller: actionController,
                  maxLines: 5,
                  validator: (value) => null,
                  readOnly: true,
                ),
                Row(
                  children: [
                    Text('Status :'),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text('On Progress', textAlign: TextAlign.end))
                  ],
                ),
                SizedBox(height: 12),
                Text('Riwayat Re-Assign :'),
                Card(
                  color: Palette.primaryColorProd,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Kategori : ',
                                    style: Style.whiteBold12.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    'Kategori 1',
                                    style: Style.whiteBold12.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Company : ',
                                    style: Style.whiteBold12.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    'Company 1',
                                    style: Style.whiteBold12.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Divisi : ',
                                    style: Style.whiteBold12.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    'Divisi 1',
                                    style: Style.whiteBold12.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'User : ',
                                    style: Style.whiteBold12.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    'User 2',
                                    style: Style.whiteBold12.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'On Progress',
                          style: Style.whiteBold12.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
