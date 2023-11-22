import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/base/ui/theme_notifier.dart';
import 'package:epms/common_manager/camera_service.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/location_service.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/database/helper/convert_helper.dart';
import 'package:epms/database/service/database_action_inspection.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/database/service/database_user_inspection.dart';
import 'package:epms/database/service/database_user_inspection_config.dart';
import 'package:epms/model/history_inspection_model.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/model/user_inspection_config_model.dart';
import 'package:epms/model/user_inspection_model.dart';
import 'package:epms/screen/inspection/components/card_history_inspection.dart';
import 'package:epms/screen/inspection/components/input_primary.dart';
import 'package:epms/screen/inspection/components/inspection_photo.dart';
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

  String responseId = '';
  UserInspectionConfigModel user = const UserInspectionConfigModel();

  double longitude = 0;
  double latitude = 0;
  String gpsLocation = '';

  List<UserInspectionModel> listUserInspection = const [];
  UserInspectionModel? selectedUserInspection;

  final descriptionController = TextEditingController();
  final noteController = TextEditingController();

  List<HistoryInspectionModel> listHistoryInspection = [];

  List<String> listActionOption = const [];
  String? selectedAction;

  final listInspectionPhoto = [];

  @override
  void initState() {
    descriptionController.text = widget.data.description;
    listHistoryInspection = widget.data.responses;
    getResponseId();
    getOptionAction();
    getUserInspection();
    getUser();
    getLocation();
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> getOptionAction() async {
    final data =
        await DatabaseActionInspection.selectDataByStatus(widget.data.status);
    listActionOption = List<String>.from(data.options.map((e) => e.toString()));
    log('cek list action options : $listActionOption');
    setState(() {});
  }

  Future<void> getUserInspection() async {
    final data = await DatabaseUserInspection.selectData();
    listUserInspection = data;
    log('cek list user inspection : $listUserInspection');
    setState(() {});
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

  Future<void> submit() async {
    final dataHistory = HistoryInspectionModel(
      id: widget.data.id,
      code: responseId,
      trTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      submittedAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      submittedBy: user.id,
      submittedByName: user.name,
      description: noteController.text.isNotEmpty ? noteController.text : '',
      consultedWith:
          selectedUserInspection != null ? selectedUserInspection!.id : '',
      consultedWithName:
          selectedUserInspection != null ? selectedUserInspection!.name : '',
      gpsLat: latitude,
      gpsLng: longitude,
      status: selectedAction ?? '',
      attachments: [],
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
      status: selectedAction ?? '-',
      description: widget.data.description,
      closedAt: widget.data.closedAt,
      closedBy: widget.data.closedBy,
      closedByName: widget.data.closedByName,
      attachments: widget.data.attachments,
      responses: listHistoryInspection,
    );
    await DatabaseTicketInspection.updateData(dataInspection);
    _navigationService.pop();
  }

  void showDialogOptionTakeFoto(
    BuildContext context, {
    required Function() onTapCamera,
    required Function() onTapGalery,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return MediaQuery(
          data: Style.mediaQueryText(context),
          child: AlertDialog(
            title: Center(
                child: Text('Ambil Foto Melalui', style: Style.textBold14)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Palette.primaryColorProd,
                    minimumSize: Size(MediaQuery.of(context).size.width, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Palette.primaryColorProd)),
                    padding: const EdgeInsets.all(16.0),
                    textStyle:
                        const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onTapCamera();
                  },
                  child: Text("KAMERA",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 12),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Palette.primaryColorProd,
                    minimumSize: Size(MediaQuery.of(context).size.width, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Palette.primaryColorProd)),
                    padding: const EdgeInsets.all(16.0),
                    textStyle:
                        const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onTapGalery();
                  },
                  child: Text("GALERI",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
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
          child: Scaffold(
            appBar: AppBar(title: Text("Approval")),
            body: Padding(
              padding: EdgeInsets.all(16),
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
                        child: Row(
                          children: [
                            Text('Divisi :'),
                            SizedBox(width: 12),
                            Expanded(
                                child: Text(
                                    '${widget.data.mDivisionEstateCode} | ${widget.data.mDivisionName}',
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
                                    showFoto(context, image);
                                  },
                                  child: Image.file(
                                    File(image),
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    height:
                                        MediaQuery.of(context).size.width / 4,
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
                    if (widget.data.responses.isNotEmpty)
                      ...widget.data.responses
                          .map((item) => CardHistoryInspection(data: item))
                          .toList()
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                            child: const Text('Belum Ada Riwayat Tindakan')),
                      ),
                    // Text('Tindakan :'),
                    // SizedBox(height: 6),
                    // InputPrimary(
                    //   controller: actionController,
                    //   hintText: 'Belum ada Tindakan',
                    //   maxLines: 10,
                    //   validator: (value) => null,
                    //   readOnly: action == 'Revisi' ? false : true,
                    // ),
                    Row(
                      children: [
                        Text('Lokasi Tindakan Buat :'),
                        SizedBox(width: 12),
                        Expanded(
                            child: Text('$longitude,$latitude',
                                textAlign: TextAlign.end))
                      ],
                    ),
                    SizedBox(height: 8),
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
                                    value.replaceAll(RegExp(r'_'), ' '))),
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
                    if (selectedAction == 'need_consultation')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text('User Consultation :')),
                              SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    final data = await _navigationService
                                        .push(Routes.INSPECTION_USER);
                                    selectedUserInspection = data;
                                    setState(() {});
                                    log('selected user consultation : $selectedUserInspection');
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: themeNotifier.status ==
                                                          true ||
                                                      MediaQuery.of(context)
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
                                            child:
                                                selectedUserInspection != null
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
                                              color: themeNotifier.status ==
                                                          true ||
                                                      MediaQuery.of(context)
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
                          // Row(
                          //   children: [
                          //     Expanded(child: Text('User Consultation :')),
                          //     SizedBox(width: 12),
                          //     Expanded(
                          //       child: DropdownButton(
                          //         isExpanded: true,
                          //         hint: Text(
                          //           "Pilih User",
                          //           style: Style.whiteBold14.copyWith(
                          //               fontWeight: FontWeight.normal,
                          //               color: Colors.grey),
                          //         ),
                          //         value: userConsultation,
                          //         style: Style.whiteBold14.copyWith(
                          //           fontWeight: FontWeight.normal,
                          //           color: themeNotifier.status == true ||
                          //                   MediaQuery.of(context)
                          //                           .platformBrightness ==
                          //                       Brightness.dark
                          //               ? Colors.white
                          //               : Colors.black,
                          //         ),
                          //         items: listUserConsultation.map((value) {
                          //           return DropdownMenuItem(
                          //             child: Text(value),
                          //             value: value,
                          //           );
                          //         }).toList(),
                          //         onChanged: (String? value) {
                          //           if (value != null) {
                          //             userConsultation = value;
                          //             setState(() {});
                          //           }
                          //         },
                          //       ),
                          //     )
                          //   ],
                          // ),
                          Text('Keterangan :'),
                          SizedBox(height: 6),
                          InputPrimary(
                            controller: noteController,
                            maxLines: 10,
                            hintText: 'Masukkan Keterangan',
                            validator: (value) => null,
                          ),
                        ],
                      ),
                    SizedBox(height: 12),
                    if (listInspectionPhoto.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Foto Tindakan Inspection :'),
                          SizedBox(height: 6),
                          SizedBox(
                            height: MediaQuery.of(context).size.width / 4,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listInspectionPhoto.length,
                              itemBuilder: (context, index) {
                                final imagePath = listInspectionPhoto[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: InspectionPhoto(
                                    imagePath: imagePath,
                                    onTapView: () {
                                      showFoto(context, imagePath);
                                    },
                                    onTapRemove: () {
                                      listInspectionPhoto.remove(imagePath);
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
                    SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        if (listInspectionPhoto.length < 5) {
                          showDialogOptionTakeFoto(
                            context,
                            onTapCamera: () async {
                              final result = await CameraService.getImage(
                                context,
                                imageSource: ImageSource.camera,
                              );
                              if (result != null) {
                                listInspectionPhoto.add(result);
                                setState(() {});
                              }
                            },
                            onTapGalery: () async {
                              final result = await CameraService.getImage(
                                context,
                                imageSource: ImageSource.gallery,
                              );
                              if (result != null) {
                                listInspectionPhoto.add(result);
                                setState(() {});
                              }
                            },
                          );
                        } else {
                          FlushBarManager.showFlushBarWarning(
                              _navigationService.navigatorKey.currentContext!,
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
                              "ATTACHMENT",
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
              ),
            ),
          ),
        );
      },
    );
  }
}
