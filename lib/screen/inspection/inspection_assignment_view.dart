import 'package:epms/base/common/locator.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/base/ui/theme_notifier.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/screen/inspection/components/input_primary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InspectionAssignmentView extends StatefulWidget {
  const InspectionAssignmentView({super.key});

  @override
  State<InspectionAssignmentView> createState() =>
      _InspectionAssignmentViewState();
}

class _InspectionAssignmentViewState extends State<InspectionAssignmentView> {
  NavigatorService _navigationService = locator<NavigatorService>();
  final inspectionController =
      TextEditingController(text: 'Test Pengaduan Inspection');
  final actionController = TextEditingController();
  final listAction = ['On Progress', 'Re-Assign', 'Complete'];
  final listUserAssign = ['User 1', 'User 2', 'User 3'];
  String? action;
  String? userAssign;

  @override
  void initState() {
    action = 'On Progress';
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
            appBar: AppBar(title: Text("Assignment")),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pengaduan :'),
                    SizedBox(height: 6),
                    InputPrimary(
                      controller: inspectionController,
                      maxLines: 5,
                      validator: (value) => null,
                      readOnly: true,
                    ),
                    Text('Tindakan :'),
                    SizedBox(height: 6),
                    InputPrimary(
                      controller: actionController,
                      maxLines: 5,
                      hintText: 'Masukkan Tindakan',
                      validator: (value) => null,
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
