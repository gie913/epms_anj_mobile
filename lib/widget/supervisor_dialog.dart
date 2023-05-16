import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/model/supervisor.dart';
import 'package:flutter/material.dart';

class SupervisorDialog extends StatefulWidget {
  final Supervisor supervisor;
  final Function()? onPress;

  const SupervisorDialog(
      {Key? key,
        required this.supervisor,
        this.onPress})
      : super(key: key);

  @override
  State<SupervisorDialog> createState() => _SupervisorDialogState();
}

class _SupervisorDialogState extends State<SupervisorDialog> {
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
          title: Center(child: Text("Supervisi Kemandoran")),
          content: Container(
              height: MediaQuery.of(context).size.height*0.35,
              child: Column(
                children: [
                  Text("Mandor:"),
                  Text(
                    "${widget.supervisor.mandorCode}",
                    style: Style.textBold14,
                  ),
                  Text(
                    "${widget.supervisor.mandorName}",
                    style: Style.textBold14,
                  ),
                  Divider(),
                  Text("Mandor 1:"),
                  Text("${widget.supervisor.mandor1Code}",
                      style: Style.textBold14),
                  Text("${widget.supervisor.mandor1Name}",
                      style: Style.textBold14),
                  Divider(),
                  Text("Kerani Panen:"),
                  Text("${widget.supervisor.keraniPanenCode}",
                      style: Style.textBold14),
                  Text("${widget.supervisor.keraniPanenName}",
                      style: Style.textBold14),
                  Divider(),
                  Text("Kerani Kirim"),
                  Text("${widget.supervisor.keraniKirimCode}",
                      style: Style.textBold14),
                  Text("${widget.supervisor.keraniKirimName}",
                      style: Style.textBold14),
                ],
              )),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: widget.onPress,
                    child: Card(
                      color: Palette.primaryColorProd,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(14),
                        child: Text("OK",
                            style: Style.whiteBold18,
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ))
          ]),
    );
  }
}
