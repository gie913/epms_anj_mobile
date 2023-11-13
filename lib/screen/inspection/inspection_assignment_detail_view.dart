import 'dart:io';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/base/ui/theme_notifier.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/model/history_inspection_model.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/screen/inspection/components/card_history_inspection.dart';
import 'package:epms/screen/inspection/components/input_primary.dart';
import 'package:flutter/material.dart';
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
  final inspectionController = TextEditingController();
  final actionController = TextEditingController();
  final listAction = ['On Progress', 'Re-Assign', 'Complete'];
  final listUserReAssign = ['Yogi', 'Ari', 'Adriansyah'];
  String? action;
  String? userReAssign;
  List<HistoryInspectionModel> listHistoryInspection = [];

  @override
  void initState() {
    inspectionController.text = widget.data.report;
    listHistoryInspection = widget.data.history;
    setState(() {});
    super.initState();
  }

  Future<void> submit() async {
    final dataHistory = HistoryInspectionModel(
      user: widget.data.userAssign,
      userReAssign: userReAssign ?? '',
      response: actionController.text,
      status: action ?? '-',
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
      report: widget.data.report,
      userAssign: widget.data.userAssign,
      status: action ?? '-',
      images: widget.data.images,
      history: listHistoryInspection,
    );
    await DatabaseTicketInspection.updateData(dataInspection);
    _navigationService.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        return MediaQuery(
          data: Style.mediaQueryText(context),
          child: Scaffold(
            appBar: AppBar(title: Text("Assignment Detail")),
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
                    Row(
                      children: [
                        Text('Status :'),
                        SizedBox(width: 12),
                        Expanded(
                            child: Text(widget.data.status,
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
                                child: Image.file(
                                  File(image),
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: MediaQuery.of(context).size.width / 4,
                                  fit: BoxFit.fill,
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
                      controller: inspectionController,
                      maxLines: 10,
                      validator: (value) => null,
                      readOnly: true,
                    ),
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
                            value: action,
                            style: Style.whiteBold14.copyWith(
                              fontWeight: FontWeight.normal,
                              color: themeNotifier.status == true ||
                                      MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            items: listAction.map((value) {
                              return DropdownMenuItem(
                                child: Text(value),
                                value: value,
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              if (value != null) {
                                action = value;
                                setState(() {});
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    if (action == 'Re-Assign')
                      Row(
                        children: [
                          Expanded(child: Text('User Re-Assign :')),
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
                              value: userReAssign,
                              style: Style.whiteBold14.copyWith(
                                fontWeight: FontWeight.normal,
                                color: themeNotifier.status == true ||
                                        MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              items: listUserReAssign.map((value) {
                                return DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  userReAssign = value;
                                  setState(() {});
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    Text('Tindakan :'),
                    SizedBox(height: 6),
                    InputPrimary(
                      controller: actionController,
                      maxLines: 10,
                      hintText: 'Masukkan Tindakan',
                      validator: (value) => null,
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
