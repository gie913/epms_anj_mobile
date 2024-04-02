import 'dart:convert';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/database/helper/convert_helper.dart';
import 'package:epms/database/service/database_attachment_inspection.dart';
import 'package:epms/database/service/database_response_inspection.dart';
import 'package:epms/model/attachment_inspection_model.dart';
import 'package:epms/model/response_inspection_model.dart';
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

  List<ResponseInspectionModel> listResponseInspection = [];
  Map<String, List<AttachmentInspectionModel>> listResponseAttachment = {};
  List<AttachmentInspectionModel> listInspectionAttachment = [];
  // Map<String, List<AttachmentInspectionModel>> listResponseAttachment =
  //     <String, List<AttachmentInspectionModel>>{};

  bool isLoading = false;

  @override
  void initState() {
    initData();
    descriptionController.text = widget.data.description;
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> initData() async {
    isLoading = true;

    // for (final attachment in widget.data.attachments) {
    //   final indexAttachment = widget.data.attachments.indexOf(attachment);
    //   final code = '${widget.data.code}$indexAttachment';

    //   final inspectionAttachment =
    //       await DatabaseAttachmentInspection.selectData(code);
    //   listInspectionAttachment.add(inspectionAttachment);
    // }

    // for (final response in widget.data.responses) {
    //   final listResponseAttachmentTemp = <AttachmentInspectionModel>[];

    //   for (final attachment in response.attachments) {
    //     final indexAttachment = response.attachments.indexOf(attachment);
    //     final code = '${response.code}$indexAttachment';

    //     final inspectionAttachment =
    //         await DatabaseAttachmentInspection.selectData(code);
    //     listResponseAttachmentTemp.add(inspectionAttachment);
    //   }

    //   listResponseAttachment[response.code] = listResponseAttachmentTemp;
    // }

    await getInspectionAttachment();

    await getResponseInspection();

    await Future.delayed(const Duration(milliseconds: 300));

    isLoading = false;

    setState(() {});
  }

  Future<void> getInspectionAttachment() async {
    final listInspectionAttachmentData =
        await DatabaseAttachmentInspection.selectDataByCode(widget.data.code);
    listInspectionAttachment = listInspectionAttachmentData;
    setState(() {});
  }

  Future<void> getResponseInspection() async {
    final listResponseInspectionData =
        await DatabaseResponseInspection.selectDataByInspectionId(
      widget.data.id,
    );

    listResponseInspection = listResponseInspectionData;

    await Future.forEach(listResponseInspectionData, (response) async {
      final listResponseAttachmentData =
          await DatabaseAttachmentInspection.selectDataByCode(response.code);
      listResponseAttachment[response.code] = listResponseAttachmentData;
    });

    setState(() {});
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
          body: isLoading
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.data.code),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Text('Dibuat Oleh :'),
                            SizedBox(width: 12),
                            Expanded(
                                child: Text(widget.data.submittedByName,
                                    textAlign: TextAlign.end))
                          ],
                        ),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Estate :'),
                                    SizedBox(width: 12),
                                    Expanded(
                                        child: Text(
                                            'Estate ${widget.data.mDivisionEstateCode}',
                                            textAlign: TextAlign.end))
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Text('Divisi :'),
                                    SizedBox(width: 12),
                                    Expanded(
                                        child: Text(
                                            '${widget.data.mDivisionName}',
                                            textAlign: TextAlign.end))
                                  ],
                                ),
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
                                itemCount: listInspectionAttachment.length,
                                itemBuilder: (context, index) {
                                  final image = base64Decode(
                                    listInspectionAttachment[index].image,
                                  );
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isPreviewPhoto = true;
                                        });
                                        _dialogService
                                            .showDialogPreviewPhotoOffline(
                                          image: image,
                                          onTapClose: () {
                                            setState(() {
                                              isPreviewPhoto = false;
                                            });
                                            _dialogService.popDialog();
                                          },
                                        );
                                      },
                                      child: Image.memory(
                                        image,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // SizedBox(
                            //   height: MediaQuery.of(context).size.width / 4,
                            //   child: ListView.builder(
                            //     scrollDirection: Axis.horizontal,
                            //     itemCount: widget.data.attachments.length,
                            //     itemBuilder: (context, index) {
                            //       final image = widget.data.attachments[index];
                            //       return Padding(
                            //         padding: const EdgeInsets.only(right: 8),
                            //         child: InkWell(
                            //           onTap: () {
                            //             setState(() {
                            //               isPreviewPhoto = true;
                            //             });
                            //             _dialogService.showDialogPreviewPhoto(
                            //               imagePath: image,
                            //               onTapClose: () {
                            //                 setState(() {
                            //                   isPreviewPhoto = false;
                            //                 });
                            //                 _dialogService.popDialog();
                            //               },
                            //             );
                            //           },
                            //           child: (image.toString().contains('http'))
                            //               ? FutureBuilder(
                            //                   future: InspectionService
                            //                       .isInternetConnectionExist(),
                            //                   builder: (context, snapshot) {
                            //                     if (snapshot.data == true) {
                            //                       return Image.network(
                            //                         image,
                            //                         width: MediaQuery.of(context)
                            //                                 .size
                            //                                 .width /
                            //                             4,
                            //                         height: MediaQuery.of(context)
                            //                                 .size
                            //                                 .width /
                            //                             4,
                            //                         fit: BoxFit.cover,
                            //                       );
                            //                     } else {
                            //                       return Container(
                            //                         width: MediaQuery.of(context)
                            //                                 .size
                            //                                 .width /
                            //                             4,
                            //                         height: MediaQuery.of(context)
                            //                                 .size
                            //                                 .width /
                            //                             4,
                            //                         color: Colors.orange,
                            //                       );
                            //                     }
                            //                   },
                            //                 )
                            //               : Image.file(
                            //                   File(image),
                            //                   width:
                            //                       MediaQuery.of(context).size.width /
                            //                           4,
                            //                   height:
                            //                       MediaQuery.of(context).size.width /
                            //                           4,
                            //                   fit: BoxFit.cover,
                            //                 ),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),
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
                        if (listResponseInspection.isNotEmpty)
                          ...listResponseInspection.map((item) {
                            final responseAttachment =
                                listResponseAttachment[item.code];

                            return CardHistoryInspection(
                              data: item,
                              listResponseAttachment: responseAttachment ?? [],
                              onPreviewPhoto: (value) {
                                setState(() {
                                  isPreviewPhoto = true;
                                });
                                _dialogService.showDialogPreviewPhotoOffline(
                                  image: value,
                                  onTapClose: () {
                                    setState(() {
                                      isPreviewPhoto = false;
                                    });
                                    _dialogService.popDialog();
                                  },
                                );
                              },
                            );
                          }).toList()
                        else
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Center(
                                child:
                                    const Text('Belum Ada Riwayat Tindakan')),
                          ),
                        // if (widget.data.responses.isNotEmpty)
                        //   ...widget.data.responses.map((item) {
                        //     final responseAttachment =
                        //         listResponseAttachment[item.code];
                        //     return CardHistoryInspection(
                        //       data: item,
                        //       listResponseAttachment: responseAttachment ?? [],
                        //       onPreviewPhoto: (value) {
                        //         setState(() {
                        //           isPreviewPhoto = true;
                        //         });
                        //         _dialogService.showDialogPreviewPhotoOffline(
                        //           image: value,
                        //           onTapClose: () {
                        //             setState(() {
                        //               isPreviewPhoto = false;
                        //             });
                        //             _dialogService.popDialog();
                        //           },
                        //         );
                        //       },
                        //     );
                        //   }).toList()
                        // else
                        //   Padding(
                        //     padding: const EdgeInsets.only(top: 16),
                        //     child: Center(
                        //         child:
                        //             const Text('Belum Ada Riwayat Tindakan')),
                        //   ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
