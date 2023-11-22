import 'dart:io';

import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/database/helper/convert_helper.dart';
import 'package:epms/model/history_inspection_model.dart';
import 'package:flutter/material.dart';

class CardHistoryInspection extends StatefulWidget {
  const CardHistoryInspection({
    super.key,
    this.data = const HistoryInspectionModel(),
  });

  final HistoryInspectionModel data;

  @override
  State<CardHistoryInspection> createState() => _CardHistoryInspectionState();
}

class _CardHistoryInspectionState extends State<CardHistoryInspection> {
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
              child: imagePath.contains('http')
                  ? Image.network(
                      imagePath,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.5,
                      fit: BoxFit.fill,
                    )
                  : Image.file(
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
    return Card(
      color: Palette.primaryColorProd,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.data.code,
                  style: Style.whiteBold12.copyWith(
                      color: Colors.white, fontWeight: FontWeight.normal),
                ),
                Text(
                  ConvertHelper.titleCase(
                      widget.data.status.replaceAll(RegExp(r'_'), ' ')),
                  style: Style.whiteBold12.copyWith(
                      color: Colors.white, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Tanggal :',
                  style: Style.whiteBold12.copyWith(
                      color: Colors.white, fontWeight: FontWeight.normal),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.data.trTime,
                    style: Style.whiteBold12.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  'Submitted By :',
                  style: Style.whiteBold12.copyWith(
                      color: Colors.white, fontWeight: FontWeight.normal),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.data.submittedByName,
                    style: Style.whiteBold12.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                )
              ],
            ),
            if (widget.data.reassignedToName.isNotEmpty)
              Row(
                children: [
                  Text(
                    'Re-Assign To :',
                    style: Style.whiteBold12.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.data.reassignedToName,
                      style: Style.whiteBold12.copyWith(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                  )
                ],
              ),
            if (widget.data.consultedWithName.isNotEmpty)
              Row(
                children: [
                  Text(
                    'Consulted With :',
                    style: Style.whiteBold12.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.data.reassignedToName,
                      style: Style.whiteBold12.copyWith(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                  )
                ],
              ),
            Text(
              'Deskripsi :',
              style: Style.whiteBold12
                  .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
            ),
            Text(
              widget.data.description,
              style: Style.whiteBold12
                  .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
            ),
            if (widget.data.attachments.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attachment :',
                    style: Style.whiteBold12.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 6,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.data.attachments.length,
                      itemBuilder: (context, index) {
                        final image = widget.data.attachments[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () {
                              showFoto(context, image);
                            },
                            child: (image.toString().contains('http'))
                                ? Image.network(
                                    image,
                                    width:
                                        MediaQuery.of(context).size.width / 6,
                                    height:
                                        MediaQuery.of(context).size.width / 6,
                                    fit: BoxFit.fill,
                                  )
                                : Image.file(
                                    File(image),
                                    width:
                                        MediaQuery.of(context).size.width / 6,
                                    height:
                                        MediaQuery.of(context).size.width / 6,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
