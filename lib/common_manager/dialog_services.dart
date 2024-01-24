import 'dart:async';

import 'package:epms/model/supervisor.dart';
import 'package:flutter/foundation.dart';

class DialogService {
  late Function(NoOptionDialogRequest) _showNoOptionDialogListener;
  late Function(OptionDialogRequest) _showOptionDialogListener;
  late Function(SupervisorDialogRequest) _showSupervisorDialogListener;
  late Function(NFCDialogRequest) _showNFCDialogListener;
  late Function(LoadingDialogRequest) _showLoadingDialogListener;
  late Function(DialogScanOPHRequest) _showDialogScanOPHListener;
  late Function(DialogPreviewPhotoRequest) _showDialogPreviewPhotoListener;
  late Function(DialogPreviewPhotoOfflineRequest)
      _showDialogPreviewPhotoOfflineListener;
  late Function(DialogAttachmentRequest) _showDialogAttachmentListener;
  late Function(DialogSubmitInspectionRequest)
      _showDialogSubmitInspectionRequest;
  late Function _popDialogListener;
  Completer? _dialogCompleter;

  /// Registers a callback function. Typically to show the dialog
  void registerDialogListener(
    Function(NoOptionDialogRequest) showNoOptionDialogListener,
    Function(OptionDialogRequest) showOptionDialogListener,
    Function(SupervisorDialogRequest) showSupervisorDialogListener,
    Function(NFCDialogRequest) showNFCDialogListener,
    Function(LoadingDialogRequest) showLoadingDialogListener,
    Function(DialogScanOPHRequest) showDialogScanOPHListener,
    Function(DialogPreviewPhotoRequest) showDialogPreviewPhotoListener,
    Function(DialogPreviewPhotoOfflineRequest)
        showDialogPreviewPhotoOfflineListener,
    Function(DialogAttachmentRequest) showDialogAttachmentListener,
    Function(DialogSubmitInspectionRequest) showDialogSubmitInspectionRequest,
    Function popDialogListener,
  ) {
    _showNoOptionDialogListener = showNoOptionDialogListener;
    _showOptionDialogListener = showOptionDialogListener;
    _showSupervisorDialogListener = showSupervisorDialogListener;
    _showNFCDialogListener = showNFCDialogListener;
    _showLoadingDialogListener = showLoadingDialogListener;
    _showDialogScanOPHListener = showDialogScanOPHListener;
    _showDialogPreviewPhotoListener = showDialogPreviewPhotoListener;
    _showDialogPreviewPhotoOfflineListener =
        showDialogPreviewPhotoOfflineListener;
    _showDialogAttachmentListener = showDialogAttachmentListener;
    _showDialogSubmitInspectionRequest = showDialogSubmitInspectionRequest;
    _popDialogListener = popDialogListener;
  }

  /// Calls the dialog listener and returns a Future that will wait for dialogComplete.
  Future showNoOptionDialog(
      {required String title,
      required String subtitle,
      required Function()? onPress,
      String buttonText = 'OK'}) {
    _dialogCompleter = Completer();
    _showNoOptionDialogListener(NoOptionDialogRequest(
        title: title,
        subtitle: subtitle,
        onPress: onPress,
        buttonText: buttonText));
    return _dialogCompleter!.future;
  }

  Future showOptionDialog({
    required String title,
    required String subtitle,
    required String buttonTextYes,
    required String buttonTextNo,
    required Function()? onPressYes,
    required Function()? onPressNo,
  }) {
    _dialogCompleter = Completer();
    _showOptionDialogListener(OptionDialogRequest(
        onPressYes: onPressYes,
        subtitle: subtitle,
        title: title,
        buttonTextYes: buttonTextYes,
        onPressNo: onPressNo,
        buttonTextNo: buttonTextNo));
    return _dialogCompleter!.future;
  }

  Future showSupervisorDialog({Supervisor? supervisor, Function()? onPress}) {
    _dialogCompleter = Completer();
    _showSupervisorDialogListener(
        SupervisorDialogRequest(onPress: onPress, supervisor: supervisor));
    return _dialogCompleter!.future;
  }

  Future showNFCDialog({
    required String title,
    required String subtitle,
    required String buttonText,
    required Function()? onPress,
  }) {
    _dialogCompleter = Completer();
    _showNFCDialogListener(NFCDialogRequest(
      onPress: onPress,
      buttonText: buttonText,
      subtitle: subtitle,
      title: title,
    ));
    return _dialogCompleter!.future;
  }

  Future showLoadingDialog({
    required String title,
  }) {
    _dialogCompleter = Completer();
    _showLoadingDialogListener(LoadingDialogRequest(
      title: title,
    ));
    return _dialogCompleter!.future;
  }

  Future showDialogScanOPH({
    required String title,
    required String subtitle,
    required int ophCount,
    required String lastOPH,
    required String buttonText,
    required Function()? onPress,
  }) {
    _dialogCompleter = Completer();
    _showDialogScanOPHListener(DialogScanOPHRequest(
        onPress: onPress,
        buttonText: buttonText,
        subtitle: subtitle,
        title: title,
        lastOPH: lastOPH,
        ophCount: ophCount));
    return _dialogCompleter!.future;
  }

  Future showDialogPreviewPhoto({
    required String imagePath,
    required Function() onTapClose,
  }) {
    _dialogCompleter = Completer();
    _showDialogPreviewPhotoListener(
      DialogPreviewPhotoRequest(imagePath: imagePath, onTapClose: onTapClose),
    );
    return _dialogCompleter!.future;
  }

  Future showDialogPreviewPhotoOffline({
    required Uint8List image,
    required Function() onTapClose,
  }) {
    _dialogCompleter = Completer();
    _showDialogPreviewPhotoOfflineListener(
      DialogPreviewPhotoOfflineRequest(image: image, onTapClose: onTapClose),
    );
    return _dialogCompleter!.future;
  }

  Future showDialogAttachment({
    required Function() onTapCamera,
    required Function() onTapGallery,
    required Function() onTapCancel,
  }) {
    _dialogCompleter = Completer();
    _showDialogAttachmentListener(
      DialogAttachmentRequest(
        onTapCamera: onTapCamera,
        onTapGallery: onTapGallery,
        onTapCancel: onTapCancel,
      ),
    );
    return _dialogCompleter!.future;
  }

  Future showDialogSubmitInspection({
    required String title,
    required String desc,
    required String labelConfirm,
    required String labelCancel,
    required Function() onTapConfirm,
    required Function() onTapCancel,
  }) {
    _dialogCompleter = Completer();
    _showDialogSubmitInspectionRequest(
      DialogSubmitInspectionRequest(
        title: title,
        desc: desc,
        labelConfirm: labelConfirm,
        labelCancel: labelCancel,
        onTapConfirm: onTapConfirm,
        onTapCancel: onTapCancel,
      ),
    );
    return _dialogCompleter!.future;
  }

  void popDialog() {
    _dialogCompleter!.complete();
    _popDialogListener();
    _dialogCompleter = null;
  }

  /// Completes the _dialogCompleter to resume the Future's execution call
  void dialogComplete() {
    _dialogCompleter!.complete();
    _dialogCompleter = null;
  }
}

/// MODELS

class OptionDialogRequest {
  String title;
  String subtitle;
  String buttonTextYes;
  String buttonTextNo;
  Function()? onPressYes;
  Function()? onPressNo;

  OptionDialogRequest(
      {required this.title,
      required this.subtitle,
      required this.buttonTextYes,
      required this.buttonTextNo,
      required this.onPressYes,
      required this.onPressNo});
}

class NoOptionDialogRequest {
  String title;
  String subtitle;
  String buttonText;
  Function()? onPress;

  NoOptionDialogRequest({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onPress,
  });
}

class NFCDialogRequest {
  String title;
  String subtitle;
  String buttonText;
  Function()? onPress;

  NFCDialogRequest({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onPress,
  });
}

class SupervisorDialogRequest {
  Supervisor? supervisor;
  Function()? onPress;

  SupervisorDialogRequest({required this.supervisor, required this.onPress});
}

class LoadingDialogRequest {
  String title;

  LoadingDialogRequest({required this.title});
}

class DialogScanOPHRequest {
  String title;
  String subtitle;
  int ophCount;
  String lastOPH;
  String buttonText;
  Function()? onPress;

  DialogScanOPHRequest({
    required this.title,
    required this.subtitle,
    required this.ophCount,
    required this.lastOPH,
    required this.buttonText,
    required this.onPress,
  });
}

class DialogPreviewPhotoRequest {
  String imagePath;
  Function()? onTapClose;

  DialogPreviewPhotoRequest({
    required this.imagePath,
    required this.onTapClose,
  });
}

class DialogPreviewPhotoOfflineRequest {
  Uint8List image;
  Function()? onTapClose;

  DialogPreviewPhotoOfflineRequest({
    required this.image,
    required this.onTapClose,
  });
}

class DialogAttachmentRequest {
  Function() onTapCamera;
  Function() onTapGallery;
  Function() onTapCancel;

  DialogAttachmentRequest({
    required this.onTapCamera,
    required this.onTapGallery,
    required this.onTapCancel,
  });
}

class DialogSubmitInspectionRequest {
  String title;
  String desc;
  String labelConfirm;
  String labelCancel;
  Function() onTapConfirm;
  Function() onTapCancel;

  DialogSubmitInspectionRequest({
    required this.title,
    required this.desc,
    required this.labelConfirm,
    required this.labelCancel,
    required this.onTapConfirm,
    required this.onTapCancel,
  });
}
