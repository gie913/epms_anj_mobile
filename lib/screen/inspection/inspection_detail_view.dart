import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/screen/inspection/components/input_primary.dart';
import 'package:flutter/material.dart';

class InspectionDetailView extends StatefulWidget {
  const InspectionDetailView({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<InspectionDetailView> createState() => _InspectionDetailViewState();
}

class _InspectionDetailViewState extends State<InspectionDetailView> {
  final inspectionController = TextEditingController();

  @override
  void initState() {
    inspectionController.text = widget.data['report'];
    super.initState();
  }

  @override
  void dispose() {
    inspectionController.dispose();
    super.dispose();
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
                Text(widget.data['id']),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text('Lokasi Buat :'),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text(
                            '${widget.data['longitude']},${widget.data['latitude']}',
                            textAlign: TextAlign.end))
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text('Tanggal :'),
                    SizedBox(width: 12),
                    Expanded(
                        child:
                            Text(widget.data['date'], textAlign: TextAlign.end))
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text('Kategori :'),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text(widget.data['category'],
                            textAlign: TextAlign.end))
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text('Company :'),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text(widget.data['company'],
                            textAlign: TextAlign.end))
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text('Divisi :'),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text(widget.data['divisi'],
                            textAlign: TextAlign.end))
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text('User Assign :'),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text(widget.data['user_assign'],
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
                Text('Deskripsi :'),
                SizedBox(height: 6),
                InputPrimary(
                  controller: inspectionController,
                  maxLines: 10,
                  validator: (value) => null,
                  readOnly: true,
                ),
                Row(
                  children: [
                    Text('Status :'),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text(widget.data['status'],
                            textAlign: TextAlign.end))
                  ],
                ),
                SizedBox(height: 12),
                if ((widget.data['history'] as List).isNotEmpty)
                  Text('Riwayat Tindakan :'),
                ...(widget.data['history'] as List).map((item) {
                  return Card(
                    color: Palette.primaryColorProd,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['user'],
                                  style: Style.whiteBold14.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Tanggal :',
                                      style: Style.whiteBold12.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item['date'],
                                        style: Style.whiteBold12.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Kategori :',
                                      style: Style.whiteBold12.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item['category'],
                                        style: Style.whiteBold12.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Company :',
                                      style: Style.whiteBold12.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item['company'],
                                        style: Style.whiteBold12.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Divisi :',
                                      style: Style.whiteBold12.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item['divisi'],
                                        style: Style.whiteBold12.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Tindakan :',
                                      style: Style.whiteBold12.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item['response'].toString().isEmpty
                                            ? '-'
                                            : item['response'],
                                        style: Style.whiteBold12.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    )
                                  ],
                                ),
                                if (item['user_re_assign']
                                    .toString()
                                    .isNotEmpty)
                                  Row(
                                    children: [
                                      Text(
                                        'User Re-Assign :',
                                        style: Style.whiteBold12.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          item['user_re_assign'],
                                          style: Style.whiteBold12.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      )
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            item['status'],
                            style: Style.whiteBold12.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
