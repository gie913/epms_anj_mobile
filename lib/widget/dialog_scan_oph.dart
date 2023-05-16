import 'package:epms/base/constants/image_assets.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:flutter/material.dart';

class DialogScanOPH extends StatefulWidget {
  final String title, subtitle, buttonText, lastOPH;
  final int ophCount;
  final Function()? onPress;
  final Function()? nfcRead;

  const DialogScanOPH(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.lastOPH,
      required this.ophCount,
      required this.buttonText,
      this.onPress,
      this.nfcRead})
      : super(key: key);

  @override
  State<DialogScanOPH> createState() => _DialogScanOPHState();
}

class _DialogScanOPHState extends State<DialogScanOPH> {
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
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(children: [
            Flexible(
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text("Jumlah OPH : ${widget.ophCount}", style: Style.textBoldBlack12,),
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text("OPH terakhir yang di-scan : ${widget.lastOPH}", style: Style.textBoldBlack12,),
                ),
              ),
            ),
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
