import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:flutter/material.dart';

class DialogAttachment extends StatefulWidget {
  const DialogAttachment({
    super.key,
    required this.onTapCamera,
    required this.onTapGallery,
    required this.onTapCancel,
  });

  final Function() onTapCamera;
  final Function() onTapGallery;
  final Function() onTapCancel;

  @override
  State<DialogAttachment> createState() => _DialogAttachmentState();
}

class _DialogAttachmentState extends State<DialogAttachment> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: Style.mediaQueryText(context),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        insetPadding: EdgeInsets.zero,
        title:
            Center(child: Text('Ambil Foto Melalui', style: Style.textBold14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Palette.primaryColorProd,
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Palette.primaryColorProd)),
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              onPressed: widget.onTapCamera,
              child: Text("KAMERA",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 12),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Palette.primaryColorProd,
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Palette.primaryColorProd)),
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              onPressed: widget.onTapGallery,
              child: Text("GALERI",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          InkWell(
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
                    "BATAL",
                    style: Style.whiteBold14,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
