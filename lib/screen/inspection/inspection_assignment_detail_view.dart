import 'package:epms/base/common/locator.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/base/ui/theme_notifier.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/screen/inspection/components/input_primary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InspectionAssignmentDetailView extends StatefulWidget {
  const InspectionAssignmentDetailView({super.key, required this.data});

  final Map<String, dynamic> data;

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
  final listUserAssign = ['User 1', 'User 2', 'User 3'];
  String? action;
  String? userAssign;

  @override
  void initState() {
    action = widget.data['status'];
    inspectionController.text = widget.data['report'];
    setState(() {});
    super.initState();
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
                    Text(widget.data['id']),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text('Lokasi Buat :'),
                        SizedBox(width: 12),
                        Expanded(
                            child: Text(
                                '${widget.data['longitude']},${widget.data['latitude']}',
                                textAlign: TextAlign.end))
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text('Tanggal :'),
                        SizedBox(width: 12),
                        Expanded(
                            child: Text(widget.data['date'],
                                textAlign: TextAlign.end))
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text('Kategori :'),
                        SizedBox(width: 12),
                        Expanded(
                            child: Text(widget.data['category'],
                                textAlign: TextAlign.end))
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text('Company :'),
                        SizedBox(width: 12),
                        Expanded(
                            child: Text(widget.data['company'],
                                textAlign: TextAlign.end))
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text('Divisi :'),
                        SizedBox(width: 12),
                        Expanded(
                            child: Text(widget.data['divisi'],
                                textAlign: TextAlign.end))
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text('User Assign :'),
                        SizedBox(width: 12),
                        Expanded(
                            child: Text(widget.data['user_assign'],
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
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Container(
                                width: MediaQuery.of(context).size.width / 4,
                                height: MediaQuery.of(context).size.width / 4,
                                color: Colors.amber,
                                margin: EdgeInsets.only(right: 12),
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
                    if ((widget.data['history'] as List).isNotEmpty)
                      Text('Riwayat Tindakan :'),
                    ...(widget.data['history'] as List).map((item) {
                      return Card(
                        color: Palette.primaryColorProd,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['user'],
                                      style: Style.whiteBold14.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Tanggal :',
                                          style: Style.whiteBold12.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            item['date'],
                                            style: Style.whiteBold12.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Kategori :',
                                          style: Style.whiteBold12.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            item['category'],
                                            style: Style.whiteBold12.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Company :',
                                          style: Style.whiteBold12.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            item['company'],
                                            style: Style.whiteBold12.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Divisi :',
                                          style: Style.whiteBold12.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            item['divisi'],
                                            style: Style.whiteBold12.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Tindakan :',
                                          style: Style.whiteBold12.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            item['response'].toString().isEmpty
                                                ? '-'
                                                : item['response'],
                                            style: Style.whiteBold12.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                    if (item['user_re_assign']
                                        .toString()
                                        .isNotEmpty)
                                      Row(
                                        children: [
                                          Text(
                                            'User Re-Assign :',
                                            style: Style.whiteBold12.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              item['user_re_assign'],
                                              style: Style.whiteBold12.copyWith(
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          )
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                item['status'],
                                style: Style.whiteBold12.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
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
                              value: userAssign,
                              style: Style.whiteBold14.copyWith(
                                fontWeight: FontWeight.normal,
                                color: themeNotifier.status == true ||
                                        MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              items: listUserAssign.map((value) {
                                return DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  userAssign = value;
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
