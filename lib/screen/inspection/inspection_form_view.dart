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
import 'package:epms/database/service/database_attachment_inspection.dart';
import 'package:epms/database/service/database_company_inspection.dart';
import 'package:epms/database/service/database_division_inspection.dart';
import 'package:epms/database/service/database_estate_inspection.dart';
import 'package:epms/database/service/database_member_inspection.dart';
import 'package:epms/database/service/database_subordinate_inspection.dart';
import 'package:epms/database/service/database_team_inspection.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/database/service/database_todo_inspection.dart';
import 'package:epms/database/service/database_user_inspection.dart';
import 'package:epms/database/service/database_user_inspection_config.dart';
import 'package:epms/model/company_inspection_model.dart';
import 'package:epms/model/division_inspection_model.dart';
import 'package:epms/model/estate_inspection_model.dart';
import 'package:epms/model/member_inspection_model.dart';
import 'package:epms/model/team_inspection_model.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/model/user_inspection_config_model.dart';
import 'package:epms/model/user_inspection_model.dart';
import 'package:epms/screen/inspection/components/input_primary.dart';
import 'package:epms/screen/inspection/components/inspection_photo.dart';
import 'package:epms/screen/inspection/inspection_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InspectionFormView extends StatefulWidget {
  const InspectionFormView({super.key});

  @override
  State<InspectionFormView> createState() => _InspectionFormViewState();
}

class _InspectionFormViewState extends State<InspectionFormView> {
  NavigatorService _navigationService = locator<NavigatorService>();
  DialogService _dialogService = locator<DialogService>();

  UserInspectionConfigModel user = const UserInspectionConfigModel();

  String inspectionId = '';
  String inspectionDateTime = '';
  double longitude = 0;
  double latitude = 0;
  String gpsLocation = '';

  UserInspectionModel? selectedUserInspection;
  MemberInspectionModel? selectedUserInspectionMember;

  List<TeamInspectionModel> listCategory = const [];
  TeamInspectionModel? selectedCategory;

  List<CompanyInspectionModel> listCompany = const [];
  CompanyInspectionModel? selectedCompany;

  List<DivisionInspectionModel> listDivision = const [];
  DivisionInspectionModel? selectedDivision;

  List<EstateInspectionModel> listEstate = const [];
  EstateInspectionModel? selectedEstate;

  bool isLoading = false;

  bool usingGps = true;

  bool isPreviewPhoto = false;

  bool isShowDialogAttachment = false;

  bool isShowDialogSubmit = false;

  final desctiptionController = TextEditingController();
  final listInspectionPhoto = [];

  @override
  void initState() {
    initData();
    super.initState();
  }

  bool validateForm() {
    if (selectedCategory == null) {
      FlushBarManager.showFlushBarWarning(
        context,
        "Form Belum Lengkap",
        "Mohon memilih kategori terlebih dahulu",
      );
      return false;
    }

    if (selectedCategory != null && selectedCategory!.name == 'Estate') {
      if (selectedCompany == null) {
        FlushBarManager.showFlushBarWarning(
          context,
          "Form Belum Lengkap",
          "Mohon memilih company terlebih dahulu",
        );
        return false;
      }

      if (selectedEstate == null) {
        FlushBarManager.showFlushBarWarning(
          context,
          "Form Belum Lengkap",
          "Mohon memilih estate terlebih dahulu",
        );
        return false;
      }

      if (selectedDivision == null) {
        FlushBarManager.showFlushBarWarning(
          context,
          "Form Belum Lengkap",
          "Mohon memilih division terlebih dahulu",
        );
        return false;
      }

      if (selectedUserInspection == null) {
        FlushBarManager.showFlushBarWarning(
          context,
          "Form Belum Lengkap",
          "Mohon memilih user assign terlebih dahulu",
        );
        return false;
      }

      if (desctiptionController.text.isEmpty) {
        FlushBarManager.showFlushBarWarning(
          context,
          "Form Belum Lengkap",
          "Mohon mengisi deskripsi terlebih dahulu",
        );
        return false;
      }

      if (listInspectionPhoto.isEmpty) {
        FlushBarManager.showFlushBarWarning(
          context,
          "Form Belum Lengkap",
          "Mohon melampirkan foto",
        );
        return false;
      }
    }

    if (selectedCompany == null) {
      FlushBarManager.showFlushBarWarning(
        context,
        "Form Belum Lengkap",
        "Mohon memilih company terlebih dahulu",
      );
      return false;
    }

    if (selectedUserInspection == null) {
      FlushBarManager.showFlushBarWarning(
        context,
        "Form Belum Lengkap",
        "Mohon memilih user assign terlebih dahulu",
      );
      return false;
    }

    if (desctiptionController.text.isEmpty) {
      FlushBarManager.showFlushBarWarning(
        context,
        "Form Belum Lengkap",
        "Mohon mengisi deskripsi terlebih dahulu",
      );
      return false;
    }

    if (listInspectionPhoto.isEmpty) {
      FlushBarManager.showFlushBarWarning(
        context,
        "Form Belum Lengkap",
        "Mohon melampirkan foto",
      );
      return false;
    }

    return true;
  }

  void onLoading() => setState(() => isLoading = true);

  void offLoading() => setState(() => isLoading = false);

  Future<void> initData() async {
    getInspectionId();
    getInspectionDateTime();
    await getUser();
    await getCategory();
    await getCompany();
    await getLocation();
  }

  void getInspectionId() {
    final dateNow = DateTime.now();
    final dateNowConvert = ValueService.generateIDFromDateTime(dateNow);
    math.Random random = new math.Random();
    var randomNumber = random.nextInt(100);
    inspectionId = 'I$dateNowConvert$randomNumber';
    log('cek inspection id : $inspectionId');
    setState(() {});
  }

  void getInspectionDateTime() {
    final dateNow = DateTime.now();
    inspectionDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateNow);
    log('cek inspection date time : $inspectionDateTime');
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

  Future<void> getUser() async {
    final data = await DatabaseUserInspectionConfig.selectData();
    user = data;
    log('cek user : $user');
    setState(() {});
  }

  Future<void> getCategory() async {
    final data = await DatabaseTeamInspection.selectData();
    listCategory = data;
    log('cek list category : $listCategory');
    setState(() {});
  }

  Future<void> getCompany() async {
    final data = await DatabaseCompanyInspection.selectData();
    listCompany = data;
    log('cek list company : $listCompany');
    setState(() {});
  }

  Future<void> getEstate() async {
    final data = await DatabaseEstateInspection.selectData(selectedCompany!.id);
    listEstate = data;
    log('cek list estate : $listEstate');
    setState(() {});
  }

  Future<void> getDivision() async {
    final data = await DatabaseDivisionInspection.selectDataByCompanyId(
      companyId: selectedCompany!.id,
      estateCode: selectedEstate!.code,
    );
    listDivision = data;
    log('cek list division : $listDivision');
    setState(() {});
  }

  // Future<void> getDefaultUserInspection() async {
  //   final companyId = selectedCompany != null ? selectedCompany!.id : '';
  //   final listUserInspection =
  //       await DatabaseUserInspection.selectData(companyId);
  //   selectedUserInspection = listUserInspection.first;
  //   setState(() {});
  // }

  Future<void> getDefaultUserInspectionMember() async {
    final listUserInspectionMember = await DatabaseMemberInspection.selectData(
      teamId: selectedCategory != null ? selectedCategory!.id : '',
      companyId: selectedCompany != null ? selectedCompany!.id : '',
      estateId: selectedEstate != null ? selectedEstate!.id : '',
      divisiId: selectedDivision != null ? selectedDivision!.id : '',
    );
    log('list team member : $listUserInspectionMember');
    log('list team member total : ${listUserInspectionMember.length}');

    if (listUserInspectionMember.isNotEmpty) {
      selectedUserInspectionMember = listUserInspectionMember.first;
      final listUserInspection = await DatabaseUserInspection.selectData(
          selectedUserInspectionMember!.mUserId, '');
      if (listUserInspection.isNotEmpty) {
        selectedUserInspection = listUserInspection.first;
      }
    } else {
      final listUserInspection =
          await DatabaseUserInspection.selectData('', selectedCompany!.id);

      selectedUserInspectionMember = null;
      selectedUserInspection = listUserInspection.first;
    }

    setState(() {});
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

  Future<void> uploadInspection(
    BuildContext context, {
    required TicketInspectionModel ticketInspection,
  }) async {
    _dialogService.showLoadingDialog(title: "Upload Data");
    await InspectionRepository().createInspection(
      context,
      ticketInspection,
      (context, successMessage) async {
        await DatabaseTicketInspection.deleteTicketByCode(ticketInspection);
        // await DatabaseAttachmentInspection.deleteInspectionByCode(
        //     ticketInspection);
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

  Future<void> createInspection() async {
    if (validateForm()) {
      final ticketInspection = TicketInspectionModel(
        code: inspectionId,
        trTime: inspectionDateTime,
        mCompanyId: selectedCompany != null ? selectedCompany!.id : '-',
        mCompanyName: selectedCompany != null ? selectedCompany!.name : '-',
        mCompanyAlias: selectedCompany != null ? selectedCompany!.alias : '-',
        mTeamId: selectedCategory != null ? selectedCategory!.id : '-',
        mTeamName: selectedCategory != null ? selectedCategory!.name : '-',
        mDivisionId: selectedDivision != null ? selectedDivision!.id : '',
        mDivisionName: selectedDivision != null ? selectedDivision!.name : '',
        mDivisionEstateCode:
            selectedDivision != null ? selectedDivision!.estateCode : '',
        gpsLng: longitude,
        gpsLat: latitude,
        submittedAt: inspectionDateTime,
        submittedBy: user.id,
        submittedByName: user.name,
        assignee:
            selectedUserInspection != null ? selectedUserInspection!.name : '-',
        assigneeId:
            selectedUserInspection != null ? selectedUserInspection!.id : '-',
        // assignee: selectedUserInspectionMember != null
        //     ? selectedUserInspectionMember!.mUserName
        //     : '-',
        // assigneeId: selectedUserInspectionMember != null
        //     ? selectedUserInspectionMember!.mUserId
        //     : '-',
        status: 'waiting',
        description: desctiptionController.text,
        isSynchronize: 0,
        usingGps: usingGps ? 1 : 0,
        attachments: listInspectionPhoto,
        responses: [],
      );

      await DatabaseAttachmentInspection.insertInspection(ticketInspection);
      await DatabaseTicketInspection.insertData(ticketInspection);
      final isInternetExist =
          await InspectionService.isInternetConnectionExist();
      if (isInternetExist) {
        uploadInspection(context, ticketInspection: ticketInspection);
      } else {
        _navigationService.pop();
      }
    }
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
        await createInspection();
      },
      onTapCancel: () {
        setState(() {
          isShowDialogSubmit = false;
        });
        _dialogService.popDialog();
      },
    );
  }

  @override
  void dispose() {
    desctiptionController.dispose();
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
              appBar: AppBar(
                title: Text("Inspection Form"),
              ),
              body: Padding(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(inspectionId),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Text('Tanggal :'),
                          SizedBox(width: 12),
                          Expanded(
                              child: Text(inspectionDateTime,
                                  textAlign: TextAlign.end))
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Text('Lokasi Buat :'),
                          SizedBox(width: 12),
                          Expanded(
                              child:
                                  Text(gpsLocation, textAlign: TextAlign.end))
                        ],
                      ),
                      CheckboxListTile(
                        value: usingGps,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        activeColor: Colors.orange,
                        checkColor: Colors.white,
                        title: Text(
                            'Apakah Inspeksi ini dibuat di lokasi temuan ?'),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              usingGps = value;
                            });
                          }
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text('Kategori :'),
                          ),
                          // SizedBox(width: 12),
                          Expanded(
                            flex: 4,
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Text(
                                "Pilih Kategori",
                                style: Style.whiteBold14.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey),
                              ),
                              value: selectedCategory,
                              style: Style.whiteBold14.copyWith(
                                fontWeight: FontWeight.normal,
                                color: themeNotifier.status == true ||
                                        MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              items: listCategory.map((value) {
                                return DropdownMenuItem(
                                  child: Text(value.name),
                                  value: value,
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  selectedCategory = value;
                                  selectedCompany = null;
                                  selectedEstate = null;
                                  selectedDivision = null;
                                  selectedUserInspection = null;
                                  selectedUserInspectionMember = null;
                                  log('selectedCategory : $selectedCategory');
                                  setState(() {});
                                }
                              },
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text('Company :'),
                          ),
                          // SizedBox(width: 12),
                          Expanded(
                            flex: 4,
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Text(
                                "Pilih Company",
                                style: Style.whiteBold14.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey),
                              ),
                              value: selectedCompany,
                              style: Style.whiteBold14.copyWith(
                                fontWeight: FontWeight.normal,
                                color: themeNotifier.status == true ||
                                        MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              items: listCompany.map((value) {
                                return DropdownMenuItem(
                                  child: Text(value.alias),
                                  value: value,
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  selectedCompany = value;
                                  selectedEstate = null;
                                  selectedDivision = null;
                                  selectedUserInspectionMember = null;
                                  getEstate();
                                  // getDivision();
                                  // initialSelectedUser();
                                  // getDefaultUserInspection();
                                  getDefaultUserInspectionMember();
                                  log('selectedCompany : $selectedCompany');
                                  setState(() {});
                                }
                              },
                            ),
                          )
                        ],
                      ),
                      if (selectedCategory?.name == 'Estate' &&
                          selectedCompany != null &&
                          listEstate.isNotEmpty)
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text('Estate :'),
                            ),
                            Expanded(
                              flex: 4,
                              child: DropdownButton(
                                isExpanded: true,
                                hint: Text(
                                  "Pilih Estate",
                                  style: Style.whiteBold14.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                ),
                                value: selectedEstate,
                                style: Style.whiteBold14.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: themeNotifier.status == true ||
                                          MediaQuery.of(context)
                                                  .platformBrightness ==
                                              Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                items: listEstate.map((value) {
                                  return DropdownMenuItem(
                                    child: Text(value.name),
                                    value: value,
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    selectedEstate = value;
                                    selectedDivision = null;
                                    selectedUserInspectionMember = null;
                                    getDivision();
                                    getDefaultUserInspectionMember();
                                    log('selected estate : $selectedEstate');
                                    setState(() {});
                                  }
                                },
                              ),
                            )
                          ],
                        )
                      else
                        const SizedBox(),

                      if (selectedCategory?.name == 'Estate' &&
                          selectedCompany != null &&
                          selectedEstate != null &&
                          listDivision.isNotEmpty)
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text('Divisi :'),
                            ),
                            // SizedBox(width: 12),
                            Expanded(
                              flex: 4,
                              child: DropdownButton(
                                isExpanded: true,
                                hint: Text(
                                  "Pilih Divisi",
                                  style: Style.whiteBold14.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                ),
                                value: selectedDivision,
                                style: Style.whiteBold14.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: themeNotifier.status == true ||
                                          MediaQuery.of(context)
                                                  .platformBrightness ==
                                              Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                items: listDivision.map((value) {
                                  return DropdownMenuItem(
                                    child: Text(
                                        'Estate ${value.estateCode} | ${value.name}'),
                                    value: value,
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    selectedDivision = value;
                                    selectedUserInspectionMember = null;
                                    getDefaultUserInspectionMember();
                                    log('selected divisi : $selectedDivision');
                                    setState(() {});
                                  }
                                },
                              ),
                            )
                          ],
                        )
                      else if (selectedCategory?.name == 'Estate' &&
                          selectedCompany != null &&
                          selectedEstate != null)
                        Text(
                            'Company ${selectedCompany?.alias} Tidak Mempunyai Divisi'),

                      // User Assign
                      if (selectedCompany != null)
                        if (selectedCategory?.name == 'Estate')
                          if (selectedEstate != null &&
                              selectedDivision != null)
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text('User Assign :'),
                                ),
                                // SizedBox(width: 12),
                                Expanded(
                                  flex: 4,
                                  child: InkWell(
                                    onTap: () async {
                                      final data =
                                          await _navigationService.push(
                                        Routes.INSPECTION_USER,
                                        arguments:
                                            selectedUserInspection!.mCompanyId,
                                      );

                                      if (data != null) {
                                        selectedUserInspection = data;
                                        selectedUserInspectionMember = null;
                                        setState(() {});
                                        log('selected user inspection : $selectedUserInspection');
                                      }
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
                                              child: selectedUserInspection !=
                                                      null
                                                  ? Text(selectedUserInspection!
                                                      .name)
                                                  : Text(
                                                      'Pilih User',
                                                      style: TextStyle(
                                                          color: themeNotifier.status ==
                                                                      true ||
                                                                  MediaQuery.of(
                                                                              context)
                                                                          .platformBrightness ==
                                                                      Brightness
                                                                          .dark
                                                              ? Colors
                                                                  .grey.shade500
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
                            )
                          else
                            const SizedBox()
                        else
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text('User Assign :'),
                              ),
                              // SizedBox(width: 12),
                              Expanded(
                                flex: 4,
                                child: InkWell(
                                  onTap: () async {
                                    final data = await _navigationService.push(
                                      Routes.INSPECTION_USER,
                                      arguments:
                                          selectedUserInspection!.mCompanyId,
                                    );

                                    if (data != null) {
                                      selectedUserInspection = data;
                                      selectedUserInspectionMember = null;
                                      setState(() {});
                                      log('selected user inspection : $selectedUserInspection');
                                    }
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
                          )
                      else
                        const SizedBox(),

                      // User Assign Old
                      // if (selectedCategory?.name != 'Estate' &&
                      //     selectedCompany != null)
                      //   Row(
                      //     children: [
                      //       Expanded(child: Text('User Assign :')),
                      //       SizedBox(width: 12),
                      //       Expanded(
                      //         child: InkWell(
                      //           onTap: () async {
                      //             final data = await _navigationService.push(
                      //               Routes.INSPECTION_USER,
                      //               arguments: selectedCompany?.id,
                      //             );
                      //             if (data != null) {
                      //               selectedUserInspection = data;
                      //               setState(() {});
                      //               log('selected user inspection : $selectedUserInspection');
                      //             }
                      //           },
                      //           child: Container(
                      //             decoration: BoxDecoration(
                      //               border: Border(
                      //                   bottom: BorderSide(
                      //                       color: themeNotifier.status ==
                      //                                   true ||
                      //                               MediaQuery.of(context)
                      //                                       .platformBrightness ==
                      //                                   Brightness.dark
                      //                           ? Colors.white
                      //                           : Colors.grey.shade400,
                      //                       width: 0.5)),
                      //             ),
                      //             child: Padding(
                      //               padding:
                      //                   const EdgeInsets.symmetric(vertical: 4),
                      //               child: Row(
                      //                 children: [
                      //                   Expanded(
                      //                     child: selectedUserInspection != null
                      //                         ? Text(
                      //                             selectedUserInspection!.name)
                      //                         : Text(
                      //                             'Pilih User',
                      //                             style: TextStyle(
                      //                                 color: themeNotifier
                      //                                                 .status ==
                      //                                             true ||
                      //                                         MediaQuery.of(
                      //                                                     context)
                      //                                                 .platformBrightness ==
                      //                                             Brightness
                      //                                                 .dark
                      //                                     ? Colors.grey.shade500
                      //                                     : Colors.black
                      //                                         .withOpacity(
                      //                                             0.35)),
                      //                           ),
                      //                   ),
                      //                   Icon(Icons.arrow_drop_down,
                      //                       color: themeNotifier.status ==
                      //                                   true ||
                      //                               MediaQuery.of(context)
                      //                                       .platformBrightness ==
                      //                                   Brightness.dark
                      //                           ? Colors.grey.shade400
                      //                           : Colors.grey.shade700)
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   )
                      // else if (selectedCompany != null &&
                      //     selectedDivision != null)
                      //   Row(
                      //     children: [
                      //       Expanded(child: Text('User Assign :')),
                      //       SizedBox(width: 12),
                      //       Expanded(
                      //         child: InkWell(
                      //           onTap: () async {
                      //             final data = await _navigationService
                      //                 .push(Routes.INSPECTION_USER);
                      //             selectedUserInspection = data;
                      //             setState(() {});
                      //             log('selected user inspection : $selectedUserInspection');
                      //           },
                      //           child: Container(
                      //             decoration: BoxDecoration(
                      //               border: Border(
                      //                   bottom: BorderSide(
                      //                       color: themeNotifier.status ==
                      //                                   true ||
                      //                               MediaQuery.of(context)
                      //                                       .platformBrightness ==
                      //                                   Brightness.dark
                      //                           ? Colors.white
                      //                           : Colors.grey.shade400,
                      //                       width: 0.5)),
                      //             ),
                      //             child: Padding(
                      //               padding:
                      //                   const EdgeInsets.symmetric(vertical: 4),
                      //               child: Row(
                      //                 children: [
                      //                   Expanded(
                      //                     child: selectedUserInspection != null
                      //                         ? Text(
                      //                             selectedUserInspection!.name)
                      //                         : Text(
                      //                             'Pilih User',
                      //                             style: TextStyle(
                      //                                 color: themeNotifier
                      //                                                 .status ==
                      //                                             true ||
                      //                                         MediaQuery.of(
                      //                                                     context)
                      //                                                 .platformBrightness ==
                      //                                             Brightness
                      //                                                 .dark
                      //                                     ? Colors.grey.shade500
                      //                                     : Colors.black
                      //                                         .withOpacity(
                      //                                             0.35)),
                      //                           ),
                      //                   ),
                      //                   Icon(Icons.arrow_drop_down,
                      //                       color: themeNotifier.status ==
                      //                                   true ||
                      //                               MediaQuery.of(context)
                      //                                       .platformBrightness ==
                      //                                   Brightness.dark
                      //                           ? Colors.grey.shade400
                      //                           : Colors.grey.shade700)
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      SizedBox(height: 8),
                      Text('Deskripsi :'),
                      SizedBox(height: 6),
                      InputPrimary(
                        controller: desctiptionController,
                        maxLines: 10,
                        hintText: 'Masukkan Deskripsi',
                        keyboardType: TextInputType.multiline,
                        validator: (value) => null,
                      ),
                      if (listInspectionPhoto.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Foto Inspection :'),
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
                                        setState(() {
                                          isPreviewPhoto = true;
                                        });
                                        _dialogService.showDialogPreviewPhoto(
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
                                final result = await CameraService.getImage(
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
                                final result = await CameraService.getImage(
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
                                "LAMPIRKAN FOTO",
                                style: Style.whiteBold14,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
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
          ),
        );
      },
    );
  }
}
