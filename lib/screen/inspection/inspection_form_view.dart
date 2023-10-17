import 'package:epms/base/common/locator.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/base/ui/theme_notifier.dart';
import 'package:epms/common_manager/camera_service.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/screen/inspection/components/input_primary.dart';
import 'package:epms/screen/inspection/components/inspection_photo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InspectionFormView extends StatefulWidget {
  const InspectionFormView({super.key});

  @override
  State<InspectionFormView> createState() => _InspectionFormViewState();
}

class _InspectionFormViewState extends State<InspectionFormView> {
  NavigatorService _navigationService = locator<NavigatorService>();
  final listInspectionCategory = ['Kategori 1', 'Kategori 2', 'Kategori 3'];
  final listInspectionCompany = ['Company 1', 'Company 2', 'Company 3'];
  final listInspectionDivisi = ['Divisi 1', 'Divisi 2', 'Divisi 3'];
  String? inspectionCategory;
  String? inspectionCompany;
  String? inspectionDivisi;
  final inspectionController = TextEditingController();
  final listInspectionPhoto = [];
  var isAutoAssign = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    inspectionController.dispose();
    super.dispose();
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
                            value: inspectionCategory,
                            style: Style.whiteBold14.copyWith(
                              fontWeight: FontWeight.normal,
                              color: themeNotifier.status == true ||
                                      MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            items: listInspectionCategory.map((value) {
                              return DropdownMenuItem(
                                child: Text(value),
                                value: value,
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              if (value != null) {
                                inspectionCategory = value;
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
                            value: inspectionCompany,
                            style: Style.whiteBold14.copyWith(
                              fontWeight: FontWeight.normal,
                              color: themeNotifier.status == true ||
                                      MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            items: listInspectionCompany.map((value) {
                              return DropdownMenuItem(
                                child: Text(value),
                                value: value,
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              if (value != null) {
                                inspectionCompany = value;
                                setState(() {});
                              }
                            },
                          ),
                        )
                      ],
                    ),
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
                            value: inspectionDivisi,
                            style: Style.whiteBold14.copyWith(
                              fontWeight: FontWeight.normal,
                              color: themeNotifier.status == true ||
                                      MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            items: listInspectionDivisi.map((value) {
                              return DropdownMenuItem(
                                child: Text(value),
                                value: value,
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              if (value != null) {
                                inspectionDivisi = value;
                                setState(() {});
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text('Auto Assign :'),
                        SizedBox(width: 12),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Checkbox(
                              value: isAutoAssign,
                              onChanged: (value) {
                                if (value != null) {
                                  isAutoAssign = value;
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Text('Deskripsi :'),
                    SizedBox(height: 6),
                    InputPrimary(
                      controller: inspectionController,
                      maxLines: 3,
                      hintText: 'Masukkan Deskripsi Inspection',
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
                      onTap: () async {
                        if (listInspectionPhoto.length != 4) {
                          final result =
                              await CameraService.getImageByCamera(context);
                          if (result != null) {
                            listInspectionPhoto.add(result);
                            setState(() {});
                          }
                        } else {
                          FlushBarManager.showFlushBarWarning(
                              _navigationService.navigatorKey.currentContext!,
                              "Foto Inspection",
                              "Maksimal 4 foto yang dapat Anda lampirkan");
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
                              "FOTO HASIL INSPECTION",
                              style: Style.whiteBold14,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _navigationService.pop();
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
