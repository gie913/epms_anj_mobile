import 'package:epms/base/constants/image_assets.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:flutter/material.dart';

class NFCDialog extends StatefulWidget {
  final String title, subtitle, buttonText;
  final Function()? onPress;
  final Function()? nfcRead;

  const NFCDialog(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.buttonText,
      this.onPress,
      this.nfcRead})
      : super(key: key);

  @override
  State<NFCDialog> createState() => _NFCDialogState();
}

class _NFCDialogState extends State<NFCDialog> {
  @override
  Widget build(BuildContext context) {
    return dialogContent(context);
  }

  Widget dialogContent(BuildContext context) {
    return MediaQuery(
      data: Style.mediaQueryText(context),
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Center(
          child: Text("${widget.title}", style: Style.textBoldBlack14),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.24,
          child: Column(children: [
            Center(
              child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: 100,
                  child: Image.asset(ImageAssets.TAP_GIF)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("${widget.subtitle}", style: Style.textBoldBlack16),
            ),
            Card(
              color: Palette.redColorLight,
              child: InkWell(
                onTap: widget.onPress,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child:
                        Text("${widget.buttonText}", style: Style.whiteBold16),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
