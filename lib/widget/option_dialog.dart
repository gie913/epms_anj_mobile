import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:flutter/material.dart';

class OptionDialog extends StatefulWidget {
  final String title, subtitle, buttonTextYes, buttonTextNo;
  final Function()? onPressYes;
  final Function()? onPressNo;

  const OptionDialog(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.buttonTextYes,
      required this.buttonTextNo,
      this.onPressYes,
      this.onPressNo})
      : super(key: key);

  @override
  State<OptionDialog> createState() => _OptionDialogState();
}

class _OptionDialogState extends State<OptionDialog> {
  @override
  Widget build(BuildContext context) {
    return dialogContent(context);
  }

  Widget dialogContent(BuildContext context) {
    return MediaQuery(
      data: Style.mediaQueryText(context),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        title: Center(
          child: Text("${widget.title}", textAlign: TextAlign.center),
        ),
        content: Text("${widget.subtitle}", textAlign: TextAlign.center),
        actions: <Widget>[
          Row(
            children: [
              Flexible(
                child: Container(
                  child: InkWell(
                    onTap: widget.onPressYes,
                    child: Card(
                      color: Palette.primaryColorProd,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(14),
                        child: Text("${widget.buttonTextYes}",
                            style: Style.whiteBold18,
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  child: InkWell(
                    onTap: widget.onPressNo,
                    child: Card(
                      color: Palette.redColorLight,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(14),
                        child: Text("${widget.buttonTextNo}",
                            style: Style.whiteBold18,
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
