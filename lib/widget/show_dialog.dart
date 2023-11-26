import 'package:epms/base/ui/style.dart';
import 'package:epms/base/ui/theme_notifier.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showDialogCustom(
  BuildContext context, {
  String? title,
  TextStyle? titleStyle,
  TextAlign? titleAlign,
  required Widget content,
  List<Widget>? actions,
  EdgeInsets? titlePadding,
  EdgeInsets? actionPadding,
  EdgeInsets? contentPadding,
  MainAxisAlignment? actionsAlignment,
  bool? barrierDismissible,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? false,
    builder: (BuildContext context) {
      return Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, _) {
          return AlertDialog(
            backgroundColor: themeNotifier.status == true ||
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.white,
            surfaceTintColor: themeNotifier.status == true ||
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.white,
            titlePadding:
                titlePadding ?? const EdgeInsets.fromLTRB(24, 16, 24, 12),
            contentPadding:
                contentPadding ?? const EdgeInsets.symmetric(horizontal: 24),
            actionsPadding:
                actionPadding ?? const EdgeInsets.fromLTRB(24, 12, 24, 16),
            insetPadding: const EdgeInsets.all(24),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            titleTextStyle: titleStyle ??
                Style.textBold14.copyWith(
                  color: themeNotifier.status == true ||
                          MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
            title: Text(title ?? '', textAlign: titleAlign ?? TextAlign.left),
            content: content,
            actionsAlignment: actionsAlignment,
            actions: actions,
          );
        },
      );
    },
  );
}

void showDialogLoading(BuildContext context, String message) {
  showDialogCustom(
    context,
    barrierDismissible: true,
    title: 'Loading',
    titleAlign: TextAlign.center,
    actions: [const SizedBox()],
    content: Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpinKitThreeBounce(size: 20, color: Colors.orange),
            Text(
              message,
              style: Style.textBold14.copyWith(
                color: themeNotifier.status == true ||
                        MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        );
      },
    ),
  );
}
