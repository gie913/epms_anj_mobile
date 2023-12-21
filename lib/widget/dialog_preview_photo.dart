import 'dart:io';

import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/inspection_service.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DialogPreviewPhoto extends StatefulWidget {
  const DialogPreviewPhoto({
    super.key,
    required this.imagePath,
    this.onTapClose,
  });

  final String imagePath;
  final Function()? onTapClose;

  @override
  State<DialogPreviewPhoto> createState() => _DialogPreviewPhotoState();
}

class _DialogPreviewPhotoState extends State<DialogPreviewPhoto> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: Style.mediaQueryText(context),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: widget.imagePath.contains('http')
              ? FutureBuilder(
                  future: InspectionService.isInternetConnectionExist(),
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return PhotoView(
                        imageProvider: NetworkImage(widget.imagePath),
                        minScale: 0.65,
                        maxScale: 3.0,
                      );
                      // return Image.network(
                      //   widget.imagePath,
                      //   fit: BoxFit.contain,
                      // );
                    } else {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.5,
                        color: Colors.orange,
                      );
                    }
                  },
                )
              // : Image.file(File(widget.imagePath), fit: BoxFit.contain),
              : PhotoView(
                  imageProvider: FileImage(File(widget.imagePath)),
                  minScale: 0.65,
                  maxScale: 3.0,
                ),
        ),
        actions: [
          InkWell(
            onTap: widget.onTapClose,
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
                    "TUTUP",
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
