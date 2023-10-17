import 'package:epms/base/ui/style.dart';
import 'package:epms/screen/inspection/components/input_primary.dart';
import 'package:flutter/material.dart';

class InspectionHistoryView extends StatefulWidget {
  const InspectionHistoryView({super.key});

  @override
  State<InspectionHistoryView> createState() => _InspectionHistoryViewState();
}

class _InspectionHistoryViewState extends State<InspectionHistoryView> {
  final inspectionController = TextEditingController(text: 'Test Inspection');
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
                Text('Deskripsi Inspection :'),
                SizedBox(height: 6),
                InputPrimary(
                  controller: inspectionController,
                  maxLines: 5,
                  validator: (value) => null,
                  readOnly: true,
                ),
                Text('Tindakan Inspection :'),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
