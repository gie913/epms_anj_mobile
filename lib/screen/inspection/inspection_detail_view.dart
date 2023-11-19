import 'dart:io';

import 'package:epms/base/ui/style.dart';
import 'package:epms/database/helper/convert_helper.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/screen/inspection/components/card_history_inspection.dart';
import 'package:epms/screen/inspection/components/input_primary.dart';
import 'package:flutter/material.dart';

class InspectionDetailView extends StatefulWidget {
  const InspectionDetailView({super.key, required this.data});

  final TicketInspectionModel data;

  @override
  State<InspectionDetailView> createState() => _InspectionDetailViewState();
}

class _InspectionDetailViewState extends State<InspectionDetailView> {
  final descriptionController = TextEditingController();

  @override
  void initState() {
    descriptionController.text = widget.data.description;
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void showFoto(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: false,
      builder: (context) {
        return MediaQuery(
          data: Style.mediaQueryText(context),
          child: AlertDialog(
            insetPadding: EdgeInsets.all(16),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: Image.file(
                File(imagePath),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.5,
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: Style.mediaQueryText(context),
      child: Scaffold(
        appBar: AppBar(title: Text("Inspection Detail")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.data.id),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text('Lokasi Buat :'),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text(
                            '${widget.data.longitude},${widget.data.latitude}',
                            textAlign: TextAlign.end))
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text('Tanggal :'),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text(widget.data.date, textAlign: TextAlign.end))
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text('Kategori :'),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text(widget.data.category,
                            textAlign: TextAlign.end))
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text('Company :'),
                    SizedBox(width: 12),
                    Expanded(
                        child:
                            Text(widget.data.company, textAlign: TextAlign.end))
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text('Divisi :'),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text(widget.data.division,
                            textAlign: TextAlign.end))
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text('User Assign :'),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text(widget.data.userAssign,
                            textAlign: TextAlign.end))
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
                        itemCount: widget.data.images.length,
                        itemBuilder: (context, index) {
                          final image = widget.data.images[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: InkWell(
                              onTap: () {
                                showFoto(context, image);
                              },
                              child: Image.file(
                                File(image),
                                width: MediaQuery.of(context).size.width / 4,
                                height: MediaQuery.of(context).size.width / 4,
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
                Text('Deskripsi :'),
                SizedBox(height: 6),
                InputPrimary(
                  controller: descriptionController,
                  maxLines: 10,
                  validator: (value) => null,
                  readOnly: true,
                ),
                Row(
                  children: [
                    Text('Status :'),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text(
                            ConvertHelper.titleCase(widget.data.status
                                .replaceAll(RegExp(r'_'), ' ')),
                            textAlign: TextAlign.end))
                  ],
                ),
                SizedBox(height: 12),
                Text('Riwayat Tindakan :'),
                if (widget.data.history.isNotEmpty)
                  ...widget.data.history
                      .map((item) => CardHistoryInspection(data: item))
                      .toList()
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child:
                        Center(child: const Text('Belum Ada Riwayat Tindakan')),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
