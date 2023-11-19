import 'dart:developer';
import 'dart:io';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/base/ui/theme_notifier.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/database/helper/convert_helper.dart';
import 'package:epms/database/service/database_action_inspection.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/model/history_inspection_model.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/screen/inspection/components/card_history_inspection.dart';
import 'package:epms/screen/inspection/components/input_primary.dart';
import 'package:flutter/material.dart';
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
  final descriptionController = TextEditingController();
  final noteController = TextEditingController();
  // final listAction = ['Close', 'Revisi', 'Need Consultation'];
  final listUserConsultation = [
    'Khairul Nasution',
    'Satria Pinandito',
    'Nelson Suwiko'
  ];
  // String? action;
  String? userConsultation;
  List<HistoryInspectionModel> listHistoryInspection = [];

  List<String> listActionOption = const [];
  String? selectedAction;

  @override
  void initState() {
    descriptionController.text = widget.data.description;
    listHistoryInspection = widget.data.history;
    getOptionAction();
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

  Future<void> submit() async {
    final dataHistory = HistoryInspectionModel(
      user: 'Andrian Arsil',
      userReAssign: listHistoryInspection.last.userReAssign,
      userConsultation: userConsultation ?? '',
      response: noteController.text.isNotEmpty ? noteController.text : '-',
      status: selectedAction ?? '-',
      date: DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
    );
    listHistoryInspection.add(dataHistory);
    final dataInspection = TicketInspectionModel(
      id: widget.data.id,
      date: widget.data.date,
      category: widget.data.category,
      company: widget.data.company,
      division: widget.data.division,
      latitude: widget.data.latitude,
      longitude: widget.data.longitude,
      description: widget.data.description,
      userAssign: widget.data.userAssign,
      status: selectedAction ?? '-',
      images: widget.data.images,
      history: listHistoryInspection,
    );
    await DatabaseTicketInspection.updateData(dataInspection);
    _navigationService.pop();
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
                                '${widget.data.longitude},${widget.data.latitude}',
                                textAlign: TextAlign.end))
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text('Tanggal :'),
                        SizedBox(width: 12),
                        Expanded(
                            child: Text(widget.data.date,
                                textAlign: TextAlign.end))
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text('Kategori :'),
                        SizedBox(width: 12),
                        Expanded(
                            child: Text(widget.data.category,
                                textAlign: TextAlign.end))
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text('Company :'),
                        SizedBox(width: 12),
                        Expanded(
                            child: Text(widget.data.company,
                                textAlign: TextAlign.end))
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text('Divisi :'),
                        SizedBox(width: 12),
                        Expanded(
                            child: Text(widget.data.division,
                                textAlign: TextAlign.end))
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text('User Assign :'),
                        SizedBox(width: 12),
                        Expanded(
                            child: Text(widget.data.userAssign,
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
                            itemCount: widget.data.images.length,
                            itemBuilder: (context, index) {
                              final image = widget.data.images[index];
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
                    if (widget.data.history.isNotEmpty)
                      ...widget.data.history
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
                                userConsultation = null;
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
                                child: DropdownButton(
                                  isExpanded: true,
                                  hint: Text(
                                    "Pilih User",
                                    style: Style.whiteBold14.copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                  value: userConsultation,
                                  style: Style.whiteBold14.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: themeNotifier.status == true ||
                                            MediaQuery.of(context)
                                                    .platformBrightness ==
                                                Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  items: listUserConsultation.map((value) {
                                    return DropdownMenuItem(
                                      child: Text(value),
                                      value: value,
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      userConsultation = value;
                                      setState(() {});
                                    }
                                  },
                                ),
                              )
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
                        ],
                      ),
                    SizedBox(height: 12),
                    InkWell(
                      onTap: () {},
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
