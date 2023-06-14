import 'package:epms/base/common/locator.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:flutter/material.dart';

class DialogApprovalTbsLuar extends StatefulWidget {
  final String title;
  final String labelButton;
  final String hintText;
  final ValueSetter<String> onPress;

  const DialogApprovalTbsLuar({
    Key? key,
    required this.title,
    required this.labelButton,
    required this.hintText,
    required this.onPress,
  }) : super(key: key);

  @override
  State<DialogApprovalTbsLuar> createState() => _DialogApprovalTbsLuarState();
}

class _DialogApprovalTbsLuarState extends State<DialogApprovalTbsLuar> {
  final controller = TextEditingController();
  NavigatorService _navigationService = locator<NavigatorService>();

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
                  widget.onPress(controller.text);
                  Navigator.pop(context);
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
        content: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          child: Center(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: widget.hintText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
