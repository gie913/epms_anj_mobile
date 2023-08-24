import 'dart:convert';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/model/auth_model.dart';
import 'package:flutter/material.dart';

class DialogApprovalTbsLuar extends StatefulWidget {
  final String title;
  final String labelButton;
  final String hintText;
  final ValueSetter<bool> onSubmit;
  final List<AuthModel> listAuthenticator;
  final AuthModel selectedAuthenticator;
  final ValueSetter<AuthModel> onChangeAuthenticator;

  const DialogApprovalTbsLuar({
    Key? key,
    required this.title,
    required this.labelButton,
    required this.hintText,
    required this.onSubmit,
    required this.listAuthenticator,
    required this.selectedAuthenticator,
    required this.onChangeAuthenticator,
  }) : super(key: key);

  @override
  State<DialogApprovalTbsLuar> createState() => _DialogApprovalTbsLuarState();
}

class _DialogApprovalTbsLuarState extends State<DialogApprovalTbsLuar> {
  final controller = TextEditingController();
  NavigatorService _navigationService = locator<NavigatorService>();
  AuthModel selectedAuthenticator = AuthModel();
  bool obsecureText = true;

  @override
  void initState() {
    super.initState();
    selectedAuthenticator = widget.selectedAuthenticator;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: Style.mediaQueryText(context),
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(widget.title, style: Style.textBoldBlack14),
        ),
        actions: [
          Card(
            color: Palette.greenColor,
            child: InkWell(
              onTap: () {
                if (controller.text.isEmpty) {
                  FlushBarManager.showFlushBarWarning(
                      _navigationService.navigatorKey.currentContext!,
                      "Approval Manager",
                      "Masukkan PIN Approval Terlebih dahulu");
                } else {
                  final pinEncode = base64Encode(utf8.encode(controller.text));
                  if (selectedAuthenticator.pin != pinEncode) {
                    widget.onSubmit(false);
                    Navigator.pop(context);
                    FlushBarManager.showFlushBarWarning(
                        _navigationService.navigatorKey.currentContext!,
                        "Approval Manager",
                        "PIN Approval Salah");
                  } else {
                    widget.onSubmit(true);
                  }
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                child: Center(
                    child: Text(widget.labelButton, style: Style.whiteBold16)),
              ),
            ),
          )
        ],
        content: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text('Pilih Manager', style: Style.textBoldBlack14),
                SizedBox(width: 12),
                Expanded(
                  flex: 5,
                  child: DropdownButton(
                    isExpanded: true,
                    value: selectedAuthenticator,
                    items: widget.listAuthenticator.map((value) {
                      return DropdownMenuItem(
                        child: Text(value.supervisiName),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedAuthenticator = value;
                        });
                        widget.onChangeAuthenticator(value);
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 4, child: Text('PIN', style: Style.textBoldBlack14)),
                SizedBox(width: 12),
                Expanded(
                  flex: 7,
                  child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    obscureText: obsecureText,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            obsecureText = !obsecureText;
                          });
                        },
                        child: Icon(
                          obsecureText
                              ? Icons.visibility
                              : Icons.visibility_off,
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
    );
  }
}
