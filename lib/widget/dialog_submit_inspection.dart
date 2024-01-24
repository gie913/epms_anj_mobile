import 'package:epms/base/ui/style.dart';
import 'package:flutter/material.dart';

class DialogSubmitInspection extends StatefulWidget {
  const DialogSubmitInspection({
    super.key,
    required this.title,
    required this.desc,
    required this.labelConfirm,
    required this.labelCancel,
    required this.onTapConfirm,
    required this.onTapCancel,
  });

  final String title;
  final String desc;
  final String labelConfirm;
  final String labelCancel;
  final Function() onTapConfirm;
  final Function() onTapCancel;

  @override
  State<DialogSubmitInspection> createState() => _DialogSubmitInspectionState();
}

class _DialogSubmitInspectionState extends State<DialogSubmitInspection> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: Style.mediaQueryText(context),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        insetPadding: EdgeInsets.zero,
        title: Center(child: Text(widget.title, style: Style.textBold14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.desc, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: widget.onTapConfirm,
                  child: Card(
                    color: Colors.green,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          widget.labelConfirm,
                          style: Style.whiteBold14,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: widget.onTapCancel,
                  child: Card(
                    color: Colors.red,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          widget.labelCancel,
                          style: Style.whiteBold14,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
