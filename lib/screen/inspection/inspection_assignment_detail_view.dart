import 'dart:developer';
import 'dart:io';
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
import 'package:epms/database/service/database_subordinate_inspection.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/database/service/database_todo_inspection.dart';
import 'package:epms/database/service/database_user_inspection.dart';
import 'package:epms/database/service/database_user_inspection_config.dart';
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

class InspectionAssignmentDetailView extends StatefulWidget {
  const InspectionAssignmentDetailView({super.key, required this.data});

  final TicketInspectionModel data;

  @override
  State<InspectionAssignmentDetailView> createState() =>
      _InspectionAssignmentDetailViewState();
}

class _InspectionAssignmentDetailViewState
    extends State<InspectionAssignmentDetailView> {
  NavigatorService _navigationService = locator<NavigatorService>();
  DialogService _dialogService = locator<DialogService>();

  String responseId = '';
  UserInspectionConfigModel user = const UserInspectionConfigModel();

  double longitude = 0;
  double latitude = 0;
  String gpsLocation = '';

  final descriptionController = TextEditingController();
  final actionController = TextEditingController();

  List<HistoryInspectionModel> listHistoryInspection = [];

  List<UserInspectionModel> listUserInspection = const [];
  UserInspectionModel? selectedUserInspection;

  List<String> listActionOption = const [];
  String? selectedAction;

  final listInspectionPhoto = [];

  bool isPreviewPhoto = false;

  bool isShowDialogAttachment = false;

  @override
  void initState() {
    descriptionController.text = widget.data.description;
    listHistoryInspection = widget.data.responses;
    getResponseId();
    getUserInspection();
    getOptionAction();
    getUser();
    getLocation();
    setState(() {});
    super.initState();
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
      if (selectedUserInspection == null) {
        FlushBarManager.showFlushBarWarning(
          context,
          "Form Belum Lengkap",
          "Mohon memilih user reassign terlebih dahulu",
        );
        return false;
      }

      if (actionController.text.isEmpty) {
        FlushBarManager.showFlushBarWarning(
          context,
          "Form Belum Lengkap",
          "Mohon mengisi deskripsi tindakan terlebih dahulu",
        );
        return false;
      }

      if (listInspectionPhoto.isEmpty) {
        FlushBarManager.showFlushBarWarning(
          context,
          "Form Belum Lengkap",
          "Mohon melampirkan bukti foto",
        );
        return false;
      }
    }

    if (actionController.text.isEmpty) {
      FlushBarManager.showFlushBarWarning(
        context,
        "Form Belum Lengkap",
        "Mohon mengisi deskripsi tindakan terlebih dahulu",
      );
      return false;
    }

    if (listInspectionPhoto.isEmpty) {
      FlushBarManager.showFlushBarWarning(
        context,
        "Form Belum Lengkap",
        "Mohon melampirkan bukti foto",
      );
      return false;
    }

    return true;
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

  Future<void> getUserInspection() async {
    final data = await DatabaseUserInspection.selectData();
    listUserInspection = data;
    log('cek list user inspection : $listUserInspection');
    setState(() {});
  }

  Future<void> getOptionAction() async {
    final data =
        await DatabaseActionInspection.selectDataByStatus(widget.data.status);
    listActionOption = List<String>.from(data.options.map((e) => e.toString()));
    log('cek list action options : $listActionOption');
    setState(() {});
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
    await InspectionRepository().getMyInspection(
      context,
      (context, data) async {
        await DatabaseTicketInspection.addAllData(data);
        await InspectionRepository().getToDoInspection(
          context,
          (context, data) async {
            await DatabaseTodoInspection.addAllData(data);
            await InspectionRepository().getMySubordinate(
              context,
              (context, data) async {
                await DatabaseSubordinateInspection.addAllData(data);
                _dialogService.popDialog();
                _navigationService.pop();
                FlushBarManager.showFlushBarSuccess(
                  context,
                  "Berhasil Upload",
                  'Data Berhasil Di Upload',
                );
              },
              (context, errorMessage) {
                _dialogService.popDialog();
                FlushBarManager.showFlushBarError(
                  context,
                  "Gagal Upload",
                  errorMessage,
                );
              },
            );
          },
          (context, errorMessage) async {
            await InspectionRepository().getMySubordinate(
              context,
              (context, data) async {
                await DatabaseSubordinateInspection.addAllData(data);
                _dialogService.popDialog();
                _navigationService.pop();
                FlushBarManager.showFlushBarSuccess(
                  context,
                  "Berhasil Upload",
                  'Data Berhasil Di Upload',
                );
              },
              (context, errorMessage) {
                _dialogService.popDialog();
                FlushBarManager.showFlushBarError(
                  context,
                  "Gagal Upload",
                  errorMessage,
                );
              },
            );
          },
        );
      },
      (context, errorMessage) async {
        await InspectionRepository().getToDoInspection(
          context,
          (context, data) async {
            await DatabaseTodoInspection.addAllData(data);
            await InspectionRepository().getMySubordinate(
              context,
              (context, data) async {
                await DatabaseSubordinateInspection.addAllData(data);
                _dialogService.popDialog();
                _navigationService.pop();
                FlushBarManager.showFlushBarSuccess(
                  context,
                  "Berhasil Upload",
                  'Data Berhasil Di Upload',
                );
              },
              (context, errorMessage) {
                _dialogService.popDialog();
                FlushBarManager.showFlushBarError(
                  context,
                  "Gagal Upload",
                  errorMessage,
                );
              },
            );
          },
          (context, errorMessage) async {
            await InspectionRepository().getMySubordinate(
              context,
              (context, data) async {
                await DatabaseSubordinateInspection.addAllData(data);
                _dialogService.popDialog();
                _navigationService.pop();
                FlushBarManager.showFlushBarSuccess(
                  context,
                  "Berhasil Upload",
                  'Data Berhasil Di Upload',
                );
              },
              (context, errorMessage) {
                _dialogService.popDialog();
                FlushBarManager.showFlushBarError(
                  context,
                  "Gagal Upload",
                  errorMessage,
                );
              },
            );
          },
        );
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
        description: actionController.text,
        reassignedTo:
            selectedUserInspection != null ? selectedUserInspection!.id : '',
        reassignedToName:
            selectedUserInspection != null ? selectedUserInspection!.name : '',
        gpsLat: latitude,
        gpsLng: longitude,
        status: selectedAction ?? '',
        attachments: listInspectionPhoto,
      );
      listHistoryInspection.add(dataHistory);
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
        isClosed: widget.data.isClosed,
        isSynchronize: 0,
        isNewResponse: widget.data.isNewResponse,
        usingGps: widget.data.usingGps,
        attachments: widget.data.attachments,
        responses: listHistoryInspection,
      );

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

  @override
  void dispose() {
    descriptionController.dispose();
    actionController.dispose();
    super.dispose();
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
                if (isPreviewPhoto || isShowDialogAttachment) {
                  setState(() {
                    isPreviewPhoto = false;
                    isShowDialogAttachment = false;
                  });
                  _dialogService.popDialog();
                } else {
                  _navigationService.pop();
                }
              }
            },
            child: Scaffold(
              appBar: AppBar(title: Text("Assignment Detail")),
              body: Padding(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.data.code),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Text('Lokasi Inspection :'),
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
                      if (widget.data.mDivisionEstateCode.isNotEmpty &&
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
                              textAlign: TextAlign.end,
                            ),
                          )
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
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
                      if (ConvertHelper.intToBool(widget.data.usingGps))
                        InkWell(
                          onTap: () {
                            _navigationService.push(
                              Routes.INSPECTION_LOCATION,
                              arguments: {
                                'longitude': widget.data.gpsLng,
                                'latitude': widget.data.gpsLat,
                                'company': widget.data.mCompanyName,
                              },
                            );
                          },
                          child: Card(
                            color: Palette.primaryColorProd,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  "Lihat Lokasi Inspection",
                                  style: Style.whiteBold14,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 6),
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
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                              child: const Text('Belum Ada Riwayat Tindakan')),
                        ),
                      if (ConvertHelper.intToBool(widget.data.isSynchronize))
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
                                      color: themeNotifier.status == true ||
                                              MediaQuery.of(context)
                                                      .platformBrightness ==
                                                  Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    items: listActionOption.map((value) {
                                      return DropdownMenuItem(
                                        child: Text(ConvertHelper.titleCase(
                                            value.replaceAll(
                                                RegExp(r'_'), ' '))),
                                        value: value,
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      if (value != null) {
                                        selectedAction = value;
                                        setState(() {});
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                            if (selectedAction == 'reassign')
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('User Re Assign :')),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          final data = await _navigationService
                                              .push(Routes.INSPECTION_USER);
                                          selectedUserInspection = data;
                                          setState(() {});
                                          log('selected user reassign : $selectedUserInspection');
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: themeNotifier
                                                                    .status ==
                                                                true ||
                                                            MediaQuery.of(
                                                                        context)
                                                                    .platformBrightness ==
                                                                Brightness.dark
                                                        ? Colors.white
                                                        : Colors.grey.shade400,
                                                    width: 0.5)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: selectedUserInspection !=
                                                          null
                                                      ? Text(
                                                          selectedUserInspection!
                                                              .name)
                                                      : Text(
                                                          'Pilih User',
                                                          style: TextStyle(
                                                              color: themeNotifier
                                                                              .status ==
                                                                          true ||
                                                                      MediaQuery.of(context)
                                                                              .platformBrightness ==
                                                                          Brightness
                                                                              .dark
                                                                  ? Colors.grey
                                                                      .shade500
                                                                  : Colors.black
                                                                      .withOpacity(
                                                                          0.35)),
                                                        ),
                                                ),
                                                Icon(Icons.arrow_drop_down,
                                                    color: themeNotifier
                                                                    .status ==
                                                                true ||
                                                            MediaQuery.of(
                                                                        context)
                                                                    .platformBrightness ==
                                                                Brightness.dark
                                                        ? Colors.grey.shade400
                                                        : Colors.grey.shade700)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // Row(
                            //   children: [
                            //     Text('Lokasi Tindakan :'),
                            //     SizedBox(width: 12),
                            //     Expanded(
                            //         child: Text('$longitude,$latitude',
                            //             textAlign: TextAlign.end))
                            //   ],
                            // ),
                            // SizedBox(height: 8),
                            Text('Tindakan :'),
                            SizedBox(height: 6),
                            InputPrimary(
                              controller: actionController,
                              maxLines: 10,
                              hintText: 'Masukkan Tindakan',
                              validator: (value) => null,
                            ),
                            // SizedBox(height: 12),
                            if (listInspectionPhoto.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Foto Tindakan Inspection :'),
                                  SizedBox(height: 6),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.width / 4,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: listInspectionPhoto.length,
                                      itemBuilder: (context, index) {
                                        final imagePath =
                                            listInspectionPhoto[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 12),
                                          child: InspectionPhoto(
                                            imagePath: imagePath,
                                            onTapView: () {
                                              setState(() {
                                                isPreviewPhoto = true;
                                              });
                                              _dialogService
                                                  .showDialogPreviewPhoto(
                                                imagePath: imagePath,
                                                onTapClose: () {
                                                  setState(() {
                                                    isPreviewPhoto = false;
                                                  });
                                                  _dialogService.popDialog();
                                                },
                                              );
                                            },
                                            onTapRemove: () {
                                              listInspectionPhoto
                                                  .remove(imagePath);
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
                            InkWell(
                              onTap: () {
                                if (listInspectionPhoto.length < 5) {
                                  setState(() {
                                    isShowDialogAttachment = true;
                                  });
                                  _dialogService.showDialogAttachment(
                                    onTapCamera: () async {
                                      _dialogService.popDialog();
                                      setState(() {
                                        isShowDialogAttachment = false;
                                      });
                                      final result =
                                          await CameraService.getImage(
                                        context,
                                        imageSource: ImageSource.camera,
                                      );
                                      if (result != null) {
                                        listInspectionPhoto.add(result);
                                        setState(() {});
                                      }
                                    },
                                    onTapGallery: () async {
                                      _dialogService.popDialog();
                                      setState(() {
                                        isShowDialogAttachment = false;
                                      });
                                      final result =
                                          await CameraService.getImage(
                                        context,
                                        imageSource: ImageSource.gallery,
                                      );
                                      if (result != null) {
                                        listInspectionPhoto.add(result);
                                        setState(() {});
                                      }
                                    },
                                    onTapCancel: () {
                                      setState(() {
                                        isShowDialogAttachment = false;
                                      });
                                      _dialogService.popDialog();
                                    },
                                  );
                                } else {
                                  FlushBarManager.showFlushBarWarning(
                                      _navigationService
                                          .navigatorKey.currentContext!,
                                      "Foto Inspection",
                                      "Maksimal 5 foto yang dapat Anda lampirkan");
                                }
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: Colors.green,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "LAMPIRKAN FOTO",
                                      style: Style.whiteBold14,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                await submit();
                              },
                              child: Card(
                                color: Palette.primaryColorProd,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
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
