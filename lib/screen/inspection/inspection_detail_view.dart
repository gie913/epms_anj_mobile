import 'dart:io';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/inspection_service.dart';
import 'package:epms/common_manager/navigator_service.dart';
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
  NavigatorService _navigationService = locator<NavigatorService>();
  DialogService _dialogService = locator<DialogService>();
  final descriptionController = TextEditingController();

  bool isPreviewPhoto = false;

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

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: Style.mediaQueryText(context),
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop == false) {
            if (isPreviewPhoto) {
              setState(() {
                isPreviewPhoto = false;
              });
              _dialogService.popDialog();
            } else {
              _navigationService.pop();
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(title: Text("Inspection Detail")),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.data.code),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Lokasi Buat :'),
                      SizedBox(width: 12),
                      Expanded(
                          child: Text(
                              '${widget.data.gpsLng},${widget.data.gpsLat}',
                              textAlign: TextAlign.end))
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Tanggal :'),
                      SizedBox(width: 12),
                      Expanded(
                          child: Text(widget.data.trTime,
                              textAlign: TextAlign.end))
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Kategori :'),
                      SizedBox(width: 12),
                      Expanded(
                          child: Text(widget.data.mTeamName,
                              textAlign: TextAlign.end))
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Company :'),
                      SizedBox(width: 12),
                      Expanded(
                          child: Text(widget.data.mCompanyAlias,
                              textAlign: TextAlign.end))
                    ],
                  ),
                  if (widget.data.mDivisionEstateCode.isNotEmpty ||
                      widget.data.mDivisionName.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          Text('Divisi :'),
                          SizedBox(width: 12),
                          Expanded(
                              child: Text(
                                  'Estate ${widget.data.mDivisionEstateCode} | ${widget.data.mDivisionName}',
                                  textAlign: TextAlign.end))
                        ],
                      ),
                    ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text('User Assign :'),
                      SizedBox(width: 12),
                      Expanded(
                          child: Text(widget.data.assignee,
                              textAlign: TextAlign.end))
                    ],
                  ),
                  SizedBox(height: 12),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Foto Inspection :'),
                      SizedBox(height: 6),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 4,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.data.attachments.length,
                          itemBuilder: (context, index) {
                            final image = widget.data.attachments[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isPreviewPhoto = true;
                                  });
                                  _dialogService.showDialogPreviewPhoto(
                                    imagePath: image,
                                    onTapClose: () {
                                      setState(() {
                                        isPreviewPhoto = false;
                                      });
                                      _dialogService.popDialog();
                                    },
                                  );
                                },
                                child: (image.toString().contains('http'))
                                    ? FutureBuilder(
                                        future: InspectionService
                                            .isInternetConnectionExist(),
                                        builder: (context, snapshot) {
                                          if (snapshot.data == true) {
                                            return Image.network(
                                              image,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              fit: BoxFit.cover,
                                            );
                                          } else {
                                            return Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              color: Colors.orange,
                                            );
                                          }
                                        },
                                      )
                                    : Image.file(
                                        File(image),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        fit: BoxFit.cover,
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
                  Text('Riwayat Tindakan :'),
                  if (widget.data.responses.isNotEmpty)
                    ...widget.data.responses
                        .map(
                          (item) => CardHistoryInspection(
                            data: item,
                            onPreviewPhoto: (value) {
                              setState(() {
                                isPreviewPhoto = true;
                              });
                              _dialogService.showDialogPreviewPhoto(
                                imagePath: value,
                                onTapClose: () {
                                  setState(() {
                                    isPreviewPhoto = false;
                                  });
                                  _dialogService.popDialog();
                                },
                              );
                            },
                          ),
                        )
                        .toList()
                  else
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Center(
                          child: const Text('Belum Ada Riwayat Tindakan')),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
