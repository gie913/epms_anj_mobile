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
import 'package:epms/database/service/database_company_inspection.dart';
import 'package:epms/database/service/database_division_inspection.dart';
import 'package:epms/database/service/database_team_inspection.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/database/service/database_user_inspection.dart';
import 'package:epms/database/service/database_user_inspection_config.dart';
import 'package:epms/model/company_inspection_model.dart';
import 'package:epms/model/division_inspection_model.dart';
import 'package:epms/model/team_inspection_model.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/model/user_inspection_config_model.dart';
import 'package:epms/model/user_inspection_model.dart';
import 'package:epms/screen/inspection/components/input_primary.dart';
import 'package:epms/screen/inspection/components/inspection_photo.dart';
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

  UserInspectionConfigModel user = const UserInspectionConfigModel();

  String inspectionId = '';
  String inspectionDateTime = '';
  double longitude = 0;
  double latitude = 0;
  String gpsLocation = '';

  List<UserInspectionModel> listUserInspection = const [];
  UserInspectionModel? selectedUserInspection;

  List<TeamInspectionModel> listCategory = const [];
  TeamInspectionModel? selectedCategory;

  List<CompanyInspectionModel> listCompany = const [];
  CompanyInspectionModel? selectedCompany;

  List<DivisionInspectionModel> listDivision = const [];
  DivisionInspectionModel? selectedDivision;

  bool isLoading = false;

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

    if (selectedCategory != null && selectedCategory!.code == 'est') {
      if (selectedCompany == null) {
        FlushBarManager.showFlushBarWarning(
          context,
          "Form Belum Lengkap",
          "Mohon memilih company terlebih dahulu",
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
    await getUserInspection();
    await getCategory();
    await getCompany();
    await getDivision();
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

  Future<void> getUserInspection() async {
    final data = await DatabaseUserInspection.selectData();
    listUserInspection = data;
    log('cek list user inspection : $listUserInspection');
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

  Future<void> getDivision() async {
    final data = await DatabaseDivisionInspection.selectData();
    listDivision = data;
    log('cek list dision : $listDivision');
    setState(() {});
  }

  void initialSelectedUser() {
    if (selectedCategory?.name != 'Estate') {
      selectedUserInspection = listUserInspection.first;
      setState(() {});
    }
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
        status: 'waiting',
        description: desctiptionController.text,
        attachments: listInspectionPhoto,
        responses: [],
      );
      await DatabaseTicketInspection.insertData(ticketInspection);
      _navigationService.pop();
    }
  }

  @override
  void dispose() {
    desctiptionController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        return MediaQuery(
          data: Style.mediaQueryText(context),
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
                            child: Text(gpsLocation, textAlign: TextAlign.end))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Kategori :')),
                        SizedBox(width: 12),
                        Expanded(
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
                        Expanded(child: Text('Company :')),
                        SizedBox(width: 12),
                        Expanded(
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
                                initialSelectedUser();
                                log('selectedCompany : $selectedCompany');
                                setState(() {});
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    if (selectedCategory?.name == 'Estate')
                      Row(
                        children: [
                          Expanded(child: Text('Divisi :')),
                          SizedBox(width: 12),
                          Expanded(
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
                                  selectedUserInspection =
                                      listUserInspection.first;
                                  log('selected divisi : $selectedDivision');
                                  setState(() {});
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    Row(
                      children: [
                        Expanded(child: Text('User Assign :')),
                        SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final data = await _navigationService
                                  .push(Routes.INSPECTION_USER);
                              selectedUserInspection = data;
                              setState(() {});
                              log('selected user inspection : $selectedUserInspection');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: themeNotifier.status == true ||
                                                MediaQuery.of(context)
                                                        .platformBrightness ==
                                                    Brightness.dark
                                            ? Colors.white
                                            : Colors.grey.shade400,
                                        width: 0.5)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: selectedUserInspection != null
                                          ? Text(selectedUserInspection!.name)
                                          : Text(
                                              'Pilih User',
                                              style: TextStyle(
                                                  color: themeNotifier.status ==
                                                              true ||
                                                          MediaQuery.of(context)
                                                                  .platformBrightness ==
                                                              Brightness.dark
                                                      ? Colors.grey.shade500
                                                      : Colors.black
                                                          .withOpacity(0.35)),
                                            ),
                                    ),
                                    Icon(Icons.arrow_drop_down,
                                        color: themeNotifier.status == true ||
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
                    SizedBox(height: 8),
                    Text('Deskripsi :'),
                    SizedBox(height: 6),
                    InputPrimary(
                      controller: desctiptionController,
                      maxLines: 10,
                      hintText: 'Masukkan Deskripsi',
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
                        await createInspection();
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
