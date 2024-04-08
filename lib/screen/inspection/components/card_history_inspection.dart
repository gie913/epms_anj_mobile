import 'dart:convert';

import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/database/helper/convert_helper.dart';
import 'package:epms/model/attachment_inspection_model.dart';
import 'package:epms/model/response_inspection_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CardHistoryInspection extends StatefulWidget {
  const CardHistoryInspection({
    super.key,
    this.data = const ResponseInspectionModel(),
    this.listResponseAttachment = const [],
    required this.onPreviewPhoto,
  });

  final ResponseInspectionModel data;
  final List<AttachmentInspectionModel> listResponseAttachment;
  final ValueSetter<Uint8List> onPreviewPhoto;

  @override
  State<CardHistoryInspection> createState() => _CardHistoryInspectionState();
}

class _CardHistoryInspectionState extends State<CardHistoryInspection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Palette.primaryColorProd,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   widget.data.code,
            //   style: Style.whiteBold12
            //       .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
            // ),
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
            Divider(color: Colors.white24, height: 1),
            SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Status :',
                  style: Style.whiteBold12.copyWith(
                      color: Colors.white, fontWeight: FontWeight.normal),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    ConvertHelper.titleCase(
                      widget.data.status
                          .replaceAll(RegExp(r'_'), ' ')
                          .replaceAll(RegExp(r'-'), ' '),
                    ),
                    style: Style.whiteBold12.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                )
              ],
            ),
            Divider(color: Colors.white24, height: 1),
            SizedBox(height: 4),
            Text(
              'Dibuat Oleh :',
              style: Style.whiteBold12
                  .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
            ),
            Text(
              widget.data.submittedByName,
              style: Style.whiteBold12
                  .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
            ),
            if (widget.data.reassignedToName.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.white24, height: 1),
                  SizedBox(height: 4),
                  Text(
                    'Reassign To :',
                    style: Style.whiteBold12.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                  Text(
                    widget.data.reassignedToName,
                    style: Style.whiteBold12.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            if (widget.data.consultedWithName.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.white24, height: 1),
                  SizedBox(height: 4),
                  Text(
                    'Consulted With :',
                    style: Style.whiteBold12.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                  Text(
                    widget.data.consultedWithName,
                    style: Style.whiteBold12.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            if (widget.data.description.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.white24, height: 1),
                  SizedBox(height: 4),
                  Text(
                    'Deskripsi :',
                    style: Style.whiteBold12.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                  Text(
                    widget.data.description,
                    style: Style.whiteBold12.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            if (widget.listResponseAttachment.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.white24, height: 1),
                  SizedBox(height: 4),
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
                      itemCount: widget.listResponseAttachment.length,
                      itemBuilder: (context, index) {
                        final image = base64Decode(
                          widget.listResponseAttachment[index].image,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () {
                              widget.onPreviewPhoto(image);
                            },
                            child: Image.memory(
                              image,
                              width: MediaQuery.of(context).size.width / 6,
                              height: MediaQuery.of(context).size.width / 6,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            // if (widget.data.attachments.isNotEmpty)
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Divider(color: Colors.white24, height: 1),
            //       SizedBox(height: 4),
            //       Text(
            //         'Attachment :',
            //         style: Style.whiteBold12.copyWith(
            //             color: Colors.white, fontWeight: FontWeight.normal),
            //       ),
            //       SizedBox(height: 4),
            //       SizedBox(
            //         height: MediaQuery.of(context).size.width / 6,
            //         child: ListView.builder(
            //           scrollDirection: Axis.horizontal,
            //           itemCount: widget.data.attachments.length,
            //           itemBuilder: (context, index) {
            //             final image = widget.data.attachments[index];
            //             return Padding(
            //               padding: const EdgeInsets.only(right: 8),
            //               child: InkWell(
            //                 onTap: () {
            //                   widget.onPreviewPhoto(image);
            //                 },
            //                 child: (image.toString().contains('http'))
            //                     ? FutureBuilder(
            //                         future: InspectionService
            //                             .isInternetConnectionExist(),
            //                         builder: (context, snapshot) {
            //                           if (snapshot.data == true) {
            //                             return Image.network(
            //                               image,
            //                               width: MediaQuery.of(context)
            //                                       .size
            //                                       .width /
            //                                   6,
            //                               height: MediaQuery.of(context)
            //                                       .size
            //                                       .width /
            //                                   6,
            //                               fit: BoxFit.cover,
            //                             );
            //                           } else {
            //                             return Container(
            //                               width: MediaQuery.of(context)
            //                                       .size
            //                                       .width /
            //                                   6,
            //                               height: MediaQuery.of(context)
            //                                       .size
            //                                       .width /
            //                                   6,
            //                               color: Colors.orange,
            //                             );
            //                           }
            //                         },
            //                       )
            //                     : (image.toString().isNotEmpty)
            //                         ? Image.file(
            //                             File(image),
            //                             width:
            //                                 MediaQuery.of(context).size.width /
            //                                     6,
            //                             height:
            //                                 MediaQuery.of(context).size.width /
            //                                     6,
            //                             fit: BoxFit.cover,
            //                           )
            //                         : const SizedBox(),
            //               ),
            //             );
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
          ],
        ),
      ),
    );
  }
}
