import 'package:epms/base/ui/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DialogPreviewPhotoOffline extends StatefulWidget {
  const DialogPreviewPhotoOffline({
    super.key,
    required this.image,
    this.onTapClose,
  });

  final Uint8List image;
  final Function()? onTapClose;

  @override
  State<DialogPreviewPhotoOffline> createState() =>
      _DialogPreviewPhotoOfflineState();
}

class _DialogPreviewPhotoOfflineState extends State<DialogPreviewPhotoOffline> {
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
          child: PhotoView(
            imageProvider: MemoryImage(widget.image),
            minScale: 0.65,
            maxScale: 3.0,
          ),
        ),
        actions: [
          InkWell(
            onTap: widget.onTapClose,
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
