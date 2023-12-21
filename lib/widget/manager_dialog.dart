import 'package:epms/base/common/locator.dart';
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/widget/dialog_preview_photo.dart';
import 'package:epms/widget/dialog_scan_oph.dart';
import 'package:epms/widget/loading_dialog.dart';
import 'package:epms/widget/nfc_read_dialog.dart';
import 'package:epms/widget/no_option_dialog.dart';
import 'package:epms/widget/option_dialog.dart';
import 'package:epms/widget/supervisor_dialog.dart';
import 'package:flutter/material.dart';

Widget builderDialog(BuildContext context, Widget? widget) => Navigator(
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) => DialogManager(
          child: widget,
        ),
      ),
    );

class DialogManager extends StatefulWidget {
  final Widget? child;

  DialogManager({
    Key? key,
    required this.child,
  }) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(
      _showNoOptionDialog,
      _showOptionDialog,
      _showSupervisorDialog,
      _showNFCDialog,
      _showLoadingDialog,
      _showDialogScanOPH,
      _showDialogPreviewPhoto,
      _popDialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }

  void _showNoOptionDialog(NoOptionDialogRequest request) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => NoOptionDialog(
        title: request.title,
        subtitle: request.subtitle,
        onPress: request.onPress,
        buttonText: 'OK',
      ),
    );
  }

  void _showOptionDialog(OptionDialogRequest request) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => OptionDialog(
        title: request.title,
        subtitle: request.subtitle,
        buttonTextNo: request.buttonTextNo,
        buttonTextYes: request.buttonTextYes,
        onPressYes: request.onPressYes,
        onPressNo: request.onPressNo,
      ),
    );
  }

  void _showNFCDialog(NFCDialogRequest request) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => NFCDialog(
          title: request.title,
          subtitle: request.subtitle,
          onPress: request.onPress,
          buttonText: request.buttonText),
    );
  }

  void _showSupervisorDialog(SupervisorDialogRequest request) {
    showDialog(
      context: context,
      builder: (BuildContext context) => SupervisorDialog(
        supervisor: request.supervisor!,
        onPress: request.onPress,
      ),
    );
  }

  void _showLoadingDialog(LoadingDialogRequest request) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => LoadingDialog(
        title: request.title,
      ),
    );
  }

  void _showDialogScanOPH(DialogScanOPHRequest request) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => DialogScanOPH(
        title: request.title,
        subtitle: request.subtitle,
        onPress: request.onPress,
        buttonText: request.buttonText,
        ophCount: request.ophCount,
        lastOPH: request.lastOPH,
      ),
    );
  }

  void _showDialogPreviewPhoto(DialogPreviewPhotoRequest request) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return DialogPreviewPhoto(
          imagePath: request.imagePath,
          onTapClose: request.onTapClose,
        );
      },
    );
  }

  void _popDialog() {
    Navigator.of(context).pop();
  }
}
