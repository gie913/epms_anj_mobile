import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/base/ui/theme_notifier.dart';
import 'package:epms/common_manager/camera_service.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/inspection_service.dart';
import 'package:epms/common_manager/location_service.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/database/helper/convert_helper.dart';
import 'package:epms/database/service/database_action_inspection.dart';
import 'package:epms/database/service/database_attachment_inspection.dart';
import 'package:epms/database/service/database_subordinate_inspection.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/database/service/database_todo_inspection.dart';
import 'package:epms/database/service/database_user_inspection_config.dart';
import 'package:epms/model/attachment_inspection_model.dart';
import 'package:epms/model/history_inspection_model.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/model/user_inspection_config_model.dart';
import 'package:epms/model/user_inspection_model.dart';
import 'package:epms/screen/inspection/components/card_history_inspection.dart';
import 'package:epms/screen/inspection/components/input_primary.dart';
import 'package:epms/screen/inspection/components/inspection_photo.dart';
import 'package:epms/screen/inspection/inspection_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InspectionApprovalView extends StatefulWidget {
  const InspectionApprovalView({super.key, required this.data});

  final TicketInspectionModel data;

  @override
  State<InspectionApprovalView> createState() => _InspectionApprovalViewState();
}

class _InspectionApprovalViewState extends State<InspectionApprovalView> {
  NavigatorService _navigationService = locator<NavigatorService>();
  DialogService _dialogService = locator<DialogService>();

  String responseId = '';
  UserInspectionConfigModel user = const UserInspectionConfigModel();

  double longitude = 0;
  double latitude = 0;
  String gpsLocation = '';

  UserInspectionModel? selectedUserReassign;
  UserInspectionModel? selectedUserConsultant;

  final descriptionController = TextEditingController();
  final noteController = TextEditingController();

  List<HistoryInspectionModel> listHistoryInspection = [];

  List<String> listActionOption = const [];
  String? selectedAction;

  final listInspectionPhoto = [];

  bool isPreviewPhoto = false;

  bool isShowDialogAttachment = false;

  bool isShowDialogSubmit = false;

  List<AttachmentInspectionModel> listInspectionAttachment =
      <AttachmentInspectionModel>[];
  Map<String, List<AttachmentInspectionModel>> listResponseAttachment =
      <String, List<AttachmentInspectionModel>>{};

  bool isLoading = false;

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> initData() async {
    isLoading = true;
    await initAttachment();
    descriptionController.text = widget.data.description;
    listHistoryInspection = widget.data.responses;
    getResponseId();
    getOptionAction();
    getUser();
    getLocation();
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
    setState(() {});
  }

  Future<void> initAttachment() async {
    for (final attachment in widget.data.attachments) {
      final indexAttachment = widget.data.attachments.indexOf(attachment);
      final code = '${widget.data.code}$indexAttachment';

      final inspectionAttachment =
          await DatabaseAttachmentInspection.selectData(code);
      listInspectionAttachment.add(inspectionAttachment);
    }

    for (final response in widget.data.responses) {
      final listResponseAttachmentTemp = <AttachmentInspectionModel>[];

      for (final attachment in response.attachments) {
        final indexAttachment = response.attachments.indexOf(attachment);
        final code = '${response.code}$indexAttachment';

        final inspectionAttachment =
            await DatabaseAttachmentInspection.selectData(code);
        listResponseAttachmentTemp.add(inspectionAttachment);
      }

      listResponseAttachment[response.code] = listResponseAttachmentTemp;
    }

    setState(() {});
  }

  bool validateForm() {
    if (selectedAction == null) {
      FlushBarManager.showFlushBarWarning(
        context,
        "Form Belum Lengkap",
        "Mohon memilih action terlebih dahulu",
      );
      return false;
    }

    if (selectedAction != null && selectedAction == 'reassign') {
      if (selectedUserReassign == null) {
        FlushBarManager.showFlushBarWarning(
          context,
          "Form Belum Lengkap",
          "Mohon memilih user reassign terlebih dahulu",
        );
        return false;
      }

      if (noteController.text.isEmpty) {
        FlushBarManager.showFlushBarWarning(
          context,
          "Form Belum Lengkap",
          "Mohon mengisi deskripsi tindakan terlebih dahulu",
        );
        return false;
      }

      // if (listInspectionPhoto.isEmpty) {
      //   FlushBarManager.showFlushBarWarning(
      //     context,
      //     "Form Belum Lengkap",
      //     "Mohon melampirkan bukti foto",
      //   );
      //   return false;
      // }
    }

    if (selectedAction != null && selectedAction == 'need_consultation') {
      if (selectedUserConsultant == null) {
        FlushBarManager.showFlushBarWarning(
          context,
          "Form Belum Lengkap",
          "Mohon memilih user consultation terlebih dahulu",
        );
        return false;
      }

      if (noteController.text.isEmpty) {
        FlushBarManager.showFlushBarWarning(
          context,
          "Form Belum Lengkap",
          "Mohon mengisi keterangan terlebih dahulu",
        );
        return false;
      }

      // if (listInspectionPhoto.isEmpty) {
      //   FlushBarManager.showFlushBarWarning(
      //     context,
      //     "Form Belum Lengkap",
      //     "Mohon melampirkan bukti foto",
      //   );
      //   return false;
      // }
    }

    if (selectedAction != null && selectedAction == 'revise') {
      if (noteController.text.isEmpty) {
        FlushBarManager.showFlushBarWarning(
          context,
          "Form Belum Lengkap",
          "Mohon mengisi keterangan terlebih dahulu",
        );
        return false;
      }

      // if (listInspectionPhoto.isEmpty) {
      //   FlushBarManager.showFlushBarWarning(
      //     context,
      //     "Form Belum Lengkap",
      //     "Mohon melampirkan bukti foto",
      //   );
      //   return false;
      // }
    }

    if (selectedAction != null && selectedAction == 'consulted') {
      if (noteController.text.isEmpty) {
        FlushBarManager.showFlushBarWarning(
          context,
          "Form Belum Lengkap",
          "Mohon mengisi keterangan terlebih dahulu",
        );
        return false;
      }

      // if (listInspectionPhoto.isEmpty) {
      //   FlushBarManager.showFlushBarWarning(
      //     context,
      //     "Form Belum Lengkap",
      //     "Mohon melampirkan bukti foto",
      //   );
      //   return false;
      // }
    }

    return true;
  }

  Future<void> getOptionAction() async {
    if (widget.data.status != 'accept-reassign') {
      final data =
          await DatabaseActionInspection.selectDataByStatus(widget.data.status);
      listActionOption =
          List<String>.from(data.options.map((e) => e.toString()));
      log('cek list action options : $listActionOption');
      setState(() {});
    }
  }

  Future<void> getUser() async {
    final data = await DatabaseUserInspectionConfig.selectData();
    user = data;
    log('cek user : $user');
    setState(() {});
  }

  Future<void> getLocation() async {
    var position = await LocationService.getGPSLocation();
    if (position != null) {
      longitude = position.longitude;
      latitude = position.latitude;
      gpsLocation = "${position.longitude}, ${position.latitude}";
    }
    log('cek inspection location : $gpsLocation');
    setState(() {});
  }

  Future<void> createResponse(
    BuildContext context, {
    required TicketInspectionModel toDoInspection,
    required HistoryInspectionModel responseInspection,
  }) async {
    _dialogService.showLoadingDialog(title: "Upload Data");
    await InspectionRepository().createResponseInspection(
      context,
      toDoInspection,
      responseInspection,
      (context, successMessage) async {
        await DatabaseTodoInspection.deleteTodoByCode(toDoInspection);
        await DatabaseAttachmentInspection.deleteInspectionByCode(
            toDoInspection);
        await getDataInspection(context);
      },
      (context, errorMessage) async {
        _dialogService.popDialog();
        FlushBarManager.showFlushBarError(
          context,
          "Gagal Upload",
          errorMessage,
        );
      },
    );
  }

  Future<void> getDataInspection(BuildContext context) async {
    await DatabaseSubordinateInspection.deleteTable();
    await InspectionRepository().getMyInspectionClose(
      context,
      (context, data) async {
        await DatabaseTicketInspection.addAllData(data);
        await DatabaseSubordinateInspection.addAllData(data);
        await DatabaseAttachmentInspection.addAllDataNew(data);

        await InspectionRepository().getMyInspectionNotClose(
          context,
          (context, data) async {
            await DatabaseTicketInspection.addAllData(data);
            await DatabaseSubordinateInspection.addAllData(data);
            await DatabaseAttachmentInspection.addAllDataNew(data);

            await InspectionRepository().getToDoInspection(
              context,
              (context, data) async {
                await DatabaseTodoInspection.addAllData(data);
                await DatabaseAttachmentInspection.addAllDataNew(data);

                await InspectionRepository().getOnGoingInspectionClose(
                  context,
                  (context, data) async {
                    await DatabaseSubordinateInspection.addAllData(data);
                    await DatabaseAttachmentInspection.addAllDataNew(data);

                    await InspectionRepository().getOnGoingInspectionNotClose(
                      context,
                      (context, data) async {
                        await DatabaseSubordinateInspection.addAllData(data);
                        await DatabaseAttachmentInspection.addAllDataNew(data);

                        await InspectionRepository().getToDoInspectionClose(
                          context,
                          (context, data) async {
                            await DatabaseSubordinateInspection.addAllData(
                                data);
                            await DatabaseAttachmentInspection.addAllDataNew(
                                data);

                            await InspectionRepository()
                                .getToDoInspectionNotClose(
                              context,
                              (context, data) async {
                                await DatabaseSubordinateInspection.addAllData(
                                    data);
                                await DatabaseAttachmentInspection
                                    .addAllDataNew(data);
                                _dialogService.popDialog();
                                _navigationService.pop();
                                FlushBarManager.showFlushBarSuccess(
                                  context,
                                  "Berhasil Upload",
                                  'Data Berhasil Di Upload',
                                );
                              },
                              (context, errorMessage) {
                                FlushBarManager.showFlushBarError(
                                    context, "Gagal Upload", errorMessage);
                                _dialogService.popDialog();
                              },
                            );
                          },
                          (context, errorMessage) {
                            FlushBarManager.showFlushBarError(
                                context, "Gagal Upload", errorMessage);
                            _dialogService.popDialog();
                          },
                        );
                      },
                      (context, errorMessage) {
                        FlushBarManager.showFlushBarError(
                            context, "Gagal Upload", errorMessage);
                        _dialogService.popDialog();
                      },
                    );
                  },
                  (context, errorMessage) {
                    FlushBarManager.showFlushBarError(
                        context, "Gagal Upload", errorMessage);
                    _dialogService.popDialog();
                  },
                );
              },
              (context, errorMessage) {
                FlushBarManager.showFlushBarError(
                    context, "Gagal Upload", errorMessage);
                _dialogService.popDialog();
              },
            );
          },
          (context, errorMessage) {
            FlushBarManager.showFlushBarError(
                context, "Gagal Upload", errorMessage);
            _dialogService.popDialog();
          },
        );
      },
      (context, errorMessage) {
        FlushBarManager.showFlushBarError(
            context, "Gagal Upload", errorMessage);
        _dialogService.popDialog();
      },
    );

    // await InspectionRepository().getMyInspection(
    //   context,
    //   (context, data) async {
    //     await DatabaseTicketInspection.addAllData(data);
    //     await DatabaseAttachmentInspection.addAllDataNew(data);
    //     await InspectionRepository().getToDoInspection(
    //       context,
    //       (context, data) async {
    //         await DatabaseTodoInspection.addAllData(data);
    //         await DatabaseAttachmentInspection.addAllDataNew(data);
    //         await InspectionRepository().getMySubordinate(
    //           context,
    //           (context, data) async {
    //             await DatabaseSubordinateInspection.addAllData(data);
    //             await DatabaseAttachmentInspection.addAllDataNew(data);
    //             _dialogService.popDialog();
    //             _navigationService.pop();
    //             FlushBarManager.showFlushBarSuccess(
    //               context,
    //               "Berhasil Upload",
    //               'Data Berhasil Di Upload',
    //             );
    //           },
    //           (context, errorMessage) {
    //             _dialogService.popDialog();
    //             FlushBarManager.showFlushBarError(
    //               context,
    //               "Gagal Upload",
    //               errorMessage,
    //             );
    //           },
    //         );
    //       },
    //       (context, errorMessage) async {
    //         await InspectionRepository().getMySubordinate(
    //           context,
    //           (context, data) async {
    //             await DatabaseSubordinateInspection.addAllData(data);
    //             await DatabaseAttachmentInspection.addAllDataNew(data);
    //             _dialogService.popDialog();
    //             _navigationService.pop();
    //             FlushBarManager.showFlushBarSuccess(
    //               context,
    //               "Berhasil Upload",
    //               'Data Berhasil Di Upload',
    //             );
    //           },
    //           (context, errorMessage) {
    //             _dialogService.popDialog();
    //             FlushBarManager.showFlushBarError(
    //               context,
    //               "Gagal Upload",
    //               errorMessage,
    //             );
    //           },
    //         );
    //       },
    //     );
    //   },
    //   (context, errorMessage) async {
    //     await InspectionRepository().getToDoInspection(
    //       context,
    //       (context, data) async {
    //         await DatabaseTodoInspection.addAllData(data);
    //         await DatabaseAttachmentInspection.addAllDataNew(data);
    //         await InspectionRepository().getMySubordinate(
    //           context,
    //           (context, data) async {
    //             await DatabaseSubordinateInspection.addAllData(data);
    //             await DatabaseAttachmentInspection.addAllDataNew(data);
    //             _dialogService.popDialog();
    //             _navigationService.pop();
    //             FlushBarManager.showFlushBarSuccess(
    //               context,
    //               "Berhasil Upload",
    //               'Data Berhasil Di Upload',
    //             );
    //           },
    //           (context, errorMessage) {
    //             _dialogService.popDialog();
    //             FlushBarManager.showFlushBarError(
    //               context,
    //               "Gagal Upload",
    //               errorMessage,
    //             );
    //           },
    //         );
    //       },
    //       (context, errorMessage) async {
    //         await InspectionRepository().getMySubordinate(
    //           context,
    //           (context, data) async {
    //             await DatabaseSubordinateInspection.addAllData(data);
    //             await DatabaseAttachmentInspection.addAllDataNew(data);
    //             _dialogService.popDialog();
    //             _navigationService.pop();
    //             FlushBarManager.showFlushBarSuccess(
    //               context,
    //               "Berhasil Upload",
    //               'Data Berhasil Di Upload',
    //             );
    //           },
    //           (context, errorMessage) {
    //             _dialogService.popDialog();
    //             FlushBarManager.showFlushBarError(
    //               context,
    //               "Gagal Upload",
    //               errorMessage,
    //             );
    //           },
    //         );
    //       },
    //     );
    //   },
    // );
  }

  void showSubmitOption() {
    FocusManager.instance.primaryFocus?.unfocus();
    _dialogService.showDialogSubmitInspection(
      title: 'Submit Inspection',
      desc: 'Apakah data yang Anda masukkan sudah benar ?',
      labelConfirm: 'YA',
      labelCancel: 'TIDAK',
      onTapConfirm: () async {
        setState(() {
          isShowDialogSubmit = false;
        });
        _dialogService.popDialog();
        await submit();
      },
      onTapCancel: () {
        setState(() {
          isShowDialogSubmit = false;
        });
        _dialogService.popDialog();
      },
    );
  }

  Future<void> submit() async {
    if (validateForm()) {
      final dataHistory = HistoryInspectionModel(
        id: widget.data.id,
        code: responseId,
        trTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        submittedAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        submittedBy: user.id,
        submittedByName: user.name,
        description: noteController.text.isNotEmpty ? noteController.text : '',
        reassignedTo:
            selectedUserReassign != null ? selectedUserReassign!.id : '',
        reassignedToName:
            selectedUserReassign != null ? selectedUserReassign!.name : '',
        consultedWith:
            selectedUserConsultant != null ? selectedUserConsultant!.id : '',
        consultedWithName:
            selectedUserConsultant != null ? selectedUserConsultant!.name : '',
        gpsLat: latitude,
        gpsLng: longitude,
        status: selectedAction ?? '',
        attachments: listInspectionPhoto,
      );
      log('cek response new : $dataHistory');
      listHistoryInspection.add(dataHistory);
      log('cek list response : $listHistoryInspection');
      final dataInspection = TicketInspectionModel(
        id: widget.data.id,
        code: widget.data.code,
        trTime: widget.data.trTime,
        mCompanyId: widget.data.mCompanyId,
        mCompanyName: widget.data.mCompanyName,
        mCompanyAlias: widget.data.mCompanyAlias,
        mTeamId: widget.data.mTeamId,
        mTeamName: widget.data.mTeamName,
        mDivisionId: widget.data.mDivisionId,
        mDivisionName: widget.data.mDivisionName,
        mDivisionEstateCode: widget.data.mDivisionEstateCode,
        gpsLng: widget.data.gpsLng,
        gpsLat: widget.data.gpsLat,
        submittedAt: widget.data.submittedAt,
        submittedBy: widget.data.submittedBy,
        submittedByName: widget.data.submittedByName,
        assignee: widget.data.assignee,
        assigneeId: widget.data.assigneeId,
        status: selectedAction ?? '',
        description: widget.data.description,
        closedAt: widget.data.closedAt,
        closedBy: widget.data.closedBy,
        closedByName: widget.data.closedByName,
        isSynchronize: 0,
        isClosed: widget.data.isClosed,
        isNewResponse: widget.data.isNewResponse,
        usingGps: widget.data.usingGps,
        attachments: widget.data.attachments,
        responses: listHistoryInspection,
      );

      await DatabaseAttachmentInspection.insertResponse(dataHistory);
      final isInternetExist =
          await InspectionService.isInternetConnectionExist();
      if (isInternetExist) {
        await createResponse(
          context,
          toDoInspection: dataInspection,
          responseInspection: dataInspection.responses.last,
        );
      } else {
        await DatabaseTodoInspection.updateData(dataInspection);
        _navigationService.pop();
      }
    }
  }

  void getResponseId() {
    final dateNow = DateTime.now();
    final dateNowConvert = ValueService.generateIDFromDateTime(dateNow);
    math.Random random = new math.Random();
    var randomNumber = random.nextInt(100);
    responseId =
        'R${widget.data.responses.length + 1}$dateNowConvert$randomNumber';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        return MediaQuery(
          data: Style.mediaQueryText(context),
          child: PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
              if (didPop == false) {
                if (isPreviewPhoto ||
                    isShowDialogAttachment ||
                    isShowDialogSubmit) {
                  setState(() {
                    isPreviewPhoto = false;
                    isShowDialogAttachment = false;
                    isShowDialogSubmit = false;
                  });
                  _dialogService.popDialog();
                } else {
                  _navigationService.pop();
                }
              }
            },
            child: Scaffold(
              appBar: AppBar(title: Text("Approval")),
              body: isLoading
                  ? const SizedBox()
                  : Padding(
                      padding: EdgeInsets.all(16),
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
                                padding: EdgeInsets.only(top: 12),
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
                                        ConvertHelper.titleCase(widget
                                            .data.status
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
                                        padding:
                                            const EdgeInsets.only(right: 8),
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
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
                                //       final image =
                                //           widget.data.attachments[index];
                                //       return Padding(
                                //         padding:
                                //             const EdgeInsets.only(right: 8),
                                //         child: InkWell(
                                //           onTap: () {
                                //             setState(() {
                                //               isPreviewPhoto = true;
                                //             });
                                //             _dialogService
                                //                 .showDialogPreviewPhoto(
                                //               imagePath: image,
                                //               onTapClose: () {
                                //                 setState(() {
                                //                   isPreviewPhoto = false;
                                //                 });
                                //                 _dialogService.popDialog();
                                //               },
                                //             );
                                //           },
                                //           child: (image
                                //                   .toString()
                                //                   .contains('http'))
                                //               ? FutureBuilder(
                                //                   future: InspectionService
                                //                       .isInternetConnectionExist(),
                                //                   builder: (context, snapshot) {
                                //                     if (snapshot.data == true) {
                                //                       return Image.network(
                                //                         image,
                                //                         width: MediaQuery.of(
                                //                                     context)
                                //                                 .size
                                //                                 .width /
                                //                             4,
                                //                         height: MediaQuery.of(
                                //                                     context)
                                //                                 .size
                                //                                 .width /
                                //                             4,
                                //                         fit: BoxFit.cover,
                                //                       );
                                //                     } else {
                                //                       return Container(
                                //                         width: MediaQuery.of(
                                //                                     context)
                                //                                 .size
                                //                                 .width /
                                //                             4,
                                //                         height: MediaQuery.of(
                                //                                     context)
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
                                //                   width: MediaQuery.of(context)
                                //                           .size
                                //                           .width /
                                //                       4,
                                //                   height: MediaQuery.of(context)
                                //                           .size
                                //                           .width /
                                //                       4,
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
                            if (widget.data.responses.isNotEmpty)
                              ...widget.data.responses.map((item) {
                                final responseAttachment =
                                    listResponseAttachment[item.code];
                                return CardHistoryInspection(
                                  data: item,
                                  listResponseAttachment:
                                      responseAttachment ?? [],
                                  onPreviewPhoto: (value) {
                                    setState(() {
                                      isPreviewPhoto = true;
                                    });
                                    _dialogService
                                        .showDialogPreviewPhotoOffline(
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                    child: const Text(
                                        'Belum Ada Riwayat Tindakan')),
                              ),
                            if (ConvertHelper.intToBool(
                                    widget.data.isSynchronize) &&
                                widget.data.status != 'close')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: Text('Action :')),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: DropdownButton(
                                          isExpanded: true,
                                          hint: Text(
                                            "Pilih Action",
                                            style: Style.whiteBold14.copyWith(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey),
                                          ),
                                          value: selectedAction,
                                          style: Style.whiteBold14.copyWith(
                                            fontWeight: FontWeight.normal,
                                            color: themeNotifier.status ==
                                                        true ||
                                                    MediaQuery.of(context)
                                                            .platformBrightness ==
                                                        Brightness.dark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          items: listActionOption.map((value) {
                                            return DropdownMenuItem(
                                              child:
                                                  Text(ConvertHelper.titleCase(
                                                value
                                                    .replaceAll(
                                                        RegExp(r'_'), ' ')
                                                    .replaceAll(
                                                        RegExp(r'-'), ' '),
                                              )),
                                              value: value,
                                            );
                                          }).toList(),
                                          onChanged: (String? value) {
                                            if (value != null) {
                                              selectedAction = value;
                                              noteController.clear();
                                              setState(() {});
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  if (selectedAction == 'reassign')
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child:
                                                    Text('User Re Assign :')),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () async {
                                                  final data =
                                                      await _navigationService
                                                          .push(Routes
                                                              .INSPECTION_USER);
                                                  selectedUserReassign = data;
                                                  setState(() {});
                                                  log('selected user reassign : $selectedUserReassign');
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: themeNotifier
                                                                            .status ==
                                                                        true ||
                                                                    MediaQuery.of(context)
                                                                            .platformBrightness ==
                                                                        Brightness
                                                                            .dark
                                                                ? Colors.white
                                                                : Colors.grey
                                                                    .shade400,
                                                            width: 0.5)),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 4),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: selectedUserReassign !=
                                                                  null
                                                              ? Text(
                                                                  selectedUserReassign!
                                                                      .name)
                                                              : Text(
                                                                  'Pilih User',
                                                                  style: TextStyle(
                                                                      color: themeNotifier.status == true || MediaQuery.of(context).platformBrightness == Brightness.dark
                                                                          ? Colors
                                                                              .grey
                                                                              .shade500
                                                                          : Colors
                                                                              .black
                                                                              .withOpacity(0.35)),
                                                                ),
                                                        ),
                                                        Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color: themeNotifier
                                                                            .status ==
                                                                        true ||
                                                                    MediaQuery.of(context)
                                                                            .platformBrightness ==
                                                                        Brightness
                                                                            .dark
                                                                ? Colors.grey
                                                                    .shade400
                                                                : Colors.grey
                                                                    .shade700)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text('Tindakan :'),
                                        SizedBox(height: 6),
                                        InputPrimary(
                                          controller: noteController,
                                          maxLines: 10,
                                          hintText: 'Masukkan Tindakan',
                                          keyboardType: TextInputType.multiline,
                                          validator: (value) => null,
                                        ),
                                        if (listInspectionPhoto.isNotEmpty)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Foto Tindakan Inspection :'),
                                                SizedBox(height: 6),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        listInspectionPhoto
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final imagePath =
                                                          listInspectionPhoto[
                                                              index];
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 12),
                                                        child: InspectionPhoto(
                                                          imagePath: imagePath,
                                                          onTapView: () {
                                                            setState(() {
                                                              isPreviewPhoto =
                                                                  true;
                                                            });
                                                            _dialogService
                                                                .showDialogPreviewPhoto(
                                                              imagePath:
                                                                  imagePath,
                                                              onTapClose: () {
                                                                setState(() {
                                                                  isPreviewPhoto =
                                                                      false;
                                                                });
                                                                _dialogService
                                                                    .popDialog();
                                                              },
                                                            );
                                                          },
                                                          onTapRemove: () {
                                                            listInspectionPhoto
                                                                .remove(
                                                                    imagePath);
                                                            setState(() {});
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                SizedBox(height: 12),
                                              ],
                                            ),
                                          ),
                                        SizedBox(height: 12),
                                        InkWell(
                                          onTap: () {
                                            if (listInspectionPhoto.length <
                                                5) {
                                              setState(() {
                                                isShowDialogAttachment = true;
                                              });
                                              _dialogService
                                                  .showDialogAttachment(
                                                onTapCamera: () async {
                                                  _dialogService.popDialog();
                                                  setState(() {
                                                    isShowDialogAttachment =
                                                        false;
                                                  });
                                                  final result =
                                                      await CameraService
                                                          .getImage(
                                                    context,
                                                    imageSource:
                                                        ImageSource.camera,
                                                  );
                                                  if (result != null) {
                                                    listInspectionPhoto
                                                        .add(result);
                                                    setState(() {});
                                                  }
                                                },
                                                onTapGallery: () async {
                                                  _dialogService.popDialog();
                                                  setState(() {
                                                    isShowDialogAttachment =
                                                        false;
                                                  });
                                                  final result =
                                                      await CameraService
                                                          .getImage(
                                                    context,
                                                    imageSource:
                                                        ImageSource.gallery,
                                                  );
                                                  if (result != null) {
                                                    listInspectionPhoto
                                                        .add(result);
                                                    setState(() {});
                                                  }
                                                },
                                                onTapCancel: () {
                                                  setState(() {
                                                    isShowDialogAttachment =
                                                        false;
                                                  });
                                                  _dialogService.popDialog();
                                                },
                                              );
                                            } else {
                                              FlushBarManager.showFlushBarWarning(
                                                  _navigationService
                                                      .navigatorKey
                                                      .currentContext!,
                                                  "Foto Inspection",
                                                  "Maksimal 5 foto yang dapat Anda lampirkan");
                                            }
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            color: Colors.green,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Text(
                                                  "LAMPIRKAN FOTO",
                                                  style: Style.whiteBold14,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (selectedAction == 'revise')
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Keterangan :'),
                                        SizedBox(height: 6),
                                        InputPrimary(
                                          controller: noteController,
                                          maxLines: 10,
                                          hintText: 'Masukkan Keterangan',
                                          validator: (value) => null,
                                        ),
                                        if (listInspectionPhoto.isNotEmpty)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Foto Tindakan Inspection :'),
                                                SizedBox(height: 6),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        listInspectionPhoto
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final imagePath =
                                                          listInspectionPhoto[
                                                              index];
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 12),
                                                        child: InspectionPhoto(
                                                          imagePath: imagePath,
                                                          onTapView: () {
                                                            setState(() {
                                                              isPreviewPhoto =
                                                                  true;
                                                            });
                                                            _dialogService
                                                                .showDialogPreviewPhoto(
                                                              imagePath:
                                                                  imagePath,
                                                              onTapClose: () {
                                                                setState(() {
                                                                  isPreviewPhoto =
                                                                      false;
                                                                });
                                                                _dialogService
                                                                    .popDialog();
                                                              },
                                                            );
                                                          },
                                                          onTapRemove: () {
                                                            listInspectionPhoto
                                                                .remove(
                                                                    imagePath);
                                                            setState(() {});
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                SizedBox(height: 12),
                                              ],
                                            ),
                                          ),
                                        SizedBox(height: 12),
                                        InkWell(
                                          onTap: () {
                                            if (listInspectionPhoto.length <
                                                5) {
                                              setState(() {
                                                isShowDialogAttachment = true;
                                              });
                                              _dialogService
                                                  .showDialogAttachment(
                                                onTapCamera: () async {
                                                  _dialogService.popDialog();
                                                  setState(() {
                                                    isShowDialogAttachment =
                                                        false;
                                                  });
                                                  final result =
                                                      await CameraService
                                                          .getImage(
                                                    context,
                                                    imageSource:
                                                        ImageSource.camera,
                                                  );
                                                  if (result != null) {
                                                    listInspectionPhoto
                                                        .add(result);
                                                    setState(() {});
                                                  }
                                                },
                                                onTapGallery: () async {
                                                  _dialogService.popDialog();
                                                  setState(() {
                                                    isShowDialogAttachment =
                                                        false;
                                                  });
                                                  final result =
                                                      await CameraService
                                                          .getImage(
                                                    context,
                                                    imageSource:
                                                        ImageSource.gallery,
                                                  );
                                                  if (result != null) {
                                                    listInspectionPhoto
                                                        .add(result);
                                                    setState(() {});
                                                  }
                                                },
                                                onTapCancel: () {
                                                  setState(() {
                                                    isShowDialogAttachment =
                                                        false;
                                                  });
                                                  _dialogService.popDialog();
                                                },
                                              );
                                            } else {
                                              FlushBarManager.showFlushBarWarning(
                                                  _navigationService
                                                      .navigatorKey
                                                      .currentContext!,
                                                  "Foto Inspection",
                                                  "Maksimal 5 foto yang dapat Anda lampirkan");
                                            }
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            color: Colors.green,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Text(
                                                  "LAMPIRKAN FOTO",
                                                  style: Style.whiteBold14,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (selectedAction == 'need_consultation')
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                                    'User Consultation :')),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () async {
                                                  final data =
                                                      await _navigationService
                                                          .push(Routes
                                                              .INSPECTION_USER);
                                                  selectedUserConsultant = data;
                                                  setState(() {});
                                                  log('selected user consultation : $selectedUserConsultant');
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: themeNotifier
                                                                            .status ==
                                                                        true ||
                                                                    MediaQuery.of(context)
                                                                            .platformBrightness ==
                                                                        Brightness
                                                                            .dark
                                                                ? Colors.white
                                                                : Colors.grey
                                                                    .shade400,
                                                            width: 0.5)),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 4),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: selectedUserConsultant !=
                                                                  null
                                                              ? Text(
                                                                  selectedUserConsultant!
                                                                      .name)
                                                              : Text(
                                                                  'Pilih User',
                                                                  style: TextStyle(
                                                                      color: themeNotifier.status == true || MediaQuery.of(context).platformBrightness == Brightness.dark
                                                                          ? Colors
                                                                              .grey
                                                                              .shade500
                                                                          : Colors
                                                                              .black
                                                                              .withOpacity(0.35)),
                                                                ),
                                                        ),
                                                        Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color: themeNotifier
                                                                            .status ==
                                                                        true ||
                                                                    MediaQuery.of(context)
                                                                            .platformBrightness ==
                                                                        Brightness
                                                                            .dark
                                                                ? Colors.grey
                                                                    .shade400
                                                                : Colors.grey
                                                                    .shade700)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text('Keterangan :'),
                                        SizedBox(height: 6),
                                        InputPrimary(
                                          controller: noteController,
                                          maxLines: 10,
                                          hintText: 'Masukkan Keterangan',
                                          validator: (value) => null,
                                        ),
                                        if (listInspectionPhoto.isNotEmpty)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Foto Tindakan Inspection :'),
                                                SizedBox(height: 6),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        listInspectionPhoto
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final imagePath =
                                                          listInspectionPhoto[
                                                              index];
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 12),
                                                        child: InspectionPhoto(
                                                          imagePath: imagePath,
                                                          onTapView: () {
                                                            setState(() {
                                                              isPreviewPhoto =
                                                                  true;
                                                            });
                                                            _dialogService
                                                                .showDialogPreviewPhoto(
                                                              imagePath:
                                                                  imagePath,
                                                              onTapClose: () {
                                                                setState(() {
                                                                  isPreviewPhoto =
                                                                      false;
                                                                });
                                                                _dialogService
                                                                    .popDialog();
                                                              },
                                                            );
                                                          },
                                                          onTapRemove: () {
                                                            listInspectionPhoto
                                                                .remove(
                                                                    imagePath);
                                                            setState(() {});
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                SizedBox(height: 12),
                                              ],
                                            ),
                                          ),
                                        SizedBox(height: 12),
                                        InkWell(
                                          onTap: () {
                                            if (listInspectionPhoto.length <
                                                5) {
                                              setState(() {
                                                isShowDialogAttachment = true;
                                              });
                                              _dialogService
                                                  .showDialogAttachment(
                                                onTapCamera: () async {
                                                  _dialogService.popDialog();
                                                  setState(() {
                                                    isShowDialogAttachment =
                                                        false;
                                                  });
                                                  final result =
                                                      await CameraService
                                                          .getImage(
                                                    context,
                                                    imageSource:
                                                        ImageSource.camera,
                                                  );
                                                  if (result != null) {
                                                    listInspectionPhoto
                                                        .add(result);
                                                    setState(() {});
                                                  }
                                                },
                                                onTapGallery: () async {
                                                  _dialogService.popDialog();
                                                  setState(() {
                                                    isShowDialogAttachment =
                                                        false;
                                                  });
                                                  final result =
                                                      await CameraService
                                                          .getImage(
                                                    context,
                                                    imageSource:
                                                        ImageSource.gallery,
                                                  );
                                                  if (result != null) {
                                                    listInspectionPhoto
                                                        .add(result);
                                                    setState(() {});
                                                  }
                                                },
                                                onTapCancel: () {
                                                  setState(() {
                                                    isShowDialogAttachment =
                                                        false;
                                                  });
                                                  _dialogService.popDialog();
                                                },
                                              );
                                            } else {
                                              FlushBarManager.showFlushBarWarning(
                                                  _navigationService
                                                      .navigatorKey
                                                      .currentContext!,
                                                  "Foto Inspection",
                                                  "Maksimal 5 foto yang dapat Anda lampirkan");
                                            }
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            color: Colors.green,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Text(
                                                  "LAMPIRKAN FOTO",
                                                  style: Style.whiteBold14,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (selectedAction == 'consulted')
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Keterangan :'),
                                        SizedBox(height: 6),
                                        InputPrimary(
                                          controller: noteController,
                                          maxLines: 10,
                                          hintText: 'Masukkan Keterangan',
                                          validator: (value) => null,
                                        ),
                                        if (listInspectionPhoto.isNotEmpty)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Foto Tindakan Inspection :'),
                                                SizedBox(height: 6),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        listInspectionPhoto
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final imagePath =
                                                          listInspectionPhoto[
                                                              index];
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 12),
                                                        child: InspectionPhoto(
                                                          imagePath: imagePath,
                                                          onTapView: () {
                                                            setState(() {
                                                              isPreviewPhoto =
                                                                  true;
                                                            });
                                                            _dialogService
                                                                .showDialogPreviewPhoto(
                                                              imagePath:
                                                                  imagePath,
                                                              onTapClose: () {
                                                                setState(() {
                                                                  isPreviewPhoto =
                                                                      false;
                                                                });
                                                                _dialogService
                                                                    .popDialog();
                                                              },
                                                            );
                                                          },
                                                          onTapRemove: () {
                                                            listInspectionPhoto
                                                                .remove(
                                                                    imagePath);
                                                            setState(() {});
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                SizedBox(height: 12),
                                              ],
                                            ),
                                          ),
                                        SizedBox(height: 12),
                                        InkWell(
                                          onTap: () {
                                            if (listInspectionPhoto.length <
                                                5) {
                                              setState(() {
                                                isShowDialogAttachment = true;
                                              });
                                              _dialogService
                                                  .showDialogAttachment(
                                                onTapCamera: () async {
                                                  _dialogService.popDialog();
                                                  setState(() {
                                                    isShowDialogAttachment =
                                                        false;
                                                  });
                                                  final result =
                                                      await CameraService
                                                          .getImage(
                                                    context,
                                                    imageSource:
                                                        ImageSource.camera,
                                                  );
                                                  if (result != null) {
                                                    listInspectionPhoto
                                                        .add(result);
                                                    setState(() {});
                                                  }
                                                },
                                                onTapGallery: () async {
                                                  _dialogService.popDialog();
                                                  setState(() {
                                                    isShowDialogAttachment =
                                                        false;
                                                  });
                                                  final result =
                                                      await CameraService
                                                          .getImage(
                                                    context,
                                                    imageSource:
                                                        ImageSource.gallery,
                                                  );
                                                  if (result != null) {
                                                    listInspectionPhoto
                                                        .add(result);
                                                    setState(() {});
                                                  }
                                                },
                                                onTapCancel: () {
                                                  setState(() {
                                                    isShowDialogAttachment =
                                                        false;
                                                  });
                                                  _dialogService.popDialog();
                                                },
                                              );
                                            } else {
                                              FlushBarManager.showFlushBarWarning(
                                                  _navigationService
                                                      .navigatorKey
                                                      .currentContext!,
                                                  "Foto Inspection",
                                                  "Maksimal 5 foto yang dapat Anda lampirkan");
                                            }
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            color: Colors.green,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Text(
                                                  "LAMPIRKAN FOTO",
                                                  style: Style.whiteBold14,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (selectedAction == 'close')
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Keterangan :'),
                                        SizedBox(height: 6),
                                        InputPrimary(
                                          controller: noteController,
                                          maxLines: 10,
                                          hintText: 'Masukkan Keterangan',
                                          validator: (value) => null,
                                        ),
                                        if (listInspectionPhoto.isNotEmpty)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Foto Tindakan Inspection :'),
                                                SizedBox(height: 6),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        listInspectionPhoto
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final imagePath =
                                                          listInspectionPhoto[
                                                              index];
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 12),
                                                        child: InspectionPhoto(
                                                          imagePath: imagePath,
                                                          onTapView: () {
                                                            setState(() {
                                                              isPreviewPhoto =
                                                                  true;
                                                            });
                                                            _dialogService
                                                                .showDialogPreviewPhoto(
                                                              imagePath:
                                                                  imagePath,
                                                              onTapClose: () {
                                                                setState(() {
                                                                  isPreviewPhoto =
                                                                      false;
                                                                });
                                                                _dialogService
                                                                    .popDialog();
                                                              },
                                                            );
                                                          },
                                                          onTapRemove: () {
                                                            listInspectionPhoto
                                                                .remove(
                                                                    imagePath);
                                                            setState(() {});
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                SizedBox(height: 12),
                                              ],
                                            ),
                                          ),
                                        SizedBox(height: 12),
                                        InkWell(
                                          onTap: () {
                                            if (listInspectionPhoto.length <
                                                5) {
                                              setState(() {
                                                isShowDialogAttachment = true;
                                              });
                                              _dialogService
                                                  .showDialogAttachment(
                                                onTapCamera: () async {
                                                  _dialogService.popDialog();
                                                  setState(() {
                                                    isShowDialogAttachment =
                                                        false;
                                                  });
                                                  final result =
                                                      await CameraService
                                                          .getImage(
                                                    context,
                                                    imageSource:
                                                        ImageSource.camera,
                                                  );
                                                  if (result != null) {
                                                    listInspectionPhoto
                                                        .add(result);
                                                    setState(() {});
                                                  }
                                                },
                                                onTapGallery: () async {
                                                  _dialogService.popDialog();
                                                  setState(() {
                                                    isShowDialogAttachment =
                                                        false;
                                                  });
                                                  final result =
                                                      await CameraService
                                                          .getImage(
                                                    context,
                                                    imageSource:
                                                        ImageSource.gallery,
                                                  );
                                                  if (result != null) {
                                                    listInspectionPhoto
                                                        .add(result);
                                                    setState(() {});
                                                  }
                                                },
                                                onTapCancel: () {
                                                  setState(() {
                                                    isShowDialogAttachment =
                                                        false;
                                                  });
                                                  _dialogService.popDialog();
                                                },
                                              );
                                            } else {
                                              FlushBarManager.showFlushBarWarning(
                                                  _navigationService
                                                      .navigatorKey
                                                      .currentContext!,
                                                  "Foto Inspection",
                                                  "Maksimal 5 foto yang dapat Anda lampirkan");
                                            }
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            color: Colors.green,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Text(
                                                  "LAMPIRKAN FOTO",
                                                  style: Style.whiteBold14,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isShowDialogSubmit = true;
                                      });
                                      showSubmitOption();
                                    },
                                    child: Card(
                                      color: Palette.primaryColorProd,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Text(
                                            "SUBMIT",
                                            style: Style.whiteBold14,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
